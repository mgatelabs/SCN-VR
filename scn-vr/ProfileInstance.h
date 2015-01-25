//
//  ProfileInstance.h
//  scn-vr
//
//  Created by Michael Fuller on 1/17/15.
//  Copyright (c) 2015 M-Gate Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TrackerBase.h"
#import "RenderBase.h"

@class RenderBase;

@interface ProfileInstance : NSObject

// Head Tracker
@property (weak, nonatomic) TrackerBase * tracker;

// Render
@property (weak, nonatomic) RenderBase * renderer;

// Physical Info
@property (assign, nonatomic) int physicalWidthPX;
@property (assign, nonatomic) float physicalWidthIN;
@property (assign, nonatomic) float physicalWidthMM;

@property (assign, nonatomic) int physicalHeightPX;
@property (assign, nonatomic) float physicalHeightIN;
@property (assign, nonatomic) float physicalHeightMM;

@property (assign, nonatomic) int physicalDPI;

// Virtual Info
@property (assign, nonatomic) int virtualWidthPX;
@property (assign, nonatomic) float virtualWidthIN;
@property (assign, nonatomic) float virtualWidthMM;

@property (assign, nonatomic) int virtualHeightPX;
@property (assign, nonatomic) float virtualHeightIN;
@property (assign, nonatomic) float virtualHeightMM;

@property (assign, nonatomic) int virtualOffsetLeft;
@property (assign, nonatomic) int virtualOffsetBottom;

@property (assign, nonatomic) BOOL landscapeView;
@property (assign, nonatomic) BOOL basicView;

@property (assign, nonatomic) int viewportCount;

@property (assign, nonatomic) int hFov;
@property (assign, nonatomic) int vFov;

// IPD
@property (assign, nonatomic) float cameraIPD;
@property (assign, nonatomic) float viewerIPD;
@property (assign, nonatomic) BOOL centerIPD;

// Color Correction
@property (assign, nonatomic) BOOL colorCorrection;
@property (assign, nonatomic) float colorCorrectionValue;

// Distortion
@property (assign, nonatomic) BOOL distortionCorrection;
@property (assign, nonatomic) float distortionCorrectionValue1;
@property (assign, nonatomic) float distortionCorrectionValue2;

// Extended
@property (strong, nonatomic) NSMutableDictionary * extended;

-(int) getExtendedValueFor:(NSString *) key withDefaultInt:(int) value;

@end
