//
//  DeviceWizardItem.m
//  scn-vr
//
//  Created by Michael Fuller on 1/15/15.
//  Copyright (c) 2015 M-Gate Labs. All rights reserved.
//

#import "PhysicalDeviceWizardItem.h"
#import "MobileDeviceManager.h"

@implementation PhysicalDeviceWizardItem {
    MobileDeviceManager * mdm;
    MobileDeviceConfiguration * device;
}

- (instancetype)init
{
    self = [super initWith:@"Device" info:@"Please select the device you are currently using. Selecting a incorrect device will distort your perspective." itemId:WIZARD_ITEM_DEVICE type:WizardItemDataTypeString];
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

-(void) updateProfileInstance:(ProfileInstance *) instance {
    
    [device ready];
    
    instance.physicalWidthPX = device.widthPx;
    instance.physicalHeightPX = device.heightPx;
    
    if (!device.custom) {
        instance.physicalWidthIN = device.widthIN;
        instance.physicalWidthMM = device.widthMM;
        
        instance.physicalHeightIN = device.heightIN;
        instance.physicalHeightMM = device.heightMM;
        
        instance.physicalDPI = device.physicalDpi;
    }
}

@end
