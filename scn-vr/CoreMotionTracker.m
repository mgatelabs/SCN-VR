/************************************************************************
	
 
	Copyright (C) 2015  Michael Glen Fuller Jr.
 
	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.
 
	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.
 
	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.
 
 ************************************************************************/

#import "CoreMotionTracker.h"
#import "SCNVRResourceBundler.h"

@implementation CoreMotionTracker {
    GLKQuaternion rotationFix;
    CMQuaternion _currentAttitude_noQ;
    NSOperationQueue * _queue;
    BOOL useMagnet;
    int _frames;
    NSTimeInterval _startTimestamp;
    int _frameIndex;
    float _framesValues[91];
}

-(float) getTestValueFor:(int) index {
    return _framesValues[index];
}

- (instancetype)initWithMagnet: (CMMotionManager *) manager
{
    self = [super initWith: NSLocalizedStringFromTableInBundle(@"TRACKER_COREMOTION", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"CoreMotion") identity:@"corewithmagnet"];
    if (self) {
        rotationFix = GLKQuaternionMakeWithAngleAndAxis(-M_PI_2, 0, 0, 1);
        
        self.motionManager = manager;
        
        useMagnet = self.motionManager.magnetometerAvailable;
        
        _queue = [[NSOperationQueue alloc] init];
        //_queue.maxConcurrentOperationCount = 5;
    }
    return self;
}

- (instancetype)initWithoutMagnet: (CMMotionManager *) manager {
    self = [super initWith: NSLocalizedStringFromTableInBundle(@"TRACKER_COREMOTION_NO_MAG", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"CoreMotion NO Magnetometer") identity:@"corewithoutmagnet"];
    if (self) {
        rotationFix = GLKQuaternionMakeWithAngleAndAxis(-M_PI_2, 0, 0, 1);
        
        self.motionManager = manager;
        
        useMagnet = NO;
        
        _queue = [[NSOperationQueue alloc] init];
    }
    return self;
}

-(void) start {
    
    if (_testTiming) {
        for (int i = 0; i < 91; i++) {
            _framesValues[i] = -1;
        }
        _testProgress = 0;
        _frameIndex = 0;
    }
    
    self.motionManager.showsDeviceMovementDisplay = useMagnet;
    
    CMAttitudeReferenceFrame frame = useMagnet ? CMAttitudeReferenceFrameXArbitraryCorrectedZVertical : CMAttitudeReferenceFrameXArbitraryZVertical;
    
    self.foundTiming = 0;
    _frames = 0;
    
    if (_testTiming) {
        
        [self.motionManager startDeviceMotionUpdatesUsingReferenceFrame:frame toQueue:_queue withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
            if (error == nil) {
                            
    #if !(TARGET_IPHONE_SIMULATOR)
                
                CMQuaternion currentAttitude_noQ = motion.attitude.quaternion;
                
                GLKQuaternion baseRotation = GLKQuaternionMake(currentAttitude_noQ.x, currentAttitude_noQ.y, currentAttitude_noQ.z, currentAttitude_noQ.w);
                
                if (self.landscape) {
                    self.orientation = GLKQuaternionMultiply(baseRotation, rotationFix);
                } else {
                    self.orientation = GLKQuaternionMultiply(rotationFix, baseRotation);
                }
              
                if (_testTiming) {
                    if (_frames == 0) {
                        _startTimestamp = motion.timestamp;
                    }
                    _frames++;
                    if (_frames >= (_frameIndex + 10) * 2) {
                        double diff = motion.timestamp - _startTimestamp;
                        if (diff > 0.00) {
                            self.foundTiming = (double)_frames / diff;
                        }
                        _framesValues[_frameIndex] = self.foundTiming;

                        _frameIndex++;
                        
                        _testProgress = _frameIndex / 90.0f;
                        
                        if (_frameIndex <= 90) {
                            self.motionManager.deviceMotionUpdateInterval = (1 / (_frameIndex + 10.0));
                            _frames = -1;
                            _startTimestamp = motion.timestamp;
                        } else {
                            _testTiming = NO;
                        }
                    }
                }
                
    #else
                // For Testing
                self.orientation = GLKQuaternionMultiply(rotationFix, GLKQuaternionMakeWithAngleAndAxis(90 * 0.0174532925f, 1, 0, 0));
    #endif
            }
        }];
        
    } else if (_checkTiming) {
        
        [self.motionManager startDeviceMotionUpdatesUsingReferenceFrame:frame toQueue:_queue withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
            if (error == nil) {
                            
    #if !(TARGET_IPHONE_SIMULATOR)
                
                CMQuaternion currentAttitude_noQ = motion.attitude.quaternion;
                
                GLKQuaternion baseRotation = GLKQuaternionMake(currentAttitude_noQ.x, currentAttitude_noQ.y, currentAttitude_noQ.z, currentAttitude_noQ.w);
                
                if (self.landscape) {
                    self.orientation = GLKQuaternionMultiply(baseRotation, rotationFix);
                } else {
                    self.orientation = GLKQuaternionMultiply(rotationFix, baseRotation);
                }

                if (_frames == 0) {
                    _startTimestamp = motion.timestamp;
                }
                _frames++;
                if (_frames >= 100) {
                    double diff = motion.timestamp - _startTimestamp;
                    if (diff > 0.00) {
                        self.foundTiming = (double)_frames / diff;
                    }
                    _frames = 0;
                    _startTimestamp = motion.timestamp;
                }
                
    #else
                // For Testing
                self.orientation = GLKQuaternionMultiply(rotationFix, GLKQuaternionMakeWithAngleAndAxis(90 * 0.0174532925f, 1, 0, 0));
    #endif
            }
        }];
        
    } else {
        [self.motionManager startDeviceMotionUpdatesUsingReferenceFrame:frame toQueue:_queue withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
            if (error == nil) {
                            
    #if !(TARGET_IPHONE_SIMULATOR)
                
                CMQuaternion currentAttitude_noQ = motion.attitude.quaternion;
                
                GLKQuaternion baseRotation = GLKQuaternionMake(currentAttitude_noQ.x, currentAttitude_noQ.y, currentAttitude_noQ.z, currentAttitude_noQ.w);
                
                if (self.landscape) {
                    self.orientation = GLKQuaternionMultiply(baseRotation, rotationFix);
                } else {
                    self.orientation = GLKQuaternionMultiply(rotationFix, baseRotation);
                }
    #else
                // For Testing
                self.orientation = GLKQuaternionMultiply(rotationFix, GLKQuaternionMakeWithAngleAndAxis(90 * 0.0174532925f, 1, 0, 0));
    #endif
            }
        }];
    }
    
    [self.motionManager startDeviceMotionUpdatesUsingReferenceFrame:frame toQueue:_queue withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
        if (error == nil) {
                        
#if !(TARGET_IPHONE_SIMULATOR)
            
            CMQuaternion currentAttitude_noQ = motion.attitude.quaternion;
            
            GLKQuaternion baseRotation = GLKQuaternionMake(currentAttitude_noQ.x, currentAttitude_noQ.y, currentAttitude_noQ.z, currentAttitude_noQ.w);
            
            if (self.landscape) {
                self.orientation = GLKQuaternionMultiply(baseRotation, rotationFix);
            } else {
                self.orientation = GLKQuaternionMultiply(rotationFix, baseRotation);
            }
          
            if (_testTiming) {
                if (_frames == 0) {
                    _startTimestamp = motion.timestamp;
                }
                _frames++;
                if (_frames >= (_frameIndex + 10) * 2) {
                    double diff = motion.timestamp - _startTimestamp;
                    if (diff > 0.00) {
                        self.foundTiming = (double)_frames / diff;
                    }
                    _framesValues[_frameIndex] = self.foundTiming;
                    
                    //NSLog(@"%d %2.2f", _frameIndex + 10, self.foundTiming);
                    _frameIndex++;
                    
                    _testProgress = _frameIndex / 90.0f;
                    
                    if (_frameIndex <= 90) {
                        self.motionManager.deviceMotionUpdateInterval = (1 / (_frameIndex + 10.0));
                        _frames = -1;
                        _startTimestamp = motion.timestamp;
                    } else {
                        _testTiming = NO;
                    }
                }
            }
            else if (_checkTiming) {
                if (_frames == 0) {
                    _startTimestamp = motion.timestamp;
                }
                _frames++;
                if (_frames >= 100) {
                    double diff = motion.timestamp - _startTimestamp;
                    if (diff > 0.00) {
                        self.foundTiming = (double)_frames / diff;
                    }
                    _frames = 0;
                    _startTimestamp = motion.timestamp;
                }
                
                if (_frames > 60000) {
                    _checkTiming = NO;
                }
            }
#else
            // For Testing
            self.orientation = GLKQuaternionMultiply(rotationFix, GLKQuaternionMakeWithAngleAndAxis(90 * 0.0174532925f, 1, 0, 0));
#endif
        }
    }];
}

-(void) stop {
    _checkTiming = NO;
    _testTiming = NO;
    [self.motionManager stopDeviceMotionUpdates];
}

-(void) capture {
    /*
    #if !(TARGET_IPHONE_SIMULATOR)
    
    CMQuaternion currentAttitude_noQ = self.motionManager.deviceMotion.attitude.quaternion;
        
    GLKQuaternion baseRotation = GLKQuaternionMake(currentAttitude_noQ.x, currentAttitude_noQ.y, currentAttitude_noQ.z, currentAttitude_noQ.w);
    
    if (self.landscape) {
        self.orientation = GLKQuaternionMultiply(baseRotation, rotationFix);
    } else {
        self.orientation = GLKQuaternionMultiply(rotationFix, baseRotation);
    }
     
    #else
    // For Testing
    self.orientation = GLKQuaternionMultiply(rotationFix, GLKQuaternionMakeWithAngleAndAxis(90 * 0.0174532925f, 1, 0, 0));
    #endif
     */
}

@end
