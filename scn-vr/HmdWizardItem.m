//
//  HmdWizardItem.m
//  scn-vr
//
//  Created by Michael Fuller on 1/16/15.
//  Copyright (c) 2015 M-Gate Labs. All rights reserved.
//

#import "HmdWizardItem.h"
#import "HmdDeviceManager.h"
#import "RenderManager.h"

@implementation HmdWizardItem {
    NSArray * hmds;
}

- (instancetype)init
{
    self = [super initWith:@"HMD" info:@"Please let us know what Head Mounted Device you are using.  If you don't have a HMD, select one of the 'NONE' options.  'None (MONO)' is for children under 7." itemId:WIZARD_ITEM_HMD type:WizardItemDataTypeString];
    if (self) {
        
        hmds = [HmdDeviceManager getHMDs];
        
        self.count = (int)hmds.count;
        
        _selected = [hmds objectAtIndex:1];
        self.valueIndex = 1;
        self.valueId = _selected.identity;
    }
    return self;
}

-(BOOL) available {
    return self.count > 0;
}

-(BOOL) ready {
    return self.count > 0 && _selected != nil;
}

-(NSString *) stringForIndex:(int) index {
    HmdDeviceConfiguration * d = [hmds objectAtIndex:index];
    return d.name;
}

-(void) selectedIndex:(int) index {
    self.valueIndex = index;
    HmdDeviceConfiguration * d = [hmds objectAtIndex:index];
    _selected = d;
    self.valueId = d.identity;
}

-(void) loadForIdentity:(NSString *) identity {
    _selected = [hmds objectAtIndex:1];
    self.valueId = _selected.identity;
    self.valueIndex = 1;
    
    for (int i = 0; i < hmds.count; i++) {
        HmdDeviceConfiguration * temp = [hmds objectAtIndex:i];
        if ([temp.identity isEqualToString:identity]) {
            _selected = temp;
            self.valueId = temp.identity;
            self.valueIndex = i;
            break;
        }
    }
}

-(void) updateProfileInstance:(ProfileInstance *) instance {
    
    HmdDeviceConfiguration * d = [hmds objectAtIndex:self.valueIndex];
    
    switch (self.valueIndex) {
        case 0:
            // Cyclops
            instance.viewportCount = 1;
            instance.cameraIPD = 0;
            instance.viewerIPD = 0;
            instance.basicView = YES;
            
            instance.centerIPD = YES;
            instance.colorCorrection = NO;
            instance.distortionCorrection = NO;
            break;
        case 1:
            // SBS
            instance.viewportCount = 2;
            instance.basicView = YES;
            
            instance.centerIPD = YES;
            instance.cameraIPD = 62;
            instance.viewerIPD = 62;
            
            instance.colorCorrection = NO;
            instance.distortionCorrection = NO;
            break;
        default:
            instance.viewportCount = 2;
            instance.basicView = NO;
            
            instance.centerIPD = NO;
            instance.cameraIPD = d.ipd;
            instance.viewerIPD = d.ipd;
            
            instance.colorCorrection = d.correction == HmdDeviceConfigurationCorrectionChromatic;
            instance.colorCorrectionValue = d.correctionCoefficient;
            
            instance.distortionCorrection = d.distortion == HmdDeviceConfigurationDistortionBarrel;
            instance.distortionCorrectionValue1 = d.distortionFactorA;
            instance.distortionCorrectionValue2 = d.distortionFactorB;
    }
    
    RenderManager * renderManager = [RenderManager sharedManager];
    instance.renderer = [renderManager findRendererForViewports:instance.viewportCount];
    
}

@end
