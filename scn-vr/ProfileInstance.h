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
#import "TrackerBase.h"
#import "RenderBase.h"

typedef NS_ENUM(NSInteger, ProfileInstanceSS)
{
    ProfileInstanceSS1X = 0,
    ProfileInstanceSS125X = 1,
    ProfileInstanceSS15X = 2,
    ProfileInstanceSS2X = 3
};

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

@property (assign, nonatomic) float forcedScale;

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

// Super Sampling
@property (assign, nonatomic) ProfileInstanceSS ssMode;

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
-(float) getExtendedValueFor:(NSString *) key withDefaultFloat:(float) value;
-(NSString *) getExtendedValueFor:(NSString *) key withDefaultNSString:(NSString *) value;

@end
