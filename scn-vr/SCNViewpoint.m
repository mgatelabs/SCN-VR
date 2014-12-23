//
//  SCNViewpoint.m
//  SCN-VR
//
//  Created by Michael Fuller on 12/19/14.
//  Copyright (c) 2014 M-Gate Labs. All rights reserved.
//

#import "SCNViewpoint.h"

@implementation SCNViewpoint

- (instancetype)initAsGhost:(EyeTexture *) left right:(EyeTexture *) right pair:(HmdMobileDevicePair *) pair scene:(SCNScene *) scene context:(EAGLContext *) context
{
    self = [super init];
    if (self) {
        _leftEyeSource = left;
        _rightEyeSource = right;
        self.hidden = NO;
        
        SCNNode * neck = [SCNNode node];
        _neck = neck;
        [self addChildNode:neck];
        
        switch (pair.hmd.viewpoints) {
            case HmdDeviceConfigurationViewpointsMono: {
                
                SCNEye * leftEye = [[SCNEye alloc] initAs:_leftEyeSource pair:pair scene:scene context:context];
                _leftEye = leftEye;
                leftEye.hidden = NO;
                [_neck addChildNode:_leftEye];
                
                _rightEye = nil;
                
            } break;
            case HmdDeviceConfigurationViewpointsSBS: {
            
                SCNEye * leftEye = [[SCNEye alloc] initAs:_leftEyeSource pair:pair scene:scene context:context];
                _leftEye = leftEye;
                [_neck addChildNode:_leftEye];
                
                SCNEye * rightEye = [[SCNEye alloc] initAs:_rightEyeSource pair:pair scene:scene context:context];
                _rightEye = rightEye;
                [_neck addChildNode:_rightEye];
                
            } break;
        }
    }
    return self;
}

-(void) renderForTime:(CFTimeInterval) interval {
    
    // Render both eyes
    [_leftEye renderForTime:interval];
    
    [_leftEye renderForTime:interval];
    
    if (_rightEye != nil) {
        [_rightEye renderForTime:interval];
    }
    
}

@end
