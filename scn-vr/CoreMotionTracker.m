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

@implementation CoreMotionTracker {
    GLKQuaternion landscapeRotationFix;
    BOOL useMagnet;
}

- (instancetype)init
{
    self = [super initWith:@"CoreMotion" identity:@"cmmotionmanager"];
    if (self) {
        
        landscapeRotationFix = GLKQuaternionMakeWithAngleAndAxis(-1.57079633f, 0, 0, 1);
        
        self.motionManager = [[CMMotionManager alloc] init];
        
        useMagnet = self.motionManager.magnetometerAvailable;
        
        self.motionManager.deviceMotionUpdateInterval = 1.0f / 60;
        if (useMagnet) {
            self.motionManager.magnetometerUpdateInterval = 1.0f / 60;
            self.motionManager.showsDeviceMovementDisplay = YES;
        }
    }
    return self;
}

- (instancetype)initWithoutMagnet {
    self = [super initWith:@"CoreMotion NO Magnetometer" identity:@"cmmotionmanagernomag"];
    if (self) {
        
        landscapeRotationFix = GLKQuaternionMakeWithAngleAndAxis(-1.57079633f, 0, 0, 1);
        
        self.motionManager = [[CMMotionManager alloc] init];
        
        useMagnet = NO;
        
        self.motionManager.deviceMotionUpdateInterval = 1.0f / 60;
        if (useMagnet) {
            self.motionManager.magnetometerUpdateInterval = 1.0f / 60;
            self.motionManager.showsDeviceMovementDisplay = YES;
        }
    }
    return self;
}

-(void) start {
    [self.motionManager startDeviceMotionUpdatesUsingReferenceFrame: useMagnet ? CMAttitudeReferenceFrameXArbitraryCorrectedZVertical : CMAttitudeReferenceFrameXArbitraryZVertical];
}

-(void) stop {
    [self.motionManager stopDeviceMotionUpdates];
}

-(void) capture {
    #if !(TARGET_IPHONE_SIMULATOR)
    
    CMQuaternion currentAttitude_noQ = self.motionManager.deviceMotion.attitude.quaternion;
    
    //NSLog(@"%2.4f %2.4f %2.4f %2.4f", currentAttitude_noQ.w, currentAttitude_noQ.x, currentAttitude_noQ.y, currentAttitude_noQ.z);
    
    if (useMagnet) {
        // Just grab the value
        float x = self.motionManager.deviceMotion.magneticField.field.x;
        x += self.motionManager.deviceMotion.magneticField.field.y;
        x += self.motionManager.deviceMotion.magneticField.field.z;
        x += self.motionManager.deviceMotion.magneticField.accuracy;
        x = x + 0;
    }
    
    GLKQuaternion baseRotation = GLKQuaternionMake(currentAttitude_noQ.x, currentAttitude_noQ.y, currentAttitude_noQ.z, currentAttitude_noQ.w);
    if (self.landscape) {
        self.orientation = GLKQuaternionMultiply(baseRotation, landscapeRotationFix);
    } else {
        self.orientation = GLKQuaternionMultiply(GLKQuaternionMakeWithAngleAndAxis(-M_PI / 2.0f, 0, 0, 1), baseRotation);
    }
    #else
    
    self.orientation = GLKQuaternionMultiply(landscapeRotationFix, GLKQuaternionMakeWithAngleAndAxis(90 * 0.0174532925f, 1, 0, 0));
    
    #endif
}

@end
