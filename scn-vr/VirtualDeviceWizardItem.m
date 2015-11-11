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

#import "VirtualDeviceWizardItem.h"
#import "VirtualDeviceManager.h"
#import "Constants.h"
#import "SCNVRResourceBundler.h"

@implementation VirtualDeviceWizardItem {
    PhysicalDeviceWizardItem * devices;
    MobileDeviceConfiguration * selectedMobile;
}

- (instancetype)initWith:(PhysicalDeviceWizardItem *) deviceWizardItem
{
    self = [super initWith: NSLocalizedStringFromTableInBundle(@"WIZARD_ITEM_TITLE_WINDOW", @"SCN-VRProfile", [SCNVRResourceBundler getSCNVRResourceBundle], @"Window") info: NSLocalizedStringFromTableInBundle(@"WIZARD_ITEM_INFO_WINDOW", @"SCN-VRProfile", [SCNVRResourceBundler getSCNVRResourceBundle], @"With this setting you can change how content is displayed on your device.") itemId:WIZARD_ITEM_VIRTUAL_DEVICE type:WizardItemDataTypeString];
    if (self) {
        _tempProfileInstance = [[ProfileInstance alloc] init];
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
    [self updateTargetInfo];
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
    [self updateTargetInfo];
}

-(void) chainUpdated {
    if ([devices ready]) {
        if (devices.selected != selectedMobile) {
            _virtualDevice = nil;
            selectedMobile = devices.selected;
            if (selectedMobile != nil) {
                [self filterDevices];
            }
        } else {
            [self updateTargetInfo];
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
                case VirtualDeviceConfigurationTypeLandscapeSquared:
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
    [self updateTargetInfo];
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
    [self updateTargetInfo];
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
        case VirtualDeviceConfigurationTypeLandscapeSquared: {
        
            instance.landscapeView = YES;
            
            int halfWidth = instance.physicalWidthPX / 2;
            if (halfWidth > instance.physicalHeightPX) {
                // Need to shrink width
                instance.virtualWidthPX = halfWidth * 2;
                instance.virtualHeightPX = instance.physicalHeightPX;
            } else {
                // Need to shrink height
                instance.virtualWidthPX = instance.physicalWidthPX;
                instance.virtualHeightPX = instance.physicalWidthPX / 2;
            }
            
            instance.virtualHeightIN = instance.virtualHeightPX / instance.physicalDPI;
            instance.virtualWidthIN = instance.virtualWidthPX / instance.physicalDPI;
            
            instance.virtualHeightMM = instance.virtualHeightIN * IN_2_MM;
            instance.virtualWidthMM = instance.virtualWidthIN * IN_2_MM;
            
            instance.virtualOffsetLeft = (instance.physicalWidthPX - instance.virtualWidthPX) / 2;
            instance.virtualOffsetBottom = (instance.physicalHeightPX - instance.virtualHeightPX) / 2;
            
        } break;
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

-(void) updateTargetInfo {
    
    [selectedMobile ready];
    
    //NSLog(@"%@", selectedMobile.name);
    
    _tempProfileInstance.physicalWidthPX = selectedMobile.widthPx;
    _tempProfileInstance.physicalHeightPX = selectedMobile.heightPx;
    _tempProfileInstance.forcedScale = selectedMobile.forcedScale;
    
    if (!selectedMobile.custom) {
        _tempProfileInstance.physicalWidthIN = selectedMobile.widthIN;
        _tempProfileInstance.physicalWidthMM = selectedMobile.widthMM;
        
        _tempProfileInstance.physicalHeightIN = selectedMobile.heightIN;
        _tempProfileInstance.physicalHeightMM = selectedMobile.heightMM;
        
        _tempProfileInstance.physicalDPI = selectedMobile.physicalDpi;
    }
    
    [self updateProfileInstance:_tempProfileInstance];
}

-(float) getTargetVirtualWidthMM {
    return _tempProfileInstance.virtualWidthMM;
}

-(float) getTargetVirtualHeightMM {
    return _tempProfileInstance.virtualHeightMM;
}

-(float) getPhysicalWidthMM {
    return _tempProfileInstance.physicalWidthMM;
}

-(float) getPhysicalHeightMM {
    return _tempProfileInstance.physicalHeightMM;
}

@end
