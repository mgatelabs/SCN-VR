//
//  CoreMotionTracker.m
//  SCN-VR
//
//  Created by Michael Fuller on 12/21/14.
//  Copyright (c) 2014 M-Gate Labs. All rights reserved.
//

#import "CoreMotionTracker.h"

@implementation CoreMotionTracker {
    GLKQuaternion rotationFix;
}

- (instancetype)init
{
    self = [super initWith:@"CoreMotion" identity:@"cmmotionmanager"];
    if (self) {
        
        rotationFix = GLKQuaternionMakeWithAngleAndAxis(-1.57079633f, 0, 0, 1);

        self.motionManager = [[CMMotionManager alloc] init];
        self.motionManager.deviceMotionUpdateInterval = 1.0f / 60;
        self.motionManager.magnetometerUpdateInterval = 1.0f / 60;
        self.motionManager.showsDeviceMovementDisplay = YES;
        
    }
    return self;
}

-(void) start {
    [self.motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryCorrectedZVertical];
}

-(void) stop {
    [self.motionManager stopDeviceMotionUpdates];
}

-(void) capture {
    #if !(TARGET_IPHONE_SIMULATOR)
    
    CMQuaternion currentAttitude_noQ = self.motionManager.deviceMotion.attitude.quaternion;
    
    GLKQuaternion baseRotation = GLKQuaternionMake(currentAttitude_noQ.x, currentAttitude_noQ.y, currentAttitude_noQ.z, currentAttitude_noQ.w);
    self.orientation = GLKQuaternionMultiply(baseRotation, rotationFix);
    
    #else
    
    self.orientation = GLKQuaternionMultiply(rotationFix, GLKQuaternionMakeWithAngleAndAxis(90 * 0.0174532925f, 1, 0, 0));
    
    #endif
}

@end
