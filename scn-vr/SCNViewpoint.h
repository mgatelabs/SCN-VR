//
//  SCNViewpoint.h
//  SCN-VR
//
//  Created by Michael Fuller on 12/19/14.
//  Copyright (c) 2014 M-Gate Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SceneKit/SceneKit.h>
#import "SCNEye.h"
#import "RenderTexture.h"
#import "EyeTexture.h"
#import "RenderBase.h"
#import "ProfileInstance.h"

@interface SCNViewpoint : SCNNode

@property (readonly, nonatomic, weak) SCNNode * neck;

@property (readonly, nonatomic, weak) SCNEye * leftEye;

@property (readonly, nonatomic, weak) SCNEye * rightEye;

@property (weak, readonly, nonatomic) RenderTexture * sourceTexture;
@property (weak, readonly, nonatomic) EyeTexture * leftEyeSource;
@property (weak, readonly, nonatomic) EyeTexture * rightEyeSource;

- (instancetype)initAsGhost:(EyeTexture *) left right:(EyeTexture *) right pair:(ProfileInstance *) pair scene:(SCNScene *) scene context:(EAGLContext *) context;

@end
