//
//  DeviceWizardItem.m
//  scn-vr
//
//  Created by Michael Fuller on 1/15/15.
//  Copyright (c) 2015 M-Gate Labs. All rights reserved.
//

#import "DeviceWizardItem.h"
#import "MobileDeviceManager.h"

@implementation DeviceWizardItem {
    MobileDeviceManager * mdm;
    MobileDeviceConfiguration * device;
}

- (instancetype)init
{
    self = [super initWith:@"Device" info:@"Select the device you are currnely on" itemId:WIZARD_ITEM_DEVICE];
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

@end
