//
//  ColorValueWizardItem.m
//  scn-vr
//
//  Created by Michael Fuller on 1/16/15.
//  Copyright (c) 2015 M-Gate Labs. All rights reserved.
//

#import "ColorValueWizardItem.h"

@implementation ColorValueWizardItem{
    ColorWizardItem * color;
}

- (instancetype)initWith:(ColorWizardItem *) colorWizardItem
{
    self = [super initWith:@"Color Value" info:@"Complex math nonsense" itemId: WIZARD_ITEM_COLOR_VALUE type:WizardItemDataTypeInt];
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
