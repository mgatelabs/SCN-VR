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

#import "IpdWizardItem.h"
#import "SCNVRResourceBundler.h"

@implementation IpdWizardItem {
    HmdWizardItem * hmds;
    NSString * selectedHmdValueId;
}

- (instancetype)initWith:(HmdWizardItem *) hmdWizardItem
{
    //
    
    self = [super initWith:NSLocalizedStringFromTableInBundle(@"WIZARD_ITEM_TITLE_IPD", @"SCN-VRProfile", [SCNVRResourceBundler getSCNVRResourceBundle], @"IPD") info:NSLocalizedStringFromTableInBundle(@"WIZARD_ITEM_INFO_IPD", @"SCN-VRProfile", [SCNVRResourceBundler getSCNVRResourceBundle], @"IPD refers to the distance between your eyes.  Center will keep each eye centered.  Default will move the eyes to match the default setting and parts of the eye may go off screen.  Custom allows you to specify your own IPD value.") itemId:WIZARD_ITEM_IPD type:WizardItemDataTypeString];
    if (self) {
        hmds = hmdWizardItem;
        selectedHmdValueId = hmds.valueId;
        if (hmds.selected.deviceUsed == NO) {
            self.count = 1;
        } else {
            if (hmds.selected.extraIpdAvailable) {
                self.count = 5;
            } else {
                self.count = 3;
            }
        }
        self.valueIndex = 0;
        self.valueId = [self valueForIndex:0];
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
                self.valueId = [self valueForIndex:0];
            } else {
                if (hmds.selected.extraIpdAvailable) {
                    self.count = 5;
                } else {
                    self.count = 3;
                }
            }
            
            if (self.valueIndex >= self.count) {
                self.valueIndex = 0;
                self.valueId = [self valueForIndex:0];
            }
            
        }
    } else {
        self.count = 1;
        self.valueIndex = 0;
        self.valueId = [self valueForIndex:0];
    }
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
            return NSLocalizedStringFromTableInBundle(@"VALUE_CENTER_WARN", @"SCN-VRProfile", [SCNVRResourceBundler getSCNVRResourceBundle], @"Center (Eye Strain)");
        case 1:
            return [NSString stringWithFormat: NSLocalizedStringFromTableInBundle(@"VALUE_DEFAULT_2.1f", @"SCN-VRProfile", [SCNVRResourceBundler getSCNVRResourceBundle], @"Default (%2.1f)"), hmds.selected.ipd];
        case 2:
            return NSLocalizedStringFromTableInBundle(@"VALUE_CUSTOM", @"SCN-VRProfile", [SCNVRResourceBundler getSCNVRResourceBundle], nil);
        case 3:
            return [NSString stringWithFormat: @"Adult (%2.1f MM)", hmds.selected.ipdAdult];
        case 4:
            return [NSString stringWithFormat: @"Child (%2.1f MM)", hmds.selected.ipdChild];
        
        default:
            return @"Unknown";
    }
}

-(NSString *) valueForIndex:(int) index {
    switch (index) {
        case 0:
            return @"Center";
        case 1:
            return @"Default";
        case 2:
            return @"Custom";
        case 3:
            return @"Adult";
        case 4:
            return @"Child";
        default:
            return @"Unknown";
    }
}

-(void) loadForIdentity:(NSString *) identity {
    
    if (self.count == 1) {
        [self selectedIndex: 0];
    } else {
        self.valueIndex = [self indexForString:identity];
        self.valueId = identity;
    }
}

-(void) selectedIndex:(int) index {
    self.valueIndex = index;
    self.valueId = [self valueForIndex:index];
}

-(int) indexForString:(NSString *) source {
    if ([source isEqualToString:@"Default"]) {
        return 1;
    } else if ([source isEqualToString:@"Custom"]) {
        return 2;
    } else if ([source isEqualToString:@"Adult"]) {
        return 3;
    } else if ([source isEqualToString:@"Child"]) {
        return 4;
    } else {
        return 0;
    }
}

-(void) updateProfileInstance:(ProfileInstance *) instance {
    switch (self.valueIndex) {
        case 1:
            instance.centerIPD = NO;
            break;
        case 0:
            instance.centerIPD = YES;
            break;
        case 2:
            // Will defer
            instance.centerIPD = NO;
            break;
        case 3:
            instance.centerIPD = NO;
            instance.cameraIPD = hmds.selected.ipdAdult;
            instance.viewerIPD = instance.cameraIPD;
            break;
        case 4:
            instance.centerIPD = NO;
            instance.cameraIPD = hmds.selected.ipdChild;
            instance.viewerIPD = instance.cameraIPD;
            break;
        
        default:
            break;
    }
}

@end
