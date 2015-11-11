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

#import "PhysicalDpiWizardItem.h"
#import "Constants.h"
#import "SCNVRResourceBundler.h"

@implementation PhysicalDpiWizardItem

- (instancetype)initWith:(PhysicalDeviceWizardItem*) physicalWizard
{
    self = [super initWith: NSLocalizedStringFromTableInBundle(@"WIZARD_ITEM_TITLE_DPI", @"SCN-VRProfile", [SCNVRResourceBundler getSCNVRResourceBundle], @"Physical DPI") info: NSLocalizedStringFromTableInBundle(@"WIZARD_ITEM_INFO_DPI", @"SCN-VRProfile", [SCNVRResourceBundler getSCNVRResourceBundle], @"You have a device which is completely unknown to the SCN-VR.  Please select your device's physical DPI value and we can attempt to guess everything else.") itemId:WIZARD_ITEM_DEVICE_DPI type:WizardItemDataTypeInt];
    if (self) {
        _physicalWizard = physicalWizard;
        self.count = 0;
        self.valueId = @"";
        self.valueIndex = 0;
    }
    return self;
}

-(void) chainUpdated {
    if (_physicalWizard.selected.custom == YES) {
        self.count = 1440 - 162;
    } else {
        self.count = 0;
    }
}

-(void) selectedIndex:(int) index {
    self.valueIndex = index;
    self.valueId = [self stringForIndex:index];
}

-(void) loadForInt:(int) value {
    self.valueIndex = value;
    self.valueId = [self stringForIndex:value];
}

-(BOOL) available {
    return _physicalWizard.selected.custom == YES;
}

-(BOOL) ready {
    return self.count > 1;
}

-(NSString *) stringForIndex:(int) index {
    return [NSString stringWithFormat:@"%d DPI", index + 132];
}

-(void) updateProfileInstance:(ProfileInstance *) instance {
    
    instance.physicalDPI = self.valueIndex + 132;

    instance.physicalWidthIN = instance.physicalWidthPX / (float)(instance.physicalDPI);
    instance.physicalWidthMM = instance.physicalWidthIN * IN_2_MM;
    
    instance.physicalHeightIN = instance.physicalHeightPX / (float)(instance.physicalDPI);
    instance.physicalHeightMM = instance.physicalHeightIN * IN_2_MM;
}

-(WizardItemNotReadyAction) notReadyAction {
    return WizardItemNotReadyActionContinue;
}

@end
