//
//  EyeTexture.m
//  SCN-VR
//
//  Created by Michael Fuller on 12/20/14.
//  Copyright (c) 2014 M-Gate Labs. All rights reserved.
//

#import "EyeTexture.h"

@implementation EyeTexture

- (instancetype)initAs:(EyeTextureSide) side dest:(RenderTexture *) dest
{
    self = [super init];
    if (self) {
        _side = side;
        _dest = dest;
        
        switch (side) {
            case EyeTextureSideLeft:
            case EyeTextureSideMono:
                _x = 0;
                break;
            case EyeTextureSideRight:
                _x = dest.width / 2;
                break;
            default: {
                _x = 0;
            } break;
        }
        _y = 0;
        _h = dest.height;
        
        switch (side) {
            case EyeTextureSideLeft:
            case EyeTextureSideRight:
                _w = dest.width / 2;
                break;
            case EyeTextureSideMono:
                _w = dest.width;
                break;
            default: {
                NSLog(@"Unknown Eye Texture Side");
                _w = dest.width;
            } break;
        }
        
    }
    return self;
}

-(void) bind {
    [_dest bindWithRect:_x y:_y width:_w height:_h];
}

-(void) bindAndClear {
    [_dest bindAndClearRect:_x y:_y width:_w height:_h];
}

-(void) view {
    glViewport(_x, _y, _w, _h);
}

@end
