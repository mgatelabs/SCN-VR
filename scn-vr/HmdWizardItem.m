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

#import "HmdWizardItem.h"
#import "HmdDeviceManager.h"
#import "RenderManager.h"
#import "SCNVRResourceBundler.h"

@implementation HmdWizardItem {
    NSArray * hmds;
}

- (instancetype)init
{
    self = [super initWith: NSLocalizedStringFromTableInBundle(@"WIZARD_ITEM_TITLE_HMD", @"SCN-VRProfile", [SCNVRResourceBundler getSCNVRResourceBundle], @"Head Mounted Display (HMD)") info: NSLocalizedStringFromTableInBundle(@"WIZARD_ITEM_INFO_HMD", @"SCN-VRProfile", [SCNVRResourceBundler getSCNVRResourceBundle], @"Please let us know what Head Mounted Device, HMD, you are currently using.  If you don't have a HMD, select one of the 'NONE' options.  'None (MONO)' is designed for children under 7.") itemId:WIZARD_ITEM_HMD type:WizardItemDataTypeString];
    if (self) {
        hmds = [HmdDeviceManager getHMDs];
        
        self.count = (int)hmds.count;
        
        _selected = [hmds objectAtIndex:1];
        self.valueIndex = 1;
        self.valueId = _selected.identity;
    }
    return self;
}

-(void) reset {
    _selected = [hmds objectAtIndex:1];
    self.valueIndex = 1;
    self.valueId = _selected.identity;
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
