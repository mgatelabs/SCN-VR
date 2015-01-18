//
//  MonoRenderInstance.m
//  SCN-VR
//
//  Created by Michael Fuller on 12/20/14.
//  Copyright (c) 2014 M-Gate Labs. All rights reserved.
//

#import "MonoRenderInstance.h"

@implementation MonoRenderInstance

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.viewportCount = 1;
    }
    return self;
}

-(RenderTexture *) generateRenderTexture:(ProfileInstance *) pair {
    // Mono texture's will render right to dest, skip the middle man
    return nil;
}

-(EyeTexture *) generateEyeTexture:(ProfileInstance *) pair eye:(EyeTextureSide) eye sourceTexture:(RenderTexture *) sourceTexture {
    return [[EyeTexture alloc] initAs:eye dest:sourceTexture];
}

@end
