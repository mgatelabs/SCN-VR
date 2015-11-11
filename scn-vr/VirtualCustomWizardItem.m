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

#import "VirtualCustomWizardItem.h"
#import "Constants.h"
#import "SCNVRResourceBundler.h"

@implementation VirtualCustomWizardItem

- (instancetype)initWithVirtual:(VirtualDeviceWizardItem *) virtualWizard physical:(PhysicalDeviceWizardItem *) physicalWizard mode:(int) mode
{
    self = [super initWith: (mode == 0 ?  NSLocalizedStringFromTableInBundle(@"WIZARD_ITEM_TITLE_WINDOW_W", @"SCN-VRProfile", [SCNVRResourceBundler getSCNVRResourceBundle], @"Window Width (MM)") :  NSLocalizedStringFromTableInBundle(@"WIZARD_ITEM_TITLE_WINDOW_H", @"SCN-VRProfile", [SCNVRResourceBundler getSCNVRResourceBundle], @"Window Height (MM)"))  info:(mode == 0 ?  NSLocalizedStringFromTableInBundle(@"WIZARD_ITEM_INFO_WINDOW_W", @"SCN-VRProfile", [SCNVRResourceBundler getSCNVRResourceBundle], @"Window width in MM") :  NSLocalizedStringFromTableInBundle(@"WIZARD_ITEM_INFO_WINDOW_H", @"SCN-VRProfile", [SCNVRResourceBundler getSCNVRResourceBundle], @"Window height in MM")) itemId:(mode == 0 ? WIZARD_ITEM_VIRTUAL_DEVICE_WIDTH : WIZARD_ITEM_VIRTUAL_DEVICE_HEIGHT) type:WizardItemDataTypeSlideFloat];
    if (self) {
        _physicalWizard = physicalWizard;
        _virtualWizard = virtualWizard;
        _mode = mode;
        
        self.slideValue = [NSNumber numberWithFloat:80.0f];
        self.slideMin = [NSNumber numberWithFloat:10.0f];
        self.slideMax = [NSNumber numberWithFloat:120.0f];
        self.slideStep = [NSNumber numberWithFloat:0.5f];
        
        self.count = 0;
        self.valueId = @"";
        self.valueIndex = 0;
    }
    return self;
}

-(void) chainUpdated {
    if ([_virtualWizard ready]) {
        
        if (_virtualWizard.virtualDevice.type == VirtualDeviceConfigurationTypeLandscapeCustom || _virtualWizard.virtualDevice.type == VirtualDeviceConfigurationTypePortraitCustom) {
            //int maxIndex;
            
            float maxSize;
            
            if (_mode == 0) {
                maxSize = (_virtualWizard.virtualDevice.type == VirtualDeviceConfigurationTypeLandscapeCustom ? _physicalWizard.selected.widthMM : _physicalWizard.selected.heightMM);
            } else /* if (_mode == 1)*/ {
                maxSize = (_virtualWizard.virtualDevice.type == VirtualDeviceConfigurationTypeLandscapeCustom ? _physicalWizard.selected.heightMM : _physicalWizard.selected.widthMM);
            }
            
            self.count = 2;
            
            self.slideMax = [NSNumber numberWithFloat:maxSize];
            
            if (self.slideValue.floatValue > self.slideMax.floatValue) {
                self.slideValue = self.slideMax;
            }

        } else {
            self.count = 1;
            self.valueIndex = 0;
            //self.valueId = [self stringForIndex:0];
        }
    } else {
        self.count = 1;
        self.valueIndex = 0;
        //self.valueId = [self stringForIndex:0];
    }
}

-(BOOL) available {
    return _virtualWizard.virtualDevice.type == VirtualDeviceConfigurationTypePortraitCustom || _virtualWizard.virtualDevice.type == VirtualDeviceConfigurationTypeLandscapeCustom;
}

-(BOOL) ready {
    return self.count > 1;
}

-(NSString *) stringForIndex:(int) index {
    float mm = (index / 4.0f) + 1;
    return [NSString stringWithFormat:@"%2.2f MM, %2.2f IN", mm, mm / IN_2_MM];
}

-(NSString *) stringForSlider {
    return [NSString stringWithFormat:@"%2.2f MM", [self.slideValue floatValue]];
}

-(void) updateProfileInstance:(ProfileInstance *) instance {
    
    if (_mode == 0) {
        instance.virtualWidthMM = [self.slideValue floatValue];
    } else {
        instance.virtualHeightMM = [self.slideValue floatValue];
    
        // We only do this logic once, so do it here
    
        switch (_virtualWizard.virtualDevice.type) {
            case VirtualDeviceConfigurationTypeLandscapeCustom: {
                
                instance.landscapeView = YES;
                
                // Need to go from MM to MM
                
                float targetWidthMM = instance.virtualWidthMM;
                float targetHeightMM = instance.virtualHeightMM;
                
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
            case VirtualDeviceConfigurationTypePortraitCustom: {
                
                instance.landscapeView = NO;
                
                float targetWidthMM = instance.virtualWidthMM;
                float targetHeightMM = instance.virtualHeightMM;
                
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
}

-(WizardItemNotReadyAction) notReadyAction {
    return WizardItemNotReadyActionContinue;
}

@end
