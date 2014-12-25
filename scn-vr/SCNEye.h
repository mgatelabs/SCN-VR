//
//  SCNEye.h
//  SCN-VR
//
//  Created by Michael Fuller on 12/20/14.
//  Copyright (c) 2014 M-Gate Labs. All rights reserved.
//

#import <SceneKit/SceneKit.h>
#import "EyeTexture.h"
#import "HmdMobileDevicePair.h"

@interface SCNEye : SCNNode

@property (weak, nonatomic, readonly) EyeTexture * dest;

//@property (strong, nonatomic, readonly) SCNRenderer * renderer;

- (instancetype)initAs:(EyeTexture *) dest pair:(HmdMobileDevicePair *) pair scene:(SCNScene *) scene context:(EAGLContext *) context;

@end
