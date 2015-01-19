//
//  SCNViewpoint.m
//  SCN-VR
//
//  Created by Michael Fuller on 12/19/14.
//  Copyright (c) 2014 M-Gate Labs. All rights reserved.
//

#import "SCNViewpoint.h"

@implementation SCNViewpoint

- (instancetype)initAsGhost:(EyeTexture *) left right:(EyeTexture *) right pair:(ProfileInstance *) pair scene:(SCNScene *) scene context:(EAGLContext *) context
{
    self = [super init];
    if (self) {
        _leftEyeSource = left;
        _rightEyeSource = right;
        self.hidden = NO;
        
        SCNNode * neck = [SCNNode node];
        [self addChildNode:neck];
        _neck = neck;
        
        switch (pair.viewportCount) {
            case 1: {
                
                SCNEye * leftEye = [[SCNEye alloc] initAs:_leftEyeSource pair:pair scene:scene context:context];
                _leftEye = leftEye;
                leftEye.hidden = NO;
                [_neck addChildNode:_leftEye];
                
                _rightEye = nil;
                
            } break;
            case 2: {
            
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

- (void)dealloc
{
    _leftEyeSource = nil;
    _rightEyeSource = nil;
    _sourceTexture = nil;
    
    if (_leftEye != nil) {
        [_leftEye removeFromParentNode];
        _leftEye = nil;
    }
    
    if (_rightEye != nil) {
        [_rightEye removeFromParentNode];
        _rightEye = nil;
    }
    
    if (_neck != nil) {
        //[_neck removeFromParentNode];
        _neck = nil;
    }
}

@end
