/************************************************************************
	
 
	Copyright (C) 2015  Michael Glen Fuller Jr.
 
	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.
 
	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.
 
	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.
 
 ************************************************************************/

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
                _x = 0 + (dest.width / 2);
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
    
    glViewport(_dest.left + _x, _dest.bottom + _y, _w, _h);
}

@end
