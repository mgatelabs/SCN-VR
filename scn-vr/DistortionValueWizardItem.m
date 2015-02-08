//
//  DistortionValueWizardItem.m
//  scn-vr
//
//  Created by Michael Fuller on 1/16/15.
//  Copyright (c) 2015 M-Gate Labs. All rights reserved.
//

#import "DistortionValueWizardItem.h"

@implementation DistortionValueWizardItem {
    DistortionWizardItem * distortion;
    bool isSecond;
}

- (instancetype)initWith:(DistortionWizardItem *) distortionWizardItem second:(BOOL) second
{
    self = [super initWith: second ? @"... Value 2" : @"... Value 1" info:@"Complex math nonsense, just play with each option until you get something positive." itemId: second ? WIZARD_ITEM_DISTORTION_VALUE2 : WIZARD_ITEM_DISTORTION_VALUE1 type:WizardItemDataTypeInt];
    if (self) {
        isSecond = second;
        distortion = distortionWizardItem;
        self.count = 81;
        self.valueIndex = 20 * 2;
        self.valueId = @"0.00";
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
        instance.distortionCorrectionValue2 = (self.valueIndex - 40) / 20.0f;
    } else {
        instance.distortionCorrectionValue1 = (self.valueIndex - 40) / 20.0f;
    }
    
}

@end
