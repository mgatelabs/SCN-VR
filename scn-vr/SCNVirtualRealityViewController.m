//
//  SCNVirtualRealityViewController.m
//  SCN-VR
//
//  Created by Michael Fuller on 12/19/14.
//  Copyright (c) 2014 M-Gate Labs. All rights reserved.
//

#import "SCNVirtualRealityViewController.h"

@interface SCNVirtualRealityViewController () {
    
}

@property (strong, nonatomic) EAGLContext *context;

- (void) setupGL;
- (void) tearDownGL;
- (void) checkGlErrorStatus;

@end

@implementation SCNVirtualRealityViewController

-(void) viewDidLoad {
    
    [self setPaused:YES];
    
    [_pair.mobile ready];
    
    _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    [EAGLContext setCurrentContext:_context];
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    [self setPreferredFramesPerSecond:60];
    
    [self setupGL];
    
    // We don't have a head
    _viewpoint = nil;
    
    // Where the final product goes
    _destTexture = [[RenderTexture alloc] initAsInfered:_pair.mobile.widthPx height:_pair.mobile.heightPx];
    
    _eyeColorCorrection = nil;
    
    switch (_pair.hmd.viewpoints) {
        case HmdDeviceConfigurationViewpointsMono: {
            // Skip this, render to final output
            _leftSourceTexture = nil;
            _rightSourceTexture = nil;
            
            // The left eye's output
            _leftEyeSource = [[EyeTexture alloc] initAs:EyeTextureSideMono dest:_destTexture];
            
            _leftEyeDest = nil;
            
            // Mono, no right eye
            _rightEyeSource = nil;
            
            _rightEyeDest = nil;
            
        } break;
        case HmdDeviceConfigurationViewpointsSBS: {
            
            if (_pair.hmd.distortion == HmdDeviceConfigurationCorrectionNone) {
                
                // Skip this, render to final output
                _leftSourceTexture = nil;
                _rightSourceTexture = nil;
                
                _destTexture.dontClearColorBuffer = YES;
                
                // The left eye's output
                _leftEyeSource = [[EyeTexture alloc] initAs:EyeTextureSideLeft dest:_destTexture];
                
                _leftEyeDest = nil;
                
                // Mono, no right eye
                _rightEyeSource = [[EyeTexture alloc] initAs:EyeTextureSideRight dest:_destTexture];
                
                _rightEyeDest = nil;
                
            } else {
                // Where inbetween work is done
                _leftSourceTexture = [_renderer generateRenderTexture:_pair];
                _rightSourceTexture = _leftSourceTexture;
                
                _leftSourceTexture.dontClearColorBuffer = YES;
                
                // The left eye's output
                _leftEyeSource = [[EyeTexture alloc] initAs:EyeTextureSideLeft dest:_leftSourceTexture];
                
                _leftEyeDest = [[EyeTexture alloc] initAs:EyeTextureSideLeft dest:_destTexture];
                
                _leftEyeMesh = [DistortionMeshGenerator generateMeshFor:_pair eye:EyeTextureSideLeft];
                
                // The right eye's output
                _rightEyeSource = [[EyeTexture alloc] initAs:EyeTextureSideRight dest:_rightSourceTexture];
                
                _rightEyeMesh = [DistortionMeshGenerator generateMeshFor:_pair eye:EyeTextureSideRight];
                
                _rightEyeDest = [[EyeTexture alloc] initAs:EyeTextureSideRight dest:_destTexture];
                
                _eyeColorCorrection = [[ColorCorrection alloc] init];
                
                _destTexture.dontClearColorBuffer = YES;
            }
        } break;
    }
    
    _scene = [self generateScene];
    
    [self afterGenerateScene];
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

-(void) viewWillAppear:(BOOL)animated {
    [self setPaused:NO];
    [_tracker start];
}

-(void) viewDidDisappear:(BOOL)animated {
    [self setPaused:YES];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [_tracker stop];
}

#pragma mark - Scene Helpers

// Override this method to insert your own scenes
-(SCNScene *) generateScene {
    return [SCNScene scene];
}

-(void) afterGenerateScene {
    
}

#pragma mark - Viewport Helpers

-(SCNViewpoint *) generateGhostViewpoint {
    return [[SCNViewpoint alloc] initAsGhost:_leftEyeSource right:_rightEyeSource pair:_pair scene:_scene context:_context];
}

-(void) setViewpointTo:(SCNViewpoint *) viewpoint {
    _viewpoint = viewpoint;
    [self updateViewpointOrientation];
}

-(void) setBackgroundImage:(NSString *) filePrefix {
    _scene.background.contents = @[[filePrefix stringByAppendingString:@"_rt.jpg"],
                                  [filePrefix stringByAppendingString:@"_lf.jpg"],
                                  [filePrefix stringByAppendingString:@"_up.jpg"],
                                  [filePrefix stringByAppendingString:@"_dn.jpg"],
                                  [filePrefix stringByAppendingString:@"_bk.jpg"],
                                  [filePrefix stringByAppendingString:@"_ft.jpg"]];
}

-(NSArray *) viewpointSees {
    if (_viewpoint != nil) {
        return [_viewpoint.leftEye.renderer hitTest:CGPointMake(_leftEyeSource.w / 2, _leftEyeSource.h / 2) options:nil];
    }
    return nil;
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update {
    // Get the latest position
    [_tracker capture];
    
    [self updateViewpointOrientation];
}

-(void) updateViewpointOrientation {
    
    GLKQuaternion gyroValues = _tracker.orientation;
    GLKQuaternion altered;
    
    /*
    if (isCameraBaseSet == false && cameraBase.x == 0 && cameraBase.y == 0 && cameraBase.z == 0 && cameraBase.w == 0) {
        cameraBase = gyroValues;
        if (cameraBase.x != 0 || cameraBase.y != 0 || cameraBase.z != 0 || cameraBase.w != 0) {
            // Testing
            //cameraBase = GLKQuaternionMakeWithAngleAndAxis(-1.57079633f, cameraBase.x, 0, 0);
            isCameraBaseSet = true;
        }
        NSLog(@"Getting reference point");
    } else {
        // Modify values to take into account reference fixes
        //gyroValues = GLKQuaternionMultiply(GLKQuaternionInvert(cameraBase), gyroValues);
    }
    */
    
    // May be slow, but this is prototype code
    GLKQuaternion cameraOrientation = GLKQuaternionIdentity; // GLKQuaternionMake(self.cameraInitialOrientation.x, self.cameraInitialOrientation.y, self.cameraInitialOrientation.z, self.cameraInitialOrientation.w);
    
    cameraOrientation = GLKQuaternionMultiply(cameraOrientation, GLKQuaternionMakeWithAngleAndAxis(1.57079633f, 0, 0, 1));
    
    altered =GLKQuaternionMultiply(cameraOrientation, gyroValues);
    
    _viewpoint.neck.orientation = SCNVector4Make(altered.x, altered.y, altered.z, altered.w) ;
    
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    [EAGLContext setCurrentContext:_context];
    
    // Make sure we have access to the screen's render & depth buffers
    [_destTexture restore];
    
    [self checkGlErrorStatus];
    
    if (_viewpoint != nil) {
        [_viewpoint renderForTime:CACurrentMediaTime()];
        
        [self checkGlErrorStatus];
        
        switch (_pair.hmd.viewpoints) {
            case HmdDeviceConfigurationViewpointsMono: {
                
            } break;
            case HmdDeviceConfigurationViewpointsSBS: {
                
                if (_eyeColorCorrection != nil && _leftEyeMesh != nil && _rightEyeMesh != nil) {
                    
                    [_destTexture bind];
                    
                    [_rightEyeDest view];
                    
                    [self checkGlErrorStatus];
                    
                    [_eyeColorCorrection activateShaderFor:_pair leftEye:NO texture:_rightEyeSource.dest.textureId];
                    
                    [self checkGlErrorStatus];
                    
                    [_rightEyeMesh draw];
                    
                    [self checkGlErrorStatus];
                    
                    [_leftEyeDest view];
                    
                    [self checkGlErrorStatus];
                    
                    [_eyeColorCorrection activateShaderFor:_pair leftEye:YES texture:_leftEyeSource.dest.textureId];
        
                    [self checkGlErrorStatus];
                    
                    glEnableVertexAttribArray(GLKVertexAttribPosition);
                    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
                    
                    [_leftEyeMesh draw];
        
                    [self checkGlErrorStatus];
                    
                    
                    
                    glDisableVertexAttribArray(GLKVertexAttribPosition);
                    glDisableVertexAttribArray(GLKVertexAttribTexCoord0);
                    
                }
                
            } break;
        }
    } else {
        NSLog(@"Viewport has not been set, please set a viewport before rendeirng begins");
    }
    
    glFlush();
}

#pragma mark - GL Specific

- (void)setupGL {
    glEnable(GL_DEPTH_TEST);
}

- (void)tearDownGL {
    
}

-(void) checkGlErrorStatus {
    GLenum errorState = glGetError();
    if (errorState != GL_NO_ERROR) {
        NSLog(@"GL Error Detected: %d", errorState);
    }
}

@end
