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

#import <GLKit/GLKit.h>
#import "SCNViewpoint.h"
#import "RenderTexture.h"
#import "EyeTexture.h"
#import "RenderBase.h"
#import "ColorCorrection.h"
#import "DistortionMeshGenerator.h"
#import "TrackerBase.h"
#import "ProfileManager.h"

@interface SCNVirtualRealityViewController : GLKViewController  <SCNSceneRendererDelegate>

// This needs to be set in the segue to this screen
@property (strong, nonatomic) ProfileInstance * profile;

@property (strong, nonatomic) EAGLContext *context;

@property (assign, nonatomic, readonly) BOOL isLoaded;

-(void) loadIt;

// Source are defined render textures
@property (strong, nonatomic) RenderTexture * leftSourceTexture;
@property (strong, nonatomic) RenderTexture * rightSourceTexture;
@property (strong, nonatomic) EyeTexture * leftEyeSource;
@property (strong, nonatomic) EyeTexture * rightEyeSource;

@property (assign, nonatomic, readonly) float nativeScale;

@property (strong, nonatomic, readonly) SCNRenderer * leftRenderer;
@property (strong, nonatomic, readonly) SCNRenderer * rightRenderer;

@property (strong, nonatomic) EyeTexture * leftEyeDest;
@property (strong, nonatomic) EyeTexture * rightEyeDest;

@property (strong, nonatomic, readonly) ColorCorrection * eyeColorCorrection;

@property (strong, nonatomic, readonly) VBOWrap * leftEyeMesh;
@property (strong, nonatomic, readonly) VBOWrap * rightEyeMesh;

@property (strong, nonatomic, readonly) SCNScene * scene;

// THis is the infered render texture
@property (strong, nonatomic) RenderTexture * destTexture;

// Where to render from
@property (weak, nonatomic) SCNViewpoint * viewpoint;

@property (assign, readonly) BOOL restrictToAxis;
@property (assign, readonly) BOOL restrictRoll;
@property (assign, readonly) BOOL restrictYaw;
@property (assign, readonly) BOOL restrictPitch;

@property (assign, atomic) BOOL enableRawValues;
@property (assign, readonly) float rawYaw;
@property (assign, readonly) float rawPitch;
@property (assign, readonly) float rawRoll;

@property (assign) BOOL useHeadTracking;

@property (assign, readonly) GLKQuaternion nullViewpoint;

-(SCNScene *) generateScene;

-(void) afterGenerateScene;

// Viewport Helpers

-(SCNViewpoint *) generateGhostViewpoint;

-(void) setViewpointTo:(SCNViewpoint *) viewpoint;

-(void) setBackgroundImage:(NSString *) filePrefix;

- (void) update;

- (void) updateViewpointOrientation;

-(NSArray *) viewpointSees;

-(NSArray *) viewpointSeesWithOffset:(float) offset;

-(NSArray *) viewpointSeesAt:(float) x y:(float) y;

-(void) restrictYaw:(BOOL) yaw pitch:(BOOL) pitch roll:(BOOL) roll;

@end
