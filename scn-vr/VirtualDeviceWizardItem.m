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
}

- (instancetype)initWith:(PhysicalDeviceWizardItem *) deviceWizardItem
{
    self = [super initWith:@"Virtual Device" info:@"With a virtual device you can change how content is displayed on the screen.  On tablet devices you can switch between landscape and portrait output with various options." itemId:WIZARD_ITEM_VIRTUAL_DEVICE type:WizardItemDataTypeString];
    if (self) {
        devices = deviceWizardItem;
        _items = [[NSMutableArray alloc] initWithCapacity:10];
        _sourceItems = [VirtualDeviceManager getVirtualDevices];
        
        selectedMobile = devices.selected;
        [self filterDevices];
        _virtualDevice = [_items objectAtIndex:0];
    }
    return self;
}

-(void) reset {
    _virtualDevice = [_items objectAtIndex:0];
    self.valueId = _virtualDevice.key;
    self.valueIndex = 0;
}

-(WizardItemChangeAction) changeAction {
    return WizardItemChangeActionNone;
}

-(BOOL)available {
    return [devices ready] && self.count > 0;
}

-(BOOL) ready {
    return [devices ready] && self.count > 0 && _virtualDevice != nil;
}

-(void) loadForIdentity:(NSString *) identity {
    _virtualDevice = [_items objectAtIndex:0];
    self.valueId = _virtualDevice.key;
    self.valueIndex = 0;
    
    for (int i = 0; i < _items.count; i++) {
        VirtualDeviceConfiguration * temp = [_items objectAtIndex:i];
        if ([temp.key isEqualToString:identity]) {
            _virtualDevice = temp;
            self.valueId = temp.key;
            self.valueIndex = i;
            break;
        }
    }
    
}

-(void) chainUpdated {
    if ([devices ready]) {
        if (devices.selected != selectedMobile) {
            _virtualDevice = nil;
            selectedMobile = devices.selected;
            if (selectedMobile != nil) {
                [self filterDevices];
            }
        }
    } else {
        _virtualDevice = nil;
    }
}

-(void) filterDevices {
    
    [_items removeAllObjects];
    
    //_items = [VirtualDeviceManager getVirtualDevices];
    if (selectedMobile != nil) {
        
        for (int i = 0; i < _sourceItems.count; i++) {
            VirtualDeviceConfiguration * vdc = [_sourceItems objectAtIndex:i];
            BOOL skip = NO;
            switch (vdc.type) {
                case VirtualDeviceConfigurationTypeLandscape:
                case VirtualDeviceConfigurationTypeLandscape169:
                case VirtualDeviceConfigurationTypePortrait:
                case VirtualDeviceConfigurationTypePortrait169:
                    break;
                case VirtualDeviceConfigurationTypeLandscapeVirtual: {
                    float deviceHeight = selectedMobile.heightMM * 1.1f;
                    float deviceWidth = selectedMobile.widthMM * 1.1f;
                    
                    if ([vdc.virtualDevice.identifier isEqualToString:selectedMobile.identifier]) {
                        skip = YES;
                    }
                    
                    if (vdc.virtualDevice.widthMM > deviceWidth || vdc.virtualDevice.heightMM > deviceHeight) {
                        skip = YES;
                    } else {
                        
                    }
                    
                } break;
                case VirtualDeviceConfigurationTypePortraitVirtual: {
                    float deviceWidth = selectedMobile.heightMM * 1.1f;
                    float deviceHeight = selectedMobile.widthMM * 1.1f;
                    
                    if ([vdc.virtualDevice.identifier isEqualToString:selectedMobile.identifier]) {
                        skip = YES;
                    }
                    
                    if (vdc.virtualDevice.widthMM > deviceWidth || vdc.virtualDevice.heightMM > deviceHeight) {
                        skip = YES;
                    }
                } break;
                default: {
                    
                } break;
            }
            
            if (!skip) {
                [_items addObject:vdc];
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
    _virtualDevice = d;
    self.valueId = d.key;
}

-(void) updateProfileInstance:(ProfileInstance *) instance {
    
    switch (_virtualDevice.type) {
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
            
            float targetWidthMM = _virtualDevice.virtualDevice.widthMM;
            float targetHeightMM = _virtualDevice.virtualDevice.heightMM;
            
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
            
            float targetWidthMM = _virtualDevice.virtualDevice.widthMM;
            float targetHeightMM = _virtualDevice.virtualDevice.heightMM;
            
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
        default: {
            
        } break;
    }
    
}

@end
