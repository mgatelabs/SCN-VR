//
//  HmdDeviceConfiguration.m
//  SCN-VR
//
//  Created by Michael Fuller on 12/19/14.
//  Copyright (c) 2014 M-Gate Labs. All rights reserved.
//

#import "HmdDeviceConfiguration.h"

@implementation HmdDeviceConfiguration

- (instancetype)initAs:(NSString *) name identifier:(NSString *) identifier distortion:(HmdDeviceConfigurationDistortion) distortion correction:(HmdDeviceConfigurationCorrection) correction viewpoints:(HmdDeviceConfigurationViewpoints) viewpoints ipd:(float) ipd ild:(float) ild fov:(float) fov correctionCoefficient:(float) correctionCoefficient distortionFactorA:(float) distortionFactorA distortionFactorB:(float) distortionFactorB
{
    self = [super init];
    if (self) {
        self.name = name;
        _identity = identifier;
        _distortion = distortion;
        _correction = correction;
        _viewpoints = viewpoints;
        self.ipd = ipd;
        self.ild = ild;
        self.fov = fov;
        self.hFov = fov;
        self.vFov = fov;
        self.correctionCoefficient = correctionCoefficient;
        self.distortionFactorA = distortionFactorA;
        self.distortionFactorB = distortionFactorB;
        self.internal = NO;
    }
    return self;
}

@end
