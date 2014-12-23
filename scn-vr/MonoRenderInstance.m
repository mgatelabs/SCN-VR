//
//  MonoRenderInstance.m
//  SCN-VR
//
//  Created by Michael Fuller on 12/20/14.
//  Copyright (c) 2014 M-Gate Labs. All rights reserved.
//

#import "MonoRenderInstance.h"

@implementation MonoRenderInstance

-(BOOL) worksWith:(HmdMobileDevicePair *) pair {
    return pair.hmd.viewpoints == HmdDeviceConfigurationViewpointsMono;
}

-(RenderTexture *) generateRenderTexture:(HmdMobileDevicePair *) pair {
    // Mono texture's will render right to dest, skip the middle man
    return nil;
}

-(EyeTexture *) generateEyeTexture:(HmdMobileDevicePair *) pair eye:(EyeTextureSide) eye sourceTexture:(RenderTexture *) sourceTexture {
    return [[EyeTexture alloc] initAs:eye dest:sourceTexture];
}

@end
