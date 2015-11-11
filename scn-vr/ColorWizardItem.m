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

#import "ColorWizardItem.h"
#import "SCNVRResourceBundler.h"

@implementation ColorWizardItem{
    HmdWizardItem * hmds;
    NSString * selectedHmdValueId;
}

- (instancetype)initWith:(HmdWizardItem *) hmdWizardItem
{
    self = [super initWith:NSLocalizedStringFromTableInBundle(@"WIZARD_ITEM_TITLE_COLOR", @"SCN-VRProfile", [SCNVRResourceBundler getSCNVRResourceBundle], @"Color") info:NSLocalizedStringFromTableInBundle(@"WIZARD_ITEM_INFO_COLOR", @"SCN-VRProfile", [SCNVRResourceBundler getSCNVRResourceBundle], @"HMD lenses often cause color distortion, this option will attempt to fix that.") itemId:WIZARD_ITEM_COLOR type:WizardItemDataTypeString];
    if (self) {
        hmds = hmdWizardItem;
        selectedHmdValueId = hmds.valueId;
        if (hmds.selected.deviceUsed == NO) {
            self.count = 1;
        } else {
            self.count = 3;
        }
        self.valueIndex = 0;
        self.valueId = [self valueForIndex: 0];
    }
    return self;
}

-(void) chainUpdated {
    if ([hmds ready]) {
        if (![hmds.valueId isEqualToString:selectedHmdValueId]) {
            selectedHmdValueId = hmds.valueId;
            
            if (hmds.selected.deviceUsed == NO) {
                self.count = 1;
                self.valueIndex = 0;
                self.valueId = [self valueForIndex: 0];
            } else {
                self.count = 3;
            }
        }
    } else {
        self.valueIndex = 0;
        self.valueId = [self valueForIndex: 0];
    }
}

-(BOOL) available {
    return self.count > 0;
}

-(BOOL) ready {
    return self.count > 0;
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

-(NSString *) stringForIndex:(int) index {
    switch (index) {
        case 0:
            return [NSString stringWithFormat: NSLocalizedStringFromTableInBundle(@"VALUE_DEFAULT_2.1f", @"SCN-VRProfile", [SCNVRResourceBundler getSCNVRResourceBundle], @"Default (%2.1f)"), hmds.selected.correctionCoefficient ];
        case 1:
            return NSLocalizedStringFromTableInBundle(@"VALUE_OFF", @"SCN-VRProfile", [SCNVRResourceBundler getSCNVRResourceBundle], nil);
        case 2:
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
            return @"Off";
        case 2:
            return @"Custom";
        default:
            return @"Unknown";
    }
}

-(void) updateProfileInstance:(ProfileInstance *) instance {
    switch (self.valueIndex) {
        case 0:
            
            break;
        case 1:
            instance.colorCorrection = NO;
            break;
        case 2:
            // Defer
            break;
        default:
            break;
    }
}

@end
