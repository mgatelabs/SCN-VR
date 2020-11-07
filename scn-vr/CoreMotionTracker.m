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
    BOOL useMagnet;
}

- (instancetype)initWithMagnet: (CMMotionManager *) manager
{
    self = [super initWith: NSLocalizedStringFromTableInBundle(@"TRACKER_COREMOTION", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"CoreMotion") identity:@"corewithmagnet"];
    if (self) {
        
        rotationFix = GLKQuaternionMakeWithAngleAndAxis(-M_PI_2, 0, 0, 1);
        
        self.motionManager = manager;
        
        useMagnet = self.motionManager.magnetometerAvailable;
        
        //self.motionManager.deviceMotionUpdateInterval = 1.0f / 60;
        //if (useMagnet) {
        //    self.motionManager.magnetometerUpdateInterval = 1.0f / 60;
        //    self.motionManager.showsDeviceMovementDisplay = YES;
        //}
    }
    return self;
}

- (instancetype)initWithoutMagnet: (CMMotionManager *) manager {
    self = [super initWith: NSLocalizedStringFromTableInBundle(@"TRACKER_COREMOTION_NO_MAG", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"CoreMotion NO Magnetometer") identity:@"corewithoutmagnet"];
    if (self) {
        rotationFix = GLKQuaternionMakeWithAngleAndAxis(-M_PI_2, 0, 0, 1);
        
        self.motionManager = manager;
        
        useMagnet = NO;
        
        //self.motionManager.deviceMotionUpdateInterval = 1.0f / 60;
    }
    return self;
}

-(void) start {
    self.motionManager.showsDeviceMovementDisplay = useMagnet;
    if (useMagnet) {
        self.motionManager.magnetometerUpdateInterval = 1.0f / 60.0f;
    }
    self.motionManager.deviceMotionUpdateInterval = 1.0f / 60.0f;
    
    CMAttitudeReferenceFrame frame = useMagnet ? CMAttitudeReferenceFrameXArbitraryCorrectedZVertical : CMAttitudeReferenceFrameXArbitraryZVertical;
    
    [self.motionManager startDeviceMotionUpdatesUsingReferenceFrame: frame];
    
    /*
    // Test Code, Made no difference
    [self.motionManager startDeviceMotionUpdatesUsingReferenceFrame:frame toQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
        
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
        
        //motion.attitude.quaternion;
    }];
    */
}

-(void) stop {
    [self.motionManager stopDeviceMotionUpdates];
}

-(void) capture {
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
}

@end
