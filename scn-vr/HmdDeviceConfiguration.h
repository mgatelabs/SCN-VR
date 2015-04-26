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

typedef NS_ENUM(NSInteger, HmdDeviceConfigurationDistortion) {
    HmdDeviceConfigurationDistortionNone = 0,
    HmdDeviceConfigurationDistortionBarrel = 1,
    HmdDeviceConfigurationDistortionPincushion = 2
};

typedef NS_ENUM(NSInteger, HmdDeviceConfigurationCorrection) {
    HmdDeviceConfigurationCorrectionNone = 0,
    HmdDeviceConfigurationCorrectionChromatic = 1
};

typedef NS_ENUM(NSInteger, HmdDeviceConfigurationViewpoints) {
    HmdDeviceConfigurationViewpointsMono = 0,
    HmdDeviceConfigurationViewpointsSBS = 1
};

@interface HmdDeviceConfiguration : NSObject

@property (strong, nonatomic) NSString * name;

@property (strong, readonly, nonatomic) NSString *  identity;

@property (assign) BOOL internal;

@property (assign, nonatomic) BOOL deviceUsed;

//Is barrel distortion enabled or not
@property (assign, readonly) HmdDeviceConfigurationDistortion distortion;

//Is chromatic correction enabled or not
@property (assign, readonly) HmdDeviceConfigurationCorrection correction;

@property (assign, readonly) HmdDeviceConfigurationViewpoints viewpoints;

//Inter pupillary distance in millimeters.
@property (assign) float ipd;

@property (assign, nonatomic) BOOL extraIpdAvailable;

@property (assign) float ipdChild;
@property (assign) float ipdAdult;

//Inter lens distance in millimeters.
@property (assign) float ild;

//Vertical field of view of both cameras
@property (assign) float fov;

@property (assign) float hFov;
@property (assign) float vFov;

// Correction parameters
@property (assign) float correctionCoefficient;

// Distortion parameters.
@property (assign) float distortionFactorA;
@property (assign) float distortionFactorB;

- (instancetype)initAs:(NSString *) name identifier:(NSString *) identifier distortion:(HmdDeviceConfigurationDistortion) distortion correction:(HmdDeviceConfigurationCorrection) correction viewpoints:(HmdDeviceConfigurationViewpoints) viewpoints ipd:(float) ipd ild:(float) ild fov:(float) fov correctionCoefficient:(float) correctionCoefficient distortionFactorA:(float) distortionFactorA distortionFactorB:(float) distortionFactorB;

@end
