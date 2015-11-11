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

#import "HmdDeviceManager.h"
#import "SCNVRResourceBundler.h"

@implementation HmdDeviceManager

+ (id)sharedManager {
    static HmdDeviceManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+(NSMutableArray *) getHMDs {
    NSMutableArray * hmds = [[NSMutableArray alloc] initWithCapacity:4];
        
    HmdDeviceConfiguration * mono = [HmdDeviceManager addHmdTo:hmds name: NSLocalizedStringFromTableInBundle(@"HMD_NONE_MONO", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"None (Mono)") identifier:@"mono" distortion:HmdDeviceConfigurationDistortionNone correction:HmdDeviceConfigurationCorrectionNone viewpoints:HmdDeviceConfigurationViewpointsMono ipd:0.0f ild:0.0f fov:85.0f correctionCoefficient:0.0f distortionFactorA:0.0f distortionFactorB:0.0f];
    mono.internal = YES;
    mono.hFov = 100;
    mono.vFov = 75;
    
    HmdDeviceConfiguration * sbs = [HmdDeviceManager addHmdTo: hmds name: NSLocalizedStringFromTableInBundle(@"HMD_NONE_SBS", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"None (SBS)") identifier:@"none" distortion:HmdDeviceConfigurationDistortionNone correction:HmdDeviceConfigurationCorrectionNone viewpoints:HmdDeviceConfigurationViewpointsSBS ipd:62.0f ild:62.0f fov:85.0f correctionCoefficient:0.0f distortionFactorA:0.0f distortionFactorB:0.0f];
    sbs.internal = YES;
    
    HmdDeviceConfiguration * altergaze = [HmdDeviceManager addHmdTo: hmds name: NSLocalizedStringFromTableInBundle(@"HMD_ALTERGAZE", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"Altergaze") identifier:@"altergaze" distortion:HmdDeviceConfigurationDistortionBarrel correction:HmdDeviceConfigurationCorrectionChromatic viewpoints:HmdDeviceConfigurationViewpointsSBS ipd:62.0f ild:62.0f fov:85.0f correctionCoefficient:-1.0f distortionFactorA:0.4f distortionFactorB:0.2f];
    altergaze.internal = YES;
    altergaze.extraIpdAvailable = YES;
    altergaze.ipdAdult = 50;
    altergaze.ipdChild = 47.5f;
    altergaze.deviceUsed = YES;
    
    HmdDeviceConfiguration * cardboard = [HmdDeviceManager addHmdTo: hmds name: NSLocalizedStringFromTableInBundle(@"HMD_CARDBOARD", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"Cardboard") identifier:@"cardboard" distortion:HmdDeviceConfigurationDistortionBarrel correction:HmdDeviceConfigurationCorrectionChromatic viewpoints:HmdDeviceConfigurationViewpointsSBS ipd:62.0f ild:62.0f fov:85.0f correctionCoefficient:-1.5f distortionFactorA:0.5f distortionFactorB:0.2f];
    cardboard.internal = YES;
    cardboard.deviceUsed = YES;
    
    HmdDeviceConfiguration * firefly = [HmdDeviceManager addHmdTo: hmds name: NSLocalizedStringFromTableInBundle(@"HMD_FIREFLY", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"Firefly") identifier:@"firefly" distortion:HmdDeviceConfigurationDistortionBarrel correction:HmdDeviceConfigurationCorrectionChromatic viewpoints:HmdDeviceConfigurationViewpointsSBS ipd:62.0f ild:62.0f fov:85.0f correctionCoefficient:-2.0f distortionFactorA:0.7f distortionFactorB:0.2f];
    firefly.internal = YES;
    firefly.deviceUsed = YES;
    
    HmdDeviceConfiguration * vrOne = [HmdDeviceManager addHmdTo: hmds name: NSLocalizedStringFromTableInBundle(@"HMD_ZEISSVRONE", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"ZEISS VR ONE") identifier:@"vrone" distortion:HmdDeviceConfigurationDistortionBarrel correction:HmdDeviceConfigurationCorrectionChromatic viewpoints:HmdDeviceConfigurationViewpointsSBS ipd:62.0f ild:62.0f fov:85.0f correctionCoefficient:-2.0f distortionFactorA:1.25f distortionFactorB:1.25f];
    vrOne.internal = YES;
    vrOne.deviceUsed = YES;
    
    HmdDeviceConfiguration * dive5 = [HmdDeviceManager addHmdTo: hmds name: NSLocalizedStringFromTableInBundle(@"HMD_DIVE", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"Durovis Dive") identifier:@"dive5" distortion:HmdDeviceConfigurationDistortionBarrel correction:HmdDeviceConfigurationCorrectionChromatic viewpoints:HmdDeviceConfigurationViewpointsSBS ipd:62.0f ild:62.0f fov:90.0f correctionCoefficient:-1.5f distortionFactorA:0.5f distortionFactorB:0.2f];
    dive5.internal = YES;
    dive5.deviceUsed = YES;
    
    HmdDeviceConfiguration * homido5 = [HmdDeviceManager addHmdTo: hmds name: NSLocalizedStringFromTableInBundle(@"HMD_HOMIDO", @"SCN-VRDevices", [SCNVRResourceBundler getSCNVRResourceBundle], @"Homido") identifier:@"Homido5" distortion:HmdDeviceConfigurationDistortionBarrel correction:HmdDeviceConfigurationCorrectionChromatic viewpoints:HmdDeviceConfigurationViewpointsSBS ipd:62.0f ild:62.0f fov:90.0f correctionCoefficient:-1.5f distortionFactorA:0.5f distortionFactorB:0.2f];
    homido5.internal = YES;
    homido5.deviceUsed = YES;
    
    return hmds;
}

+(HmdDeviceConfiguration *) addHmdTo:(NSMutableArray *) dest name:(NSString *) name identifier:(NSString *) identifier distortion:(HmdDeviceConfigurationDistortion) distortion correction:(HmdDeviceConfigurationCorrection) correction viewpoints:(HmdDeviceConfigurationViewpoints) viewpoints ipd:(float) ipd ild:(float) ild fov:(float) fov correctionCoefficient:(float) correctionCoefficient distortionFactorA:(float) distortionFactorA distortionFactorB:(float) distortionFactorB {
    HmdDeviceConfiguration * hmd = [[HmdDeviceConfiguration alloc] initAs:name identifier:identifier distortion:distortion correction:correction viewpoints:viewpoints ipd:ipd ild:ild fov:fov correctionCoefficient:correctionCoefficient distortionFactorA:distortionFactorA distortionFactorB:distortionFactorB];
    
    [dest addObject:hmd];
    return hmd;
}

@end
