//
//  RenderBase.h
//  SCN-VR
//
//  Created by Michael Fuller on 12/20/14.
//  Copyright (c) 2014 M-Gate Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProfileInstance.h"
#import "RenderTexture.h"
#import "EyeTexture.h"

@class ProfileInstance;

@interface RenderBase : NSObject

@property (assign, nonatomic) int viewportCount;

-(RenderTexture *) generateRenderTexture:(ProfileInstance *) pair;

-(EyeTexture *) generateEyeTexture:(ProfileInstance *) pair eye:(EyeTextureSide) eye sourceTexture:(RenderTexture *) sourceTexture;

@end
