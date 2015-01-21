//
//  HmdDeviceConfiguration.h
//  SCN-VR
//
//  Created by Michael Fuller on 12/19/14.
//  Copyright (c) 2014 M-Gate Labs. All rights reserved.
//

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
