//
//  HmdDeviceManager.h
//  SCN-VR
//
//  Created by Michael Fuller on 12/19/14.
//  Copyright (c) 2014 M-Gate Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HmdDeviceConfiguration.h"

@interface HmdDeviceManager : NSObject

@property (weak, readonly, nonatomic) HmdDeviceConfiguration * hmd;

@property (strong, readonly, nonatomic) NSMutableArray * hmds;

+ (id)sharedManager;

-(HmdDeviceConfiguration *) addHmd:(NSString *) name identifier:(NSString *) identifier distortion:(HmdDeviceConfigurationDistortion) distortion correction:(HmdDeviceConfigurationCorrection) correction viewpoints:(HmdDeviceConfigurationViewpoints) viewpoints ipd:(float) ipd ild:(float) ild fov:(float) fov correctionCoefficient:(float) correctionCoefficient distortionFactorA:(float) distortionFactorA distortionFactorB:(float) distortionFactorB;

-(BOOL) removeHmdWithIndex:(int) index;

-(void) cycle;

-(int) getIndexFor:(HmdDeviceConfiguration *) hmdConfiguration;

@end
