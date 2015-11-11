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

#import "PhysicalDeviceWizardItem.h"
#import "MobileDeviceManager.h"
#import "SCNVRResourceBundler.h"

@implementation PhysicalDeviceWizardItem {
    MobileDeviceManager * mdm;
    MobileDeviceConfiguration * device;
}

- (instancetype)init
{
    self = [super initWith: NSLocalizedStringFromTableInBundle(@"WIZARD_ITEM_TITLE_DEVICE", @"SCN-VRProfile", [SCNVRResourceBundler getSCNVRResourceBundle], @"Device") info: NSLocalizedStringFromTableInBundle(@"WIZARD_ITEM_INFO_DEVICE", @"SCN-VRProfile", [SCNVRResourceBundler getSCNVRResourceBundle], @"Please select the device you are currently using. Selecting a incorrect device will distort your perspective.") itemId:WIZARD_ITEM_DEVICE type:WizardItemDataTypeString];
    if (self) {
        mdm = [MobileDeviceManager sharedManager];
        self.count = (int)mdm.devices.count;
        
        if (self.count > 0) {
            // Always choose the first
            device = [mdm.devices objectAtIndex:0];
            _selected = device;
            self.valueIndex = 0;
            self.valueId = device.identifier;
        }
    }
    return self;
}

-(BOOL) available {
    return self.count > 0;
}

-(BOOL) ready {
    return self.count > 0;
}

-(void) loadForIdentity:(NSString *) identity {
    device = [mdm.devices objectAtIndex:0];
    self.valueId = device.identifier;
    self.valueIndex = 0;
    
    for (int i = 0; i < mdm.devices.count; i++) {
        MobileDeviceConfiguration * temp = [mdm.devices objectAtIndex:i];
        if ([temp.identifier isEqualToString:identity]) {
            device = temp;
            _selected = device;
            self.valueId = temp.identifier;
            self.valueIndex = i;
            break;
        }
    }
    
}

-(NSString *) stringForIndex:(int) index {
    MobileDeviceConfiguration * d = [mdm.devices objectAtIndex:index];
    return d.name;
}

-(void) selectedIndex:(int) index {
    self.valueIndex = index;
    MobileDeviceConfiguration * d = [mdm.devices objectAtIndex:index];
    device = d;
    _selected = device;
    self.valueId = d.identifier;
}

-(NSString *) valueForIndex:(int) index {
    MobileDeviceConfiguration * d = [mdm.devices objectAtIndex:index];
    return d.identifier;
}

-(void) updateProfileInstance:(ProfileInstance *) instance {
    
    [device ready];
    
    instance.physicalWidthPX = device.widthPx;
    instance.physicalHeightPX = device.heightPx;
    instance.forcedScale = device.forcedScale;
    
    if (!device.custom) {
        instance.physicalWidthIN = device.widthIN;
        instance.physicalWidthMM = device.widthMM;
        
        instance.physicalHeightIN = device.heightIN;
        instance.physicalHeightMM = device.heightMM;
        
        instance.physicalDPI = device.physicalDpi;
    }
}

-(MobileDeviceConfiguration *) getDevice {
    return device;
}

@end
