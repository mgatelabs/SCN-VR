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

@implementation ColorValueWizardItem{
    ColorWizardItem * color;
}

- (instancetype)initWith:(ColorWizardItem *) colorWizardItem
{
    self = [super initWith:@"... Value" info:@"Complex math nonsense.  Play with it until it looks right," itemId: WIZARD_ITEM_COLOR_VALUE type:WizardItemDataTypeInt];
    if (self) {
        color = colorWizardItem;
        self.count = 81;
        self.valueIndex = 20 * 2;
        self.valueId = @"0.00";
    }
    return self;
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

-(NSString *) stringForIndex:(int) index {
    return [NSString stringWithFormat:@"%1.2f", (index - 40) / 20.0f];
}

-(void) selectedIndex:(int) index {
    self.valueIndex = index;
    self.valueId = [self stringForIndex:index];
}

-(WizardItemNotReadyAction) notReadyAction {
    return WizardItemNotReadyActionContinue;
}

-(void) updateProfileInstance:(ProfileInstance *) instance {
    instance.colorCorrectionValue = (self.valueIndex - 40) / 20.0f;
}

@end
