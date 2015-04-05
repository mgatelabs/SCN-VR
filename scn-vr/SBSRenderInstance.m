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

#import "SBSRenderInstance.h"
#import <GLKit/GLKit.h>

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
    switch (pair.ssMode) {
        case ProfileInstanceSS2X:
            return [[RenderTexture alloc] initAsDefined:4096 height:2048];
        case ProfileInstanceSS125X:
            return [[RenderTexture alloc] initAsDefined:2048 + 512 height:1024 + 256];
        case ProfileInstanceSS15X:
            return [[RenderTexture alloc] initAsDefined:2048 + 1024 height:1024 + 512];
        case ProfileInstanceSS1X:
        default:
            return [[RenderTexture alloc] initAsDefined:2048 height:1024];
    }
}

@end
