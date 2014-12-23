//
//  RenderBase.m
//  SCN-VR
//
//  Created by Michael Fuller on 12/20/14.
//  Copyright (c) 2014 M-Gate Labs. All rights reserved.
//

#import "RenderBase.h"

@implementation RenderBase

-(BOOL) worksWith:(HmdMobileDevicePair *) pair {
    return false;
}

-(RenderTexture *) generateRenderTexture:(HmdMobileDevicePair *) pair {
    return nil;
}

-(EyeTexture *) generateEyeTexture:(HmdMobileDevicePair *) pair eye:(EyeTextureSide) eye sourceTexture:(RenderTexture *) sourceTexture {
    return [[EyeTexture alloc] initAs:eye dest:sourceTexture];
}

@end
