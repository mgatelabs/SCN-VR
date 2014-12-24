//
//  HmdDeviceManager.m
//  SCN-VR
//
//  Created by Michael Fuller on 12/19/14.
//  Copyright (c) 2014 M-Gate Labs. All rights reserved.
//

#import "HmdDeviceManager.h"

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
        _hmds = [[NSMutableArray alloc] initWithCapacity:4];
        
        HmdDeviceConfiguration * mono = [self addHmd:@"None (Mono)" identifier:@"mono" distortion:HmdDeviceConfigurationDistortionNone correction:HmdDeviceConfigurationCorrectionNone viewpoints:HmdDeviceConfigurationViewpointsMono ipd:0.0f ild:0.0f fov:85.0f correctionCoefficient:0.0f distortionFactorA:0.0f distortionFactorB:0.0f];
        mono.internal = YES;
        mono.hFov = 120;
        
        [self addHmd:@"None (SBS)" identifier:@"none" distortion:HmdDeviceConfigurationDistortionNone correction:HmdDeviceConfigurationCorrectionNone viewpoints:HmdDeviceConfigurationViewpointsSBS ipd:62.0f ild:62.0f fov:85.0f correctionCoefficient:0.0f distortionFactorA:0.0f distortionFactorB:0.0f].internal = YES;
        
        [self addHmd:@"Altergaze" identifier:@"altergaze" distortion:HmdDeviceConfigurationDistortionBarrel correction:HmdDeviceConfigurationCorrectionChromatic viewpoints:HmdDeviceConfigurationViewpointsSBS ipd:62.0f ild:62.0f fov:85.0f correctionCoefficient:-1.0f distortionFactorA:0.4f distortionFactorB:0.2f].internal = YES;
        
        [self addHmd:@"Cardboard" identifier:@"cardboard" distortion:HmdDeviceConfigurationDistortionBarrel correction:HmdDeviceConfigurationCorrectionChromatic viewpoints:HmdDeviceConfigurationViewpointsSBS ipd:62.0f ild:62.0f fov:85.0f correctionCoefficient:-1.5f distortionFactorA:0.5f distortionFactorB:0.2f].internal = YES;
        
        _hmd = [_hmds objectAtIndex:1];
    }
    return self;
}

-(HmdDeviceConfiguration *) addHmd:(NSString *) name identifier:(NSString *) identifier distortion:(HmdDeviceConfigurationDistortion) distortion correction:(HmdDeviceConfigurationCorrection) correction viewpoints:(HmdDeviceConfigurationViewpoints) viewpoints ipd:(float) ipd ild:(float) ild fov:(float) fov correctionCoefficient:(float) correctionCoefficient distortionFactorA:(float) distortionFactorA distortionFactorB:(float) distortionFactorB {
    HmdDeviceConfiguration * hmd = [[HmdDeviceConfiguration alloc] initAs:name identifier:identifier distortion:distortion correction:correction viewpoints:viewpoints ipd:ipd ild:ild fov:fov correctionCoefficient:correctionCoefficient distortionFactorA:distortionFactorA distortionFactorB:distortionFactorB];
    
    [_hmds addObject:hmd];
    
    return hmd;
}

-(BOOL) removeHmdWithIndex:(int) index {
    if (index >= 0 && index < _hmds.count) {
        HmdDeviceConfiguration * device = [_hmds objectAtIndex:index];
        if (device.internal) {
            return NO;
        }
        [_hmds removeObjectAtIndex:index];
        return YES;
    }
    return NO;
}


-(void) cycle {
    int nextIndex = [self getIndexFor:_hmd];
    nextIndex = (nextIndex + 1) % self.hmds.count;
    _hmd = [self.hmds objectAtIndex:nextIndex];
}

-(int) getIndexFor:(HmdDeviceConfiguration *) hmdConfiguration {
    for (int i = 0; i < self.hmds.count; i++) {
        HmdDeviceConfiguration * temp = [self.hmds objectAtIndex:i];
        if (temp == hmdConfiguration) {
            return i;
        }
    }
    return 0;
}

-(ListableManagerType) getListType {
    return ListableManagerTypeSimple;
}

-(NSString *) getListName {
    return @"HMD";
}

-(NSString *) getListItemNameFor:(int) index {
    HmdDeviceConfiguration * d = [_hmds objectAtIndex:index];
    return d.name;
}

-(int) getListItemCount {
    return (int)_hmds.count;
}

-(int) getSelectedItemIndex {
    
    if (_hmd == nil) {
        return - 1;
    }
    
    for (int i = 0; i < _hmds.count; i++) {
        HmdDeviceConfiguration * d = [_hmds objectAtIndex:i];
        if (d == _hmd) {
            return i;
        }
    }
    
    NSLog(@"Logic problem, selected item is not in array");
    
    return -1;
}

-(void) selectListItemAt:(int) index {
    _hmd = [_hmds objectAtIndex:index];
}

@end
