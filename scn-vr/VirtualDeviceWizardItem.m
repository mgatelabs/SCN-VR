//
//  VirtualDeviceWizardItem.m
//  scn-vr
//
//  Created by Michael Fuller on 1/15/15.
//  Copyright (c) 2015 M-Gate Labs. All rights reserved.
//

#import "VirtualDeviceWizardItem.h"
#import "VirtualDeviceManager.h"

@implementation VirtualDeviceWizardItem {
    DeviceWizardItem * devices;
    MobileDeviceConfiguration * selectedMobile;
    VirtualDeviceConfiguration * virtualDevice;
}

- (instancetype)initWith:(DeviceWizardItem *) deviceWizardItem
{
    self = [super initWith:@"Virtual Device" info:@"Select the screen layout" itemId:WIZARD_ITEM_VIRTUAL_DEVICE];
    if (self) {
        devices = deviceWizardItem;
        selectedMobile = devices.selected;
        [self filterDevices];
        virtualDevice = nil;
    }
    return self;
}

-(WizardItemChangeAction) changeAction {
    return WizardItemChangeActionNone;
}

-(BOOL)available {
    return [devices ready] && self.count > 0;
}

-(BOOL) ready {
    return [devices ready] && self.count > 0 && virtualDevice != nil;
}

-(void) chainUpdated {
    if ([devices ready]) {
        if (devices.selected != selectedMobile) {
            virtualDevice = nil;
            selectedMobile = devices.selected;
            if (selectedMobile != nil) {
                [self filterDevices];
            }
        }
    } else {
        virtualDevice = nil;
    }
}

-(void) filterDevices {
    _items = [VirtualDeviceManager getVirtualDevices];
    if (selectedMobile != nil) {
        
        for (int i = (int)_items.count - 1; i >= 0; i--) {
            VirtualDeviceConfiguration * vdc = [_items objectAtIndex:i];
            switch (vdc.type) {
                case VirtualDeviceConfigurationTypeLandscape:
                case VirtualDeviceConfigurationTypeLandscape169:
                case VirtualDeviceConfigurationTypePortrait:
                case VirtualDeviceConfigurationTypePortrait169:
                    break;
                case VirtualDeviceConfigurationTypeLandscapeVirtual: {
                    int deviceHeight = selectedMobile.heightMM;
                    int deviceWidth = selectedMobile.widthMM;
                    
                    if (vdc.virtualDevice.widthMM > deviceWidth || vdc.virtualDevice.heightMM > deviceHeight) {
                        [_items removeObjectAtIndex:i];
                    }
                    
                } break;
                case VirtualDeviceConfigurationTypePortraitVirtual: {
                    int deviceWidth = selectedMobile.heightMM;
                    int deviceHeight = selectedMobile.widthMM;
                    
                    if (vdc.virtualDevice.widthMM > deviceWidth || vdc.virtualDevice.heightMM > deviceHeight) {
                        [_items removeObjectAtIndex:i];
                    }
                } break;
            }
        }
        
    }
    self.count = (int)_items.count;
}

-(NSString *) stringForIndex:(int) index {
    VirtualDeviceConfiguration * d = [_items objectAtIndex:index];
    return d.name;
}

-(void) selectedIndex:(int) index {
    self.valueIndex = index;
    VirtualDeviceConfiguration * d = [_items objectAtIndex:index];
    virtualDevice = d;
    self.valueId = d.key;
}

@end
