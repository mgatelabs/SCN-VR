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

#import "SCNVirtualRealityViewController.h"

@interface SCNVirtualRealityViewController () {
    
}

@property (strong, nonatomic) EAGLContext *context;

- (void) setupGL;
- (void) checkGlErrorStatus;

@end

@implementation SCNVirtualRealityViewController

-(void) viewDidLoad {
    [super viewDidLoad];
    [self setPaused:YES];
    
    ProfileManager * profiles = [ProfileManager sharedManager];
    self.profile = [profiles getCurrentProfileInstance];
    
    _nullViewpoint = GLKQuaternionMultiply(GLKQuaternionMakeWithAngleAndAxis(-1.57079633f, 0, 0, 1), GLKQuaternionMakeWithAngleAndAxis(90 * 0.0174532925f, 1, 0, 0));
    
    _useHeadTracking = YES;
    
    self.profile.tracker.landscape = self.profile.landscapeView;
    
    _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    [EAGLContext setCurrentContext:_context];
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    _nativeScale = [UIScreen mainScreen].nativeScale;
    view.contentScaleFactor = _nativeScale;
    self.view.layer.contentsScale = _nativeScale;
    
    
    //NSLog(@"%2.2f %2.2f %2.2f %2.2f", view.bounds.size.width * _nativeScale, view.bounds.size.height * _nativeScale, view.bounds.origin.x, view.bounds.origin.y);
    
    [self setPreferredFramesPerSecond:60];
    
    [self setupGL];
    
    // We don't have a head
    _viewpoint = nil;
    
    // Where the final product goes
    _destTexture = [[RenderTexture alloc] initAsInfered:self.profile.virtualWidthPX height:self.profile.virtualHeightPX left:self.profile.virtualOffsetLeft bottom:self.profile.virtualOffsetBottom];
    
    _eyeColorCorrection = nil;
    
    switch (self.profile.viewportCount) {
        case 1: {
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
        case 2: {
            
            if (self.profile.basicView) {
                
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
                
                GLint maxTextureSize;
                glGetIntegerv(GL_MAX_TEXTURE_SIZE, &maxTextureSize);
                
                if (self.profile.ssMode == ProfileInstanceSS2X && maxTextureSize < 4096) {
                    self.profile.ssMode = ProfileInstanceSS1X;
                } else if (self.profile.ssMode == ProfileInstanceSS15X && maxTextureSize < 2048 + 1024) {
                    self.profile.ssMode = ProfileInstanceSS1X;
                } else if (self.profile.ssMode == ProfileInstanceSS125X && maxTextureSize < 2048 + 512) {
                    self.profile.ssMode = ProfileInstanceSS1X;
                }
                
                _leftSourceTexture = [_profile.renderer generateRenderTexture:self.profile];
                _rightSourceTexture = _leftSourceTexture;
                
                _leftSourceTexture.dontClearColorBuffer = YES;
                
                // The left eye's output
                _leftEyeSource = [[EyeTexture alloc] initAs:EyeTextureSideLeft dest:_leftSourceTexture];
                
                _leftEyeDest = [[EyeTexture alloc] initAs:EyeTextureSideLeft dest:_destTexture];
                
                _leftEyeMesh = [DistortionMeshGenerator generateMeshFor:_profile eye:EyeTextureSideLeft];
                
                // The right eye's output
                _rightEyeSource = [[EyeTexture alloc] initAs:EyeTextureSideRight dest:_rightSourceTexture];
                
                _rightEyeMesh = [DistortionMeshGenerator generateMeshFor:_profile eye:EyeTextureSideRight];
                
                _rightEyeDest = [[EyeTexture alloc] initAs:EyeTextureSideRight dest:_destTexture];
                
                _eyeColorCorrection = [[ColorCorrection alloc] init];
                
                _destTexture.dontClearColorBuffer = YES;
            }
        } break;
    }
    
    _scene = [self generateScene];
    
    _leftRenderer = [SCNRenderer rendererWithContext:(__bridge void *)(_context) options:nil];
    _leftRenderer.showsStatistics = NO;
    _leftRenderer.scene = _scene;
    _leftRenderer.playing = YES;
    
    _rightRenderer = [SCNRenderer rendererWithContext:(__bridge void *)(_context) options:nil];
    _rightRenderer.showsStatistics = NO;
    _rightRenderer.scene = _scene;
    _rightRenderer.playing = YES;
    
    [self afterGenerateScene];
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setPaused:NO];
    [_profile.tracker start];
}

-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self setPaused:YES];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [_profile.tracker stop];
}

- (void)dealloc
{
    [self setPaused:YES];
    
    //NSLog(@"Tearing down");
    
    for (int i = (int)_scene.rootNode.childNodes.count - 1; i >= 0; i--) {
        SCNNode * child = [_scene.rootNode.childNodes objectAtIndex:i];
        [child removeFromParentNode];
    }
    
    _leftRenderer.delegate = nil;
    _leftRenderer.pointOfView = nil;
    _leftRenderer.scene = nil;
    _leftRenderer = nil;
    
    _rightRenderer.delegate = nil;
    _rightRenderer.pointOfView = nil;
    _rightRenderer.scene = nil;
    _rightRenderer = nil;
    
    _profile = nil;
    
    // Source are defined render textures
    _leftSourceTexture = nil;
    _rightSourceTexture = nil;
    
    _leftEyeSource = nil;
    _rightEyeSource = nil;
    
    _leftEyeDest = nil;
    _rightEyeDest = nil;
    
    _eyeColorCorrection = nil;
    
    _leftEyeMesh = nil;
    _rightEyeMesh = nil;
    
    _viewpoint = nil;
    
    // THis is the infered render texture
    _destTexture = nil;
    
    _scene = nil;
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
    
    _context = nil;
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
    return [[SCNViewpoint alloc] initAsGhost:_leftEyeSource right:_rightEyeSource pair:_profile scene:_scene context:_context];
}

-(void) setViewpointTo:(SCNViewpoint *) viewpoint {
    _viewpoint = viewpoint;
    
    _leftRenderer.pointOfView = _viewpoint.leftEye;
    if (_viewpoint.rightEye != nil) {
        _rightRenderer.pointOfView = _viewpoint.rightEye;
    }
    
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
        return [_leftRenderer hitTest:CGPointMake(_leftEyeSource.w / 2, _leftEyeSource.h / 2) options:nil];
    }
    return nil;
}

-(NSArray *) viewpointSeesAt:(float) x y:(float) y {
    if (_viewpoint != nil) {
        return [_leftRenderer hitTest:CGPointMake(x, y) options:nil];
    }
    return nil;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.profile.landscapeView ? UIInterfaceOrientationLandscapeRight : UIInterfaceOrientationPortrait;
}

- (NSUInteger)supportedInterfaceOrientations {
    return self.profile.landscapeView ? UIInterfaceOrientationMaskLandscapeRight : UIInterfaceOrientationMaskPortrait;
}

- (BOOL) prefersStatusBarHidden {
    return YES;
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update {
    // Get the latest position
    [self.profile.tracker capture];
    
    [self updateViewpointOrientation];
}

-(void) updateViewpointOrientation {
        
    GLKQuaternion gyroValues = _useHeadTracking ? _profile.tracker.orientation : _nullViewpoint;
    GLKQuaternion altered;
    
    // May be slow, but this is prototype code
    GLKQuaternion cameraOrientation = GLKQuaternionIdentity; // GLKQuaternionMake(self.cameraInitialOrientation.x, self.cameraInitialOrientation.y, self.cameraInitialOrientation.z, self.cameraInitialOrientation.w);
    
    cameraOrientation = GLKQuaternionMultiply(cameraOrientation, GLKQuaternionMakeWithAngleAndAxis(1.57079633f, 0, 0, 1));
    
    altered =GLKQuaternionMultiply(cameraOrientation, gyroValues);
    
    _viewpoint.neck.orientation = SCNVector4Make(altered.x, altered.y, altered.z, altered.w) ;
    
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    //[[UIScreen mainScreen] setBrightness: 0.7];
    
    [EAGLContext setCurrentContext:_context];
    
    // Make sure we have access to the screen's render & depth buffers
    [_destTexture restore];
    
    [self checkGlErrorStatus];
    
    if (_viewpoint != nil) {
        
        CFTimeInterval interval = CACurrentMediaTime();
        
        // Render both eyes
        [_leftEyeSource bindAndClear];
        [_leftRenderer renderAtTime:interval];
        
        if (_viewpoint.rightEye != nil) {
            [_rightEyeSource bind];
            [_rightRenderer renderAtTime:interval];
        }
        
        [self checkGlErrorStatus];
        
        switch (_profile.viewportCount) {
            case 1: {
                
            } break;
            case 2: {
                
                if (_profile.basicView == NO) {
                    
                    [_destTexture bind];
                    
                    [_rightEyeDest view];
                    
                    [self checkGlErrorStatus];
                    
                    [_eyeColorCorrection activateShaderFor:_profile leftEye:NO texture:_rightEyeSource.dest.textureId];
                    
                    [self checkGlErrorStatus];
                    
                    [_rightEyeMesh draw];
                    
                    [self checkGlErrorStatus];
                    
                    [_leftEyeDest view];
                    
                    [self checkGlErrorStatus];
                    
                    [_eyeColorCorrection activateShaderFor:_profile leftEye:YES texture:_leftEyeSource.dest.textureId];
        
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
    
    //[[UIScreen mainScreen] setBrightness: 0.8f];
}

#pragma mark - GL Specific

- (void)setupGL {
    glEnable(GL_DEPTH_TEST);
}

-(void) checkGlErrorStatus {
    GLenum errorState = glGetError();
    if (errorState != GL_NO_ERROR) {
        NSLog(@"GL Error Detected: %d", errorState);
    }
}

@end
