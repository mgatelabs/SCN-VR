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
