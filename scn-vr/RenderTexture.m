//
//  RenderTexture.m
//  ALPS-VR
//
//  Created by Michael Fuller on 12/18/14.
//

#import "RenderTexture.h"

@implementation RenderTexture

- (instancetype)initAsInfered:(int) width height:(int) height
{
    self = [super init];
    if (self) {
        _width = width;
        _height = height;
        _state = RenderTextureStateUnknown;
        _type = RenderTextureTypeInfered;
        _textureId = 0;
        _depthBuffer = 0;
        _frameBuffer = 0;
        _inferedDepthBuffer = 0;
        _inferedFrameBuffer = 0;
        _dontClearColorBuffer = NO;
    }
    return self;
}

- (instancetype)initAsDefined:(int) width height:(int) height
{
    self = [super init];
    if (self) {
        _width = width;
        _height = height;
        _state = RenderTextureStateUnknown;
        _type = RenderTextureTypeDefined;
        
        _textureId = 0;
        _depthBuffer = 0;
        _frameBuffer = 0;
        _inferedDepthBuffer = 0;
        _inferedFrameBuffer = 0;
        
        _dontClearColorBuffer = NO;
        
        [self build];
    }
    return self;
}

// Clean up after ourselves
- (void)dealloc
{
    [self minimize];
}

-(void) build {
    if (_type == RenderTextureTypeDefined && _state != RenderTextureStateReady) {
        // texture
        glGenTextures(1, &_textureId);
        glBindTexture(GL_TEXTURE_2D, _textureId);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, _width, _height, 0, GL_RGBA, GL_UNSIGNED_BYTE, 0);
        glBindTexture(GL_TEXTURE_2D, 0);
        
        // frame buffer
        glGenFramebuffers(1, &_frameBuffer);
        glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
        
        // depth buffer
        glGenRenderbuffers(1, &_depthBuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, _depthBuffer);
        glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, _width, _height);
        glBindRenderbuffer(GL_RENDERBUFFER, 0);
        
        // attachments
        glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, _textureId, 0);
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthBuffer);
        
        GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
        
        if(status != GL_FRAMEBUFFER_COMPLETE) {
            NSLog(@"failed to make complete framebuffer object %x", status);
            _state = RenderTextureStateFailure;
        }else{
            //NSLog(@"Buffer ok");
            _state = RenderTextureStateReady;
        }
        
        glBindFramebuffer(GL_FRAMEBUFFER, 0);
    } else if (_type == RenderTextureTypeInfered && _state != RenderTextureStateReady) {
        
        glGetIntegerv(GL_FRAMEBUFFER_BINDING, &_inferedFrameBuffer);
        glGetIntegerv(GL_RENDERBUFFER_BINDING, &_inferedDepthBuffer);
        
        _state = RenderTextureStateReady;
    }
}

-(void) bind {
    
    if (_state == RenderTextureStateMinimized) {
        [self build];
    }
    
    // If everything is fine, get this texture ready for business
    if (_state == RenderTextureStateReady) {
        if (_type == RenderTextureTypeDefined) {
            glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
            glBindRenderbuffer(GL_RENDERBUFFER, _depthBuffer);
        } else {
            glBindFramebuffer(GL_FRAMEBUFFER, _inferedFrameBuffer);
            glBindRenderbuffer(GL_RENDERBUFFER, _inferedDepthBuffer);
        }
        
        glViewport(0, 0, _width, _height);
    
        glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
        glClear( (_dontClearColorBuffer ? 0 : GL_COLOR_BUFFER_BIT) | GL_DEPTH_BUFFER_BIT);
    }
}

-(void) bindWithRect:(int) x y:(int) y width:(int) width height:(int) height {
    if (_state != RenderTextureStateReady) {
        [self build];
    }
    
    // Make sure we don't overflow any boundaries
    if (_state == RenderTextureStateReady && width > 0 && height > 0 && width <= _width && height <= _height && x >= 0 && y >= 0 && x + width <= _width && y + height <= _height) {
        if (_type == RenderTextureTypeDefined) {
            glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
            glBindRenderbuffer(GL_RENDERBUFFER, _depthBuffer);
        } else {
            glBindFramebuffer(GL_FRAMEBUFFER, _inferedFrameBuffer);
            glBindRenderbuffer(GL_RENDERBUFFER, _inferedDepthBuffer);
        }
        
        glViewport(x, y, width, height);
        
        glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
        glClear((_dontClearColorBuffer ? 0 : GL_COLOR_BUFFER_BIT) | GL_DEPTH_BUFFER_BIT);
    }
}

// Reduce memory consumption
-(void) minimize {
    if (_state == RenderTextureStateReady) {
        if (_type == RenderTextureTypeDefined) {
            glDeleteFramebuffers(1, &_frameBuffer);
            glDeleteRenderbuffers(1, &_depthBuffer);
            glDeleteTextures(1, &_textureId);
        }
        
        _textureId = 0;
        _depthBuffer = 0;
        _frameBuffer = 0;
        
        _inferedDepthBuffer = 0;
        _inferedFrameBuffer = 0;
        
        _state = RenderTextureStateMinimized;
    }
}

// Force the texture to rebuild itself
-(void) restore {
    if (_type == RenderTextureTypeDefined) {
    if (_state == RenderTextureStateMinimized) {
        [self build];
    }
    } else if (_type == RenderTextureTypeInfered) {
        if (_state != RenderTextureStateReady) {
            [self build];
        }
    }
}

@end
