//
//  FovItemWizardItem.m
//  scn-vr
//
//  Created by Michael Fuller on 1/20/15.
//  Copyright (c) 2015 M-Gate Labs. All rights reserved.
//

#import "FovItemWizardItem.h"

@implementation FovItemWizardItem{
    FovWizardItem * fovs;
    bool second;
}

- (instancetype)initWith:(FovWizardItem *) fovWizardItem second:(BOOL) secondItem
{
    self = [super initWith:secondItem ? @"H FOV" : @"V FOV" info:@"Custom field of view setting" itemId: secondItem ? WIZARD_ITEM_FOV_V : WIZARD_ITEM_FOV_H type:WizardItemDataTypeInt];
    if (self) {
        second = secondItem;
        fovs = fovWizardItem;
        self.count = ((120 - 45) * 4) + 1;
        self.valueIndex = ((80 - 45) * 4);
        self.valueId = @"80";
    }
    return self;
}

-(BOOL) available {
    return fovs.valueIndex == 1;
}

-(BOOL) ready {
    return fovs.valueIndex == 1;
}

-(void) loadForInt:(int) value {
    self.valueIndex = value;
    self.valueId = [self stringForIndex:value];
}

-(NSString *) stringForIndex:(int) index {
    return [NSString stringWithFormat:@"%1.2f Degrees", (index / 4.0f) + 45];
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
        instance.vFov = (self.valueIndex / 4.0f) + 45;
    } else {
        instance.hFov = (self.valueIndex / 4.0f) + 45;
    }
}

@end
