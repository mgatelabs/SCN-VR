//
//  RenderProtocol.h
//  SCN-VR
//
//  Created by Michael Fuller on 12/20/14.
//  Copyright (c) 2014 M-Gate Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "HmdMobileDevicePair.h"
#import "RenderTexture.h"
#import "EyeTexture.h"
#import "ProfileInstance.h"

@class ProfileInstance;

@protocol RenderProtocol <NSObject>

-(BOOL) worksWith:(HmdMobileDevicePair *) pair;

-(RenderTexture *) generateRenderTexture:(ProfileInstance *) pair;

-(EyeTexture *) generateEyeTexture:(ProfileInstance *) pair eye:(EyeTextureSide) eye sourceTexture:(RenderTexture *) sourceTexture;

@end
