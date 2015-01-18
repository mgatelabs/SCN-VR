//
//  SCNEye.h
//  SCN-VR
//
//  Created by Michael Fuller on 12/20/14.
//  Copyright (c) 2014 M-Gate Labs. All rights reserved.
//

#import <SceneKit/SceneKit.h>
#import "EyeTexture.h"
#import "ProfileInstance.h"

@interface SCNEye : SCNNode

@property (weak, nonatomic, readonly) EyeTexture * dest;

- (instancetype)initAs:(EyeTexture *) dest pair:(ProfileInstance *) pair scene:(SCNScene *) scene context:(EAGLContext *) context;

@end
