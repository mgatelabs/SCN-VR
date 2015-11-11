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

#import "IpdValueWizarditem.h"
#import "SCNVRResourceBundler.h"

@implementation IpdValueWizarditem {
    IpdWizardItem * ipds;
    bool second;
}

- (instancetype)initWith:(IpdWizardItem *) ipdWizardItem second:(BOOL) secondItem
{
    self = [super initWith:secondItem ? NSLocalizedStringFromTableInBundle(@"WIZARD_ITEM_TITLE_CAMERA-IPD", @"SCN-VRProfile", [SCNVRResourceBundler getSCNVRResourceBundle], @"Camera IPD") : NSLocalizedStringFromTableInBundle(@"WIZARD_ITEM_TITLE_YOUR-IPD", @"SCN-VRProfile", [SCNVRResourceBundler getSCNVRResourceBundle], @"Your IPD value") info:NSLocalizedStringFromTableInBundle(@"WIZARD_ITEM_INFO_YOUR-IPD", @"SCN-VRProfile", [SCNVRResourceBundler getSCNVRResourceBundle], @"The distance in MM between your or the virtual eyes") itemId: secondItem ? WIZARD_ITEM_IPD_VALUE2 : WIZARD_ITEM_IPD_VALUE1 type:WizardItemDataTypeSlideFloat];
    if (self) {
        second = secondItem;
        ipds = ipdWizardItem;
        
        self.slideValue = [NSNumber numberWithFloat:62.0f];
        self.slideMin = [NSNumber numberWithFloat:40.0f];
        self.slideMax = [NSNumber numberWithFloat:80.0f];
        self.slideStep = [NSNumber numberWithFloat:0.5f];
    }
    return self;
}

-(BOOL) available {
    return ipds.valueIndex == 2;
}

-(BOOL) ready {
    return ipds.valueIndex == 2;
}

-(void) reset {
    self.slideValue = [NSNumber numberWithFloat:62.0f];
}

-(void) loadForInt:(int) value {
    self.valueIndex = value;
    self.valueId = [self stringForIndex:value];
}

-(NSString *) stringForIndex:(int) index {
    return [NSString stringWithFormat:@"%1.1f MM", index / 2.0f];
}

-(NSString *) stringForSlider {
    return [NSString stringWithFormat:@"%1.1f MM", [self.slideValue floatValue]];
}

-(WizardItemNotReadyAction) notReadyAction {
    return WizardItemNotReadyActionContinue;
}

-(void) updateProfileInstance:(ProfileInstance *) instance {
    if (second) {
        instance.cameraIPD = [self.slideValue floatValue];
    } else {
        instance.viewerIPD = [self.slideValue floatValue];
    }
}

@end
