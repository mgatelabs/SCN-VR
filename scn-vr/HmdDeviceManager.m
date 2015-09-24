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
        
        /*
        _hmds = [[NSMutableArray alloc] initWithCapacity:4];
        
        HmdDeviceConfiguration * mono = [self addHmd:@"None (Mono)" identifier:@"mono" distortion:HmdDeviceConfigurationDistortionNone correction:HmdDeviceConfigurationCorrectionNone viewpoints:HmdDeviceConfigurationViewpointsMono ipd:0.0f ild:0.0f fov:85.0f correctionCoefficient:0.0f distortionFactorA:0.0f distortionFactorB:0.0f];
        mono.internal = YES;
        mono.hFov = 100;
        mono.vFov = 75;
        
        [self addHmd:@"None (SBS)" identifier:@"none" distortion:HmdDeviceConfigurationDistortionNone correction:HmdDeviceConfigurationCorrectionNone viewpoints:HmdDeviceConfigurationViewpointsSBS ipd:62.0f ild:62.0f fov:85.0f correctionCoefficient:0.0f distortionFactorA:0.0f distortionFactorB:0.0f].internal = YES;
        
        [self addHmd:@"Altergaze" identifier:@"altergaze" distortion:HmdDeviceConfigurationDistortionBarrel correction:HmdDeviceConfigurationCorrectionChromatic viewpoints:HmdDeviceConfigurationViewpointsSBS ipd:62.0f ild:62.0f fov:85.0f correctionCoefficient:-1.0f distortionFactorA:0.4f distortionFactorB:0.2f].internal = YES;
        
        [self addHmd:@"Altergaze W/O Color" identifier:@"altergazewoc" distortion:HmdDeviceConfigurationDistortionBarrel correction:HmdDeviceConfigurationCorrectionNone viewpoints:HmdDeviceConfigurationViewpointsSBS ipd:62.0f ild:62.0f fov:85.0f correctionCoefficient:0 distortionFactorA:0.4f distortionFactorB:0.2f].internal = YES;
        
        [self addHmd:@"Cardboard" identifier:@"cardboard" distortion:HmdDeviceConfigurationDistortionBarrel correction:HmdDeviceConfigurationCorrectionChromatic viewpoints:HmdDeviceConfigurationViewpointsSBS ipd:62.0f ild:62.0f fov:85.0f correctionCoefficient:-1.5f distortionFactorA:0.5f distortionFactorB:0.2f].internal = YES;
        
        [self addHmd:@"Cardboard W/O Color" identifier:@"cardboardwoc" distortion:HmdDeviceConfigurationDistortionBarrel correction:HmdDeviceConfigurationCorrectionNone viewpoints:HmdDeviceConfigurationViewpointsSBS ipd:62.0f ild:62.0f fov:85.0f correctionCoefficient:0 distortionFactorA:0.5f distortionFactorB:0.2f].internal = YES;
        
        //ALPSConfig(Device _DeviceName, bool _EnableBarrelDistortion, bool _EnableChromaticCorrection, bool _FixedSize, float _IPD, float _ILD, float _FieldOfView, float _ChromaticCorrection, float _k1, float _k2, int _Width, int _Height){

        [self addHmd:@"Firefly" identifier:@"firefly" distortion:HmdDeviceConfigurationDistortionBarrel correction:HmdDeviceConfigurationCorrectionChromatic viewpoints:HmdDeviceConfigurationViewpointsSBS ipd:62.0f ild:62.0f fov:85.0f correctionCoefficient:-2.0f distortionFactorA:0.7f distortionFactorB:0.2f].internal = YES;
        
        [self load];
         */
        
    }
    return self;
}

+(NSMutableArray *) getHMDs {
    NSMutableArray * hmds = [[NSMutableArray alloc] initWithCapacity:4];
        
    HmdDeviceConfiguration * mono = [HmdDeviceManager addHmdTo:hmds name:@"None (Mono)" identifier:@"mono" distortion:HmdDeviceConfigurationDistortionNone correction:HmdDeviceConfigurationCorrectionNone viewpoints:HmdDeviceConfigurationViewpointsMono ipd:0.0f ild:0.0f fov:85.0f correctionCoefficient:0.0f distortionFactorA:0.0f distortionFactorB:0.0f];
    mono.internal = YES;
    mono.hFov = 100;
    mono.vFov = 75;
    
    HmdDeviceConfiguration * sbs = [HmdDeviceManager addHmdTo: hmds name:@"None (SBS)" identifier:@"none" distortion:HmdDeviceConfigurationDistortionNone correction:HmdDeviceConfigurationCorrectionNone viewpoints:HmdDeviceConfigurationViewpointsSBS ipd:62.0f ild:62.0f fov:85.0f correctionCoefficient:0.0f distortionFactorA:0.0f distortionFactorB:0.0f];
    sbs.internal = YES;
    
    HmdDeviceConfiguration * altergaze = [HmdDeviceManager addHmdTo: hmds name:@"Altergaze" identifier:@"altergaze" distortion:HmdDeviceConfigurationDistortionBarrel correction:HmdDeviceConfigurationCorrectionChromatic viewpoints:HmdDeviceConfigurationViewpointsSBS ipd:62.0f ild:62.0f fov:85.0f correctionCoefficient:-1.0f distortionFactorA:0.4f distortionFactorB:0.2f];
    altergaze.internal = YES;
    altergaze.extraIpdAvailable = YES;
    altergaze.ipdAdult = 50;
    altergaze.ipdChild = 47.5f;
    altergaze.deviceUsed = YES;
    
    HmdDeviceConfiguration * cardboard = [HmdDeviceManager addHmdTo: hmds name:@"Cardboard" identifier:@"cardboard" distortion:HmdDeviceConfigurationDistortionBarrel correction:HmdDeviceConfigurationCorrectionChromatic viewpoints:HmdDeviceConfigurationViewpointsSBS ipd:62.0f ild:62.0f fov:85.0f correctionCoefficient:-1.5f distortionFactorA:0.5f distortionFactorB:0.2f];
    cardboard.internal = YES;
    cardboard.deviceUsed = YES;
    
    HmdDeviceConfiguration * firefly = [HmdDeviceManager addHmdTo: hmds name:@"Firefly" identifier:@"firefly" distortion:HmdDeviceConfigurationDistortionBarrel correction:HmdDeviceConfigurationCorrectionChromatic viewpoints:HmdDeviceConfigurationViewpointsSBS ipd:62.0f ild:62.0f fov:85.0f correctionCoefficient:-2.0f distortionFactorA:0.7f distortionFactorB:0.2f];
    firefly.internal = YES;
    firefly.deviceUsed = YES;
    
    HmdDeviceConfiguration * vrOne = [HmdDeviceManager addHmdTo: hmds name:@"ZEISS VR ONE" identifier:@"vrone" distortion:HmdDeviceConfigurationDistortionBarrel correction:HmdDeviceConfigurationCorrectionChromatic viewpoints:HmdDeviceConfigurationViewpointsSBS ipd:62.0f ild:62.0f fov:85.0f correctionCoefficient:-2.0f distortionFactorA:1.25f distortionFactorB:1.25f];
    vrOne.internal = YES;
    vrOne.deviceUsed = YES;
    
    HmdDeviceConfiguration * dive5 = [HmdDeviceManager addHmdTo: hmds name:@"Durovis Dive 5\"" identifier:@"dive5" distortion:HmdDeviceConfigurationDistortionBarrel correction:HmdDeviceConfigurationCorrectionChromatic viewpoints:HmdDeviceConfigurationViewpointsSBS ipd:62.0f ild:62.0f fov:90.0f correctionCoefficient:-1.5f distortionFactorA:0.5f distortionFactorB:0.2f];
    dive5.internal = YES;
    dive5.deviceUsed = YES;
    
    HmdDeviceConfiguration * homido5 = [HmdDeviceManager addHmdTo: hmds name:@"Homido" identifier:@"Homido5" distortion:HmdDeviceConfigurationDistortionBarrel correction:HmdDeviceConfigurationCorrectionChromatic viewpoints:HmdDeviceConfigurationViewpointsSBS ipd:62.0f ild:62.0f fov:90.0f correctionCoefficient:-1.5f distortionFactorA:0.5f distortionFactorB:0.2f];
    homido5.internal = YES;
    homido5.deviceUsed = YES;
    
    return hmds;
}

/*
-(void) persist {
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    [defs setValue:_hmd.identity forKey:@"scn-vr.hmds.selected"];
    [defs synchronize];
}

-(void) load {
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    
    NSString * selectedIndentity = [defs valueForKey:@"scn-vr.hmds.selected"];
    
    _hmd = [_hmds objectAtIndex:1];
    
    if (selectedIndentity != nil) {
     
        for (int i = 0; i < _hmds.count; i++) {
            HmdDeviceConfiguration * d = [_hmds objectAtIndex:i];
            if ([d.identity isEqualToString:selectedIndentity]) {
                _hmd = d;
                return;
            }
        }
    }
}
*/


+(HmdDeviceConfiguration *) addHmdTo:(NSMutableArray *) dest name:(NSString *) name identifier:(NSString *) identifier distortion:(HmdDeviceConfigurationDistortion) distortion correction:(HmdDeviceConfigurationCorrection) correction viewpoints:(HmdDeviceConfigurationViewpoints) viewpoints ipd:(float) ipd ild:(float) ild fov:(float) fov correctionCoefficient:(float) correctionCoefficient distortionFactorA:(float) distortionFactorA distortionFactorB:(float) distortionFactorB {
    HmdDeviceConfiguration * hmd = [[HmdDeviceConfiguration alloc] initAs:name identifier:identifier distortion:distortion correction:correction viewpoints:viewpoints ipd:ipd ild:ild fov:fov correctionCoefficient:correctionCoefficient distortionFactorA:distortionFactorA distortionFactorB:distortionFactorB];
    
    [dest addObject:hmd];
    return hmd;
}

/*
-(HmdDeviceConfiguration *) addHmd:(NSString *) name identifier:(NSString *) identifier distortion:(HmdDeviceConfigurationDistortion) distortion correction:(HmdDeviceConfigurationCorrection) correction viewpoints:(HmdDeviceConfigurationViewpoints) viewpoints ipd:(float) ipd ild:(float) ild fov:(float) fov correctionCoefficient:(float) correctionCoefficient distortionFactorA:(float) distortionFactorA distortionFactorB:(float) distortionFactorB {
    HmdDeviceConfiguration * hmd = [[HmdDeviceConfiguration alloc] initAs:name identifier:identifier distortion:distortion correction:correction viewpoints:viewpoints ipd:ipd ild:ild fov:fov correctionCoefficient:correctionCoefficient distortionFactorA:distortionFactorA distortionFactorB:distortionFactorB];
    
    [_hmds addObject:hmd];
    
    return hmd;
}
*/
/*
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
    [self persist];
}
*/

@end
