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

#import "ColorValueWizardItem.h"
#import "SCNVRResourceBundler.h"

@implementation ColorValueWizardItem{
    ColorWizardItem * color;
}

- (instancetype)initWith:(ColorWizardItem *) colorWizardItem
{
    self = [super initWith: NSLocalizedStringFromTableInBundle(@"WIZARD_ITEM_TITLE_COLOR_DETAIL", @"SCN-VRProfile", [SCNVRResourceBundler getSCNVRResourceBundle], @"Custom Color Value") info: NSLocalizedStringFromTableInBundle(@"WIZARD_ITEM_INFO_COLOR_DETAIL", @"SCN-VRProfile", [SCNVRResourceBundler getSCNVRResourceBundle], @"Complex math nonsense.  Play with it until it looks right") itemId: WIZARD_ITEM_COLOR_VALUE type:WizardItemDataTypeSlideFloat];
    if (self) {
        color = colorWizardItem;
        self.count = 81;
        
        self.slideValue = [NSNumber numberWithFloat:0.0f];
        self.slideMin = [NSNumber numberWithFloat:-3.0f];
        self.slideMax = [NSNumber numberWithFloat:3.0f];
        self.slideStep = [NSNumber numberWithFloat:0.01f];
    }
    return self;
}

-(void) reset {
    self.slideValue = [NSNumber numberWithFloat:0.0f];
}

-(BOOL) available {
    return color.valueIndex == 2;
}

-(BOOL) ready {
    return color.valueIndex == 2;
}

-(void) loadForInt:(int) value {
    self.valueIndex = value;
    self.valueId = [self stringForIndex:value];
}

-(NSString *) stringForSlider {
    return [NSString stringWithFormat:@"%1.2f", [self.slideValue floatValue]];
}

-(WizardItemNotReadyAction) notReadyAction {
    return WizardItemNotReadyActionContinue;
}

-(void) updateProfileInstance:(ProfileInstance *) instance {
    instance.colorCorrectionValue = [self.slideValue floatValue];
}

@end
