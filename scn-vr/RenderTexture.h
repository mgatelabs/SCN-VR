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

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

typedef NS_ENUM(NSInteger, RenderTextureState)
{
    RenderTextureStateUnknown = 0,
    RenderTextureStateReady = 1,
    RenderTextureStateMinimized = 2,
    RenderTextureStateFailure = 3
};

typedef NS_ENUM(NSInteger, RenderTextureType)
{
    RenderTextureTypeDefined = 0,
    RenderTextureTypeInfered = 1
};

@interface RenderTexture : NSObject

@property (readonly, assign) int left;
@property (readonly, assign) int bottom;
@property (readonly, assign) int width;
@property (readonly, assign) int height;

@property (readonly, assign) RenderTextureState state;
@property (readonly, assign) RenderTextureType type;

@property (readonly, assign) GLuint textureId;
@property (readonly, assign) GLuint depthBuffer;
@property (readonly, assign) GLuint frameBuffer;

@property (readonly, assign) GLint inferedDepthBuffer;
@property (readonly, assign) GLint inferedFrameBuffer;

@property (assign, nonatomic) BOOL dontClearColorBuffer;

- (instancetype)initAsInfered:(int) width height:(int) height;
- (instancetype)initAsDefined:(int) width height:(int) height;

- (instancetype)initAsInfered:(int) width height:(int) height left:(int) left bottom:(int) bottom;
- (instancetype)initAsDefined:(int) width height:(int) height left:(int) left bottom:(int) bottom;

-(void) bind;
-(void) ready;
-(void) build;

-(void) bindWithRect:(int) x y:(int) y width:(int) width height:(int) height;
-(void) bindAndClearRect:(int) x y:(int) y width:(int) width height:(int) height;

-(void) minimize;

-(void) restore;

@end
