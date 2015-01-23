//
//  IpdValueWizarditem.m
//  scn-vr
//
//  Created by Michael Fuller on 1/16/15.
//  Copyright (c) 2015 M-Gate Labs. All rights reserved.
//

#import "IpdValueWizarditem.h"

@implementation IpdValueWizarditem {
    IpdWizardItem * ipds;
    bool second;
}

- (instancetype)initWith:(IpdWizardItem *) ipdWizardItem second:(BOOL) secondItem
{
    self = [super initWith:secondItem ? @"Camera IPD" : @"Your IPD" info:@"Distance in MM" itemId: secondItem ? WIZARD_ITEM_IPD_VALUE2 : WIZARD_ITEM_IPD_VALUE1 type:WizardItemDataTypeInt];
    if (self) {
        second = secondItem;
        ipds = ipdWizardItem;
        self.count = 75 * 2;
        self.valueIndex = 62 * 2;
        self.valueId = @"62";
    }
    return self;
}

-(BOOL) available {
    return ipds.valueIndex == 2;
}

-(BOOL) ready {
    return ipds.valueIndex == 2;
}

-(void) loadForInt:(int) value {
    self.valueIndex = value;
    self.valueId = [self stringForIndex:value];
}

-(NSString *) stringForIndex:(int) index {
    return [NSString stringWithFormat:@"%1.1f MM", index / 2.0f];
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
        instance.cameraIPD = self.valueIndex / 2.0f;
    } else {
        instance.viewerIPD = self.valueIndex / 2.0f;
    }
}

@end
