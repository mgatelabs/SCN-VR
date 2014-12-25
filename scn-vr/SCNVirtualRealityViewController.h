//
//  SCNVirtualRealityViewController.h
//  SCN-VR
//
//  Created by Michael Fuller on 12/19/14.
//  Copyright (c) 2014 M-Gate Labs. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "HmdMobileDevicePair.h"
#import "SCNViewpoint.h"
#import "RenderTexture.h"
#import "EyeTexture.h"
#import "RenderBase.h"
#import "ColorCorrection.h"
#import "DistortionMeshGenerator.h"
#import "TrackerBase.h"

@interface SCNVirtualRealityViewController : GLKViewController  <SCNSceneRendererDelegate>

// This needs to be set in the segue to this screen
@property (strong, nonatomic) HmdMobileDevicePair * pair;
@property (weak, nonatomic) RenderBase * renderer;
@property (weak, nonatomic) TrackerBase * tracker;

// Source are defined render textures
@property (strong, nonatomic) RenderTexture * leftSourceTexture;
@property (strong, nonatomic) RenderTexture * rightSourceTexture;
@property (strong, nonatomic) EyeTexture * leftEyeSource;
@property (strong, nonatomic) EyeTexture * rightEyeSource;

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

-(SCNScene *) generateScene;

-(void) afterGenerateScene;

// Viewport Helpers

-(SCNViewpoint *) generateGhostViewpoint;

-(void) setViewpointTo:(SCNViewpoint *) viewpoint;

-(void) setBackgroundImage:(NSString *) filePrefix;

- (void) update;

- (void) updateViewpointOrientation;

-(NSArray *) viewpointSees;

@end
