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

#import "FovItemWizardItem.h"
#import "SCNVRResourceBundler.h"

@implementation FovItemWizardItem{
    FovWizardItem * fovs;
    bool second;
}

- (instancetype)initWith:(FovWizardItem *) fovWizardItem second:(BOOL) secondItem
{
    self = [super initWith:secondItem ? NSLocalizedStringFromTableInBundle(@"WIZARD_ITEM_TITLE_FOV_H", @"SCN-VRProfile", [SCNVRResourceBundler getSCNVRResourceBundle], @"Horizontal FOV") : NSLocalizedStringFromTableInBundle(@"WIZARD_ITEM_TITLE_FOV_V", @"SCN-VRProfile", [SCNVRResourceBundler getSCNVRResourceBundle], @"Vertical FOV")  info: NSLocalizedStringFromTableInBundle(@"WIZARD_ITEM_INFO_FOV_DETAIL", @"SCN-VRProfile", [SCNVRResourceBundler getSCNVRResourceBundle], @"Custom field of view setting.") itemId: secondItem ? WIZARD_ITEM_FOV_V : WIZARD_ITEM_FOV_H type:WizardItemDataTypeSlideFloat];
    if (self) {
        second = secondItem;
        fovs = fovWizardItem;
        
        self.slideValue = [NSNumber numberWithFloat:80.0f];
        self.slideMin = [NSNumber numberWithFloat:45.0f];
        self.slideMax = [NSNumber numberWithFloat:120.0f];
        self.slideStep = [NSNumber numberWithFloat:2.5f];
        
        //self.count = ((120 - 45) * 4) + 1;
        //self.valueIndex = ((80 - 45) * 4);
        //self.valueId = @"80";
    }
    return self;
}

-(BOOL) available {
    return fovs.valueIndex == 1;
}

-(BOOL) ready {
    return fovs.valueIndex == 1;
}

-(void) reset {
    self.slideValue = [NSNumber numberWithFloat:80.0f];
}

-(void) loadForInt:(int) value {
    self.valueIndex = value;
    self.valueId = [self stringForIndex:value];
}

-(NSString *) stringForIndex:(int) index {
    return [NSString stringWithFormat:@"%1.2f Degrees", (index / 4.0f) + 45];
}

-(NSString *) stringForSlider {
    return [NSString stringWithFormat:@"%1.2f°", [self.slideValue floatValue]];
}

-(void) selectedIndex:(int) index {
    self.valueIndex = index;
    self.valueId = [self stringForIndex:index];
}

-(WizardItemNotReadyAction) notReadyAction {
    return WizardItemNotReadyActionContinue;
}

-(void) updateProfileInstance:(ProfileInstance *) instance {
    if (second) {
        instance.vFov = [self.slideValue floatValue];
    } else {
        instance.hFov = [self.slideValue floatValue];
    }
}

@end
