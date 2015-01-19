//
//  VirtualDeviceWizardItem.m
//  scn-vr
//
//  Created by Michael Fuller on 1/15/15.
//  Copyright (c) 2015 M-Gate Labs. All rights reserved.
//

#import "VirtualDeviceWizardItem.h"
#import "VirtualDeviceManager.h"
#import "Constants.h"

@implementation VirtualDeviceWizardItem {
    PhysicalDeviceWizardItem * devices;
    MobileDeviceConfiguration * selectedMobile;
    VirtualDeviceConfiguration * virtualDevice;
}

- (instancetype)initWith:(PhysicalDeviceWizardItem *) deviceWizardItem
{
    self = [super initWith:@"Virtual Device" info:@"Select the screen layout" itemId:WIZARD_ITEM_VIRTUAL_DEVICE];
    if (self) {
        devices = deviceWizardItem;
        selectedMobile = devices.selected;
        [self filterDevices];
        virtualDevice = [_items objectAtIndex:0];
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
        
        //BOOL isTablet = selectedMobile.tablet;
        
        if (true) {
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
        } else {
            for (int i = (int)_items.count - 1; i >= 0; i--) {
                VirtualDeviceConfiguration * vdc = [_items objectAtIndex:i];
                switch (vdc.type) {
                    case VirtualDeviceConfigurationTypeLandscape:
                        break;
                    default:
                        [_items removeObjectAtIndex:i];
                }
            }
        }
    }
    [self selectedIndex:0];
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

-(void) updateProfileInstance:(ProfileInstance *) instance {
    
    switch (virtualDevice.type) {
        case VirtualDeviceConfigurationTypeLandscape:
            instance.landscapeView = YES;
            
            instance.virtualWidthPX = instance.physicalWidthPX;
            instance.virtualWidthIN = instance.physicalWidthIN;
            instance.virtualWidthMM = instance.physicalWidthMM;
            
            instance.virtualHeightPX = instance.physicalHeightPX;
            instance.virtualHeightIN = instance.physicalHeightIN;
            instance.virtualHeightMM = instance.physicalHeightMM;
            
            instance.virtualOffsetLeft = 0;
            instance.virtualOffsetBottom = 0;
            
            break;
        case VirtualDeviceConfigurationTypeLandscape169:
            instance.landscapeView = YES;
            
            instance.virtualWidthPX = instance.physicalWidthPX;
            instance.virtualWidthIN = instance.physicalWidthIN;
            instance.virtualWidthMM = instance.physicalWidthMM;
            
            instance.virtualHeightPX = (instance.virtualWidthPX * 9) / 16;
            instance.virtualHeightIN = instance.virtualHeightPX / instance.physicalDPI;
            instance.virtualHeightMM = instance.virtualHeightIN * IN_2_MM;
            
            instance.virtualOffsetLeft = 0;
            instance.virtualOffsetBottom = (instance.physicalHeightPX - instance.virtualHeightPX) / 2;
            
            
            break;
        case VirtualDeviceConfigurationTypePortrait:
            instance.landscapeView = NO;
            
            instance.virtualHeightPX = instance.physicalWidthPX;
            instance.virtualHeightIN = instance.physicalWidthIN;
            instance.virtualHeightMM = instance.physicalWidthMM;
            
            instance.virtualWidthPX = instance.physicalHeightPX;
            instance.virtualWidthIN = instance.physicalHeightIN;
            instance.virtualWidthMM = instance.physicalHeightMM;
            
            instance.virtualOffsetLeft = 0;
            instance.virtualOffsetBottom = 0;
            
            break;
        case VirtualDeviceConfigurationTypePortrait169:
            instance.landscapeView = NO;
            
            instance.virtualWidthPX = instance.physicalHeightPX;
            instance.virtualWidthIN = instance.physicalHeightIN;
            instance.virtualWidthMM = instance.physicalHeightMM;
            
            instance.virtualHeightPX = (instance.virtualWidthPX * 9) / 16;
            instance.virtualHeightIN = instance.virtualHeightPX / instance.physicalDPI;
            instance.virtualHeightMM = instance.virtualHeightIN * IN_2_MM;
            
            instance.virtualOffsetLeft = 0;
            instance.virtualOffsetBottom = (instance.physicalWidthPX - instance.virtualHeightPX) / 2;
            
            break;
        case VirtualDeviceConfigurationTypeLandscapeVirtual: {
            instance.landscapeView = YES;
            
            // Need to go from MM to MM
            
            float targetWidthMM = virtualDevice.virtualDevice.widthMM;
            float targetHeightMM = virtualDevice.virtualDevice.heightMM;
            
            // GO from MM to Inches
            float targetWidthIN = targetWidthMM / IN_2_MM;
            float targetHeightIN = targetHeightMM / IN_2_MM;
            
            instance.virtualWidthPX = targetWidthIN * instance.physicalDPI;
            instance.virtualHeightPX = targetHeightIN * instance.physicalDPI;
            
            // May be overkill
            instance.virtualWidthIN = instance.virtualWidthPX / instance.physicalDPI;
            instance.virtualHeightIN = instance.virtualHeightPX / instance.physicalDPI;
            
            instance.virtualWidthMM = instance.virtualWidthIN * IN_2_MM;
            instance.virtualHeightMM = instance.virtualHeightIN * IN_2_MM;
            
            instance.virtualOffsetLeft = (instance.physicalWidthPX - instance.virtualWidthPX) / 2;
            instance.virtualOffsetBottom = (instance.physicalHeightPX - instance.virtualHeightPX) / 2;
            
        } break;
        case VirtualDeviceConfigurationTypePortraitVirtual: {
            instance.landscapeView = NO;
            
            float targetWidthMM = virtualDevice.virtualDevice.widthMM;
            float targetHeightMM = virtualDevice.virtualDevice.heightMM;
            
            // GO from MM to Inches
            float targetWidthIN = targetWidthMM / IN_2_MM;
            float targetHeightIN = targetHeightMM / IN_2_MM;
            
            instance.virtualWidthPX = targetWidthIN * instance.physicalDPI;
            instance.virtualHeightPX = targetHeightIN * instance.physicalDPI;
            
            instance.virtualWidthIN = instance.virtualWidthPX / instance.physicalDPI;
            instance.virtualHeightIN = instance.virtualHeightPX / instance.physicalDPI;
            
            instance.virtualWidthMM = instance.virtualWidthIN * IN_2_MM;
            instance.virtualHeightMM = instance.virtualHeightIN * IN_2_MM;
            
            instance.virtualOffsetLeft = (instance.physicalHeightPX / 2) - (instance.virtualWidthPX /2);
            instance.virtualOffsetBottom = (instance.physicalWidthPX / 2) - (instance.virtualHeightPX / 2);
            
        } break;
    }
    
}

@end
