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

@implementation IpdWizardItem {
    HmdWizardItem * hmds;
    NSString * selectedHmdValueId;
}

- (instancetype)initWith:(HmdWizardItem *) hmdWizardItem
{
    self = [super initWith:@"IPD" info:@"IPD refers to the distance between your eyes.  Center will keep each eye centered.  Default will move the eyes to match the default setting and parts of the eye may go off screen.  Custom allows you to specify your own IPD value." itemId:WIZARD_ITEM_IPD type:WizardItemDataTypeString];
    if (self) {
        hmds = hmdWizardItem;
        selectedHmdValueId = hmds.valueId;
        if ([selectedHmdValueId isEqualToString:@"mono"] || [selectedHmdValueId isEqualToString:@"none"]) {
            self.count = 1;
        } else {
            if (hmds.selected.extraIpdAvailable) {
                self.count = 5;
            } else {
                self.count = 3;
            }
        }
        self.valueIndex = 0;
        self.valueId = [self stringForIndex:0];
    }
    return self;
}

-(void) chainUpdated {
    if ([hmds ready]) {
        if (![hmds.valueId isEqualToString:selectedHmdValueId]) {
            selectedHmdValueId = hmds.valueId;
            
            if ([selectedHmdValueId isEqualToString:@"mono"] || [selectedHmdValueId isEqualToString:@"none"]) {
                self.count = 1;
                self.valueIndex = 0;
                self.valueId = [self stringForIndex:0];
            } else {
                if (hmds.selected.extraIpdAvailable) {
                    self.count = 5;
                } else {
                    self.count = 3;
                }
            }
            
            if (self.valueIndex >= self.count) {
                self.valueIndex = 0;
                self.valueId = [self stringForIndex:0];
            }
            
        }
    } else {
        self.count = 1;
        self.valueIndex = 0;
        self.valueId = [self stringForIndex:0];
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
            return @"Center (Eye Strain)";
        case 1:
            return @"Default (Good Choice)";
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
        self.valueIndex = 0;
        self.valueId = [self stringForIndex:0];
    } else {
        for (int i = 0; i < self.count; i++) {
            NSString * temp = [self stringForIndex:i];
            if ([temp isEqualToString:identity]) {
                self.valueIndex = i;
                self.valueId = temp;
                return;
            }
        }
        
        self.valueIndex = 0;
        self.valueId = [self stringForIndex:0];
    }
}

-(void) selectedIndex:(int) index {
    self.valueIndex = index;
    switch (index) {
        case 0:
            self.valueId =  @"Center";
            break;
        case 1:
            self.valueId = @"Default";
            break;
        case 2:
            self.valueId =  @"Custom";
            break;
        case 3:
            self.valueId = @"Adult";
            break;
        case 4:
            self.valueId =  @"Child";
            break;
        default:
            self.valueId =  @"Unknown";
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
