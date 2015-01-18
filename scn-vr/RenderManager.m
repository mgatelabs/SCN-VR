//
//  RenderManager.m
//  SCN-VR
//
//  Created by Michael Fuller on 12/20/14.
//  Copyright (c) 2014 M-Gate Labs. All rights reserved.
//

#import "RenderManager.h"

@implementation RenderManager

+ (id)sharedManager {
    static RenderManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _renders = [[NSMutableArray alloc] initWithCapacity:2];
        [_renders addObject:[[MonoRenderInstance alloc] init]];
        [_renders addObject:[[SBSRenderInstance alloc] init]];
    }
    return self;
}

-(RenderBase *) findRendererForViewports:(int) viewportCount {
    for (int i = 0; i < _renders.count; i++) {
        RenderBase * rb = [_renders objectAtIndex:i];
        if (rb.viewportCount == viewportCount) {
            return rb;
        }
    }
    return nil;
}

@end
