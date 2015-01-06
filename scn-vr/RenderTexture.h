//
//  RenderTexture.h
//  ALPS-VR
//
//  Created by Michael Fuller on 12/18/14.

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

-(void) bindWithRect:(int) x y:(int) y width:(int) width height:(int) height;
-(void) bindAndClearRect:(int) x y:(int) y width:(int) width height:(int) height;

-(void) minimize;

-(void) restore;

@end
