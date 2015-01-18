//
//  SBSRenderInstance.m
//  SCN-VR
//
//  Created by Michael Fuller on 12/20/14.
//  Copyright (c) 2014 M-Gate Labs. All rights reserved.
//

#import "SBSRenderInstance.h"

@implementation SBSRenderInstance

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.viewportCount = 2;
    }
    return self;
}

-(RenderTexture *) generateRenderTexture:(ProfileInstance *) pair {
    
    //return [[RenderTexture alloc] initAsDefined:pair.mobile.widthPx / 2 height:pair.mobile.heightPx];
    
    return [[RenderTexture alloc] initAsDefined:2048 height:1024];
}

@end
