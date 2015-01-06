//
//  SCNEye.m
//  SCN-VR
//
//  Created by Michael Fuller on 12/20/14.
//  Copyright (c) 2014 M-Gate Labs. All rights reserved.
//

#import "SCNEye.h"

@implementation SCNEye

- (instancetype)initAs:(EyeTexture *) dest pair:(HmdMobileDevicePair *) pair scene:(SCNScene *) scene context:(EAGLContext *) context
{
    self = [super init];
    if (self) {
        _dest = dest;
        
        if (_dest.side != EyeTextureSideMono) {
            float eyeDistance = ((pair.hmd.ipd / 1000.0f) / 2.0f);
            if (_dest.side == EyeTextureSideLeft) {
                eyeDistance *= -1;
            }
        
            // Move eye into place
            self.transform = SCNMatrix4MakeTranslation(eyeDistance, 0.0, 0.0);
        }
        
        self.hidden = NO;
        
        // Make a new camera
        SCNCamera * camera = [SCNCamera camera];
        camera.xFov = pair.hmd.hFov;
        camera.yFov = pair.hmd.vFov;
        camera.zNear = 0.01f;
        camera.zFar = 2048.0f;
        switch (dest.side) {
            case EyeTextureSideLeft: {
                camera.categoryBitMask = 1;
            } break;
            case EyeTextureSideRight: {
                camera.categoryBitMask = 2;
            } break;
            case EyeTextureSideMono: {
                camera.categoryBitMask = 3;
            } break;
        }

        self.camera = camera;
        
        /*
        SCNRenderer * renderer = [SCNRenderer rendererWithContext:(__bridge void *)(context) options:nil];
        
        _renderer = renderer;
        renderer.showsStatistics = NO;
        renderer.delegate = self;
        renderer.scene = scene;
        renderer.pointOfView = self;
        renderer.playing = YES;*/
    }
    return self;
}

@end
