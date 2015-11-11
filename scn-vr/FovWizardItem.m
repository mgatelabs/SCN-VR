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

#import "FovWizardItem.h"
#import "SCNVRResourceBundler.h"

@implementation FovWizardItem{
    HmdWizardItem * hmds;
}

- (instancetype)initWith:(HmdWizardItem *) hmdWizardItem
{
    self = [super initWith:NSLocalizedStringFromTableInBundle(@"WIZARD_ITEM_TITLE_FOV", @"SCN-VRProfile", [SCNVRResourceBundler getSCNVRResourceBundle], @"Field Of View (FOV)") info:NSLocalizedStringFromTableInBundle(@"WIZARD_ITEM_INFO_FOV", @"SCN-VRProfile", [SCNVRResourceBundler getSCNVRResourceBundle], @"The field of view is how wide and high you can see.") itemId:WIZARD_ITEM_FOV type:WizardItemDataTypeString];
    if (self) {
        hmds = hmdWizardItem;
        self.count = 2;
        self.valueIndex = 0;
        self.valueId = [self valueForIndex:self.valueIndex];
    }
    return self;
}

-(void) reset {
    self.valueIndex = 0;
    self.valueId = [self valueForIndex:self.valueIndex];
}

-(void) chainUpdated {
    
}

-(BOOL) available {
    return self.count > 0;
}

-(BOOL) ready {
    return self.count > 0;
}

-(NSString *) stringForIndex:(int) index {
    switch (index) {
        case 0:
            return  [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"VALUE_DEFAULT_2.1f", @"SCN-VRProfile", [SCNVRResourceBundler getSCNVRResourceBundle], @"Default (%2.1f)"), hmds.selected.fov];
        case 1:
            return NSLocalizedStringFromTableInBundle(@"VALUE_CUSTOM", @"SCN-VRProfile", [SCNVRResourceBundler getSCNVRResourceBundle], nil);
        default:
            return NSLocalizedStringFromTableInBundle(@"VALUE_UNKNOWN", @"SCN-VRProfile", [SCNVRResourceBundler getSCNVRResourceBundle], nil);
    }
}

-(NSString *) valueForIndex:(int) index {
    switch (index) {
        case 0:
            return @"Default";
        case 1:
            return @"Custom";
        default:
            return @"Unknown";
    }
}

-(void) loadForIdentity:(NSString *) identity {
    
    if (self.count == 1) {
        self.valueIndex = 0;
        self.valueId = [self valueForIndex:0];
    } else {
        for (int i = 0; i < self.count; i++) {
            NSString * temp = [self valueForIndex:i];
            if ([temp isEqualToString:identity]) {
                self.valueIndex = i;
                self.valueId = temp;
                return;
            }
        }
        self.valueIndex = 0;
        self.valueId = [self valueForIndex:0];
    }
}

-(void) selectedIndex:(int) index {
    self.valueIndex = index;
    switch (index) {
        case 0:
            self.valueId = @"Default";
            break;
        case 1:
            self.valueId =  @"Custom";
            break;
        default:
            self.valueId =  @"Unknown";
    }
}

-(void) updateProfileInstance:(ProfileInstance *) instance {
    switch (self.valueIndex) {
        case 0:
            instance.hFov = hmds.selected.hFov;
            instance.vFov = hmds.selected.vFov;
            break;
        case 1:
            // Will defer
            break;
        default:
            break;
    }
}

-(WizardItemNotReadyAction) notReadyAction {
    return WizardItemNotReadyActionContinue;
}

@end
