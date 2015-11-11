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

#import "DistortionValueWizardItem.h"
#import "SCNVRResourceBundler.h"

@implementation DistortionValueWizardItem {
    DistortionWizardItem * distortion;
    bool isSecond;
}

- (instancetype)initWith:(DistortionWizardItem *) distortionWizardItem second:(BOOL) second
{
    self = [super initWith: second ?  NSLocalizedStringFromTableInBundle(@"WIZARD_ITEM_TITLE_DISTORTION_DETAIL_2", @"SCN-VRProfile", [SCNVRResourceBundler getSCNVRResourceBundle], @"... Value 2") : NSLocalizedStringFromTableInBundle(@"WIZARD_ITEM_TITLE_DISTORTION_DETAIL_1", @"SCN-VRProfile", [SCNVRResourceBundler getSCNVRResourceBundle], @"... Value 1") info: NSLocalizedStringFromTableInBundle(@"WIZARD_ITEM_TITLE_DISTORTION_DETAIL", @"SCN-VRProfile", [SCNVRResourceBundler getSCNVRResourceBundle], @"Complex math nonsense, just play with each option until you get something positive.") itemId: second ? WIZARD_ITEM_DISTORTION_VALUE2 : WIZARD_ITEM_DISTORTION_VALUE1 type:WizardItemDataTypeSlideFloat];
    if (self) {
        isSecond = second;
        distortion = distortionWizardItem;
        self.count = 81;
        self.valueIndex = 20 * 2;
        self.valueId = @"0.00";
        
        
        self.slideValue = [NSNumber numberWithFloat:0.0f];
        self.slideMin = [NSNumber numberWithFloat:-3.0f];
        self.slideMax = [NSNumber numberWithFloat:3.0f];
        self.slideStep = [NSNumber numberWithFloat:0.01f];
        
    }
    return self;
}

-(BOOL) available {
    return distortion.valueIndex == 2;
}

-(BOOL) ready {
    return distortion.valueIndex == 2;
}

-(NSString *) stringForIndex:(int) index {
    return [NSString stringWithFormat:@"%1.2f", (index - 40) / 20.0f];
}

-(NSString *) stringForSlider {
    return [NSString stringWithFormat:@"%1.2f", [self.slideValue floatValue]];
}

-(void) loadForInt:(int) value {
    self.valueIndex = value;
    self.valueId = [self stringForIndex:value];
}

-(void) selectedIndex:(int) index {
    self.valueIndex = index;
    self.valueId = [self stringForIndex:index];
}

-(WizardItemNotReadyAction) notReadyAction {
    return WizardItemNotReadyActionContinue;
}

-(void) updateProfileInstance:(ProfileInstance *) instance {
    if (isSecond) {
        instance.distortionCorrectionValue2 = [self.slideValue floatValue];
    } else {
        instance.distortionCorrectionValue1 = [self.slideValue floatValue];
    }
    
}

@end
