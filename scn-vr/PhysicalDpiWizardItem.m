//
//  PhysicalDpiWizardItem.m
//  scn-vr
//
//  Created by Michael Fuller on 1/19/15.
//  Copyright (c) 2015 M-Gate Labs. All rights reserved.
//

#import "PhysicalDpiWizardItem.h"
#import "Constants.h"

@implementation PhysicalDpiWizardItem

- (instancetype)initWith:(PhysicalDeviceWizardItem*) physicalWizard
{
    self = [super initWith:@"Physical DPI" info:@"We can't figureout your current device, please input the physical DPI and we will figure out the rest." itemId:WIZARD_ITEM_DEVICE_DPI type:WizardItemDataTypeInt];
    if (self) {
        _physicalWizard = physicalWizard;
        self.count = 0;
        self.valueId = @"";
        self.valueIndex = 0;
    }
    return self;
}

-(void) chainUpdated {
    if (_physicalWizard.selected.custom == YES) {
        self.count = 1440 - 162;
    } else {
        self.count = 0;
    }
}

-(void) selectedIndex:(int) index {
    self.valueIndex = index;
    self.valueId = [self stringForIndex:index];
}

-(void) loadForInt:(int) value {
    self.valueIndex = value;
    self.valueId = [self stringForIndex:value];
}

-(BOOL) available {
    return _physicalWizard.selected.custom == YES;
}

-(BOOL) ready {
    return self.count > 1;
}

-(NSString *) stringForIndex:(int) index {
    return [NSString stringWithFormat:@"%d DPI", index + 132];
}

-(void) updateProfileInstance:(ProfileInstance *) instance {
    
    instance.physicalDPI = self.valueIndex + 132;

    instance.physicalWidthIN = instance.physicalWidthPX / (float)(instance.physicalDPI);
    instance.physicalWidthMM = instance.physicalWidthIN * IN_2_MM;
    
    instance.physicalHeightIN = instance.physicalHeightPX / (float)(instance.physicalDPI);
    instance.physicalHeightMM = instance.physicalHeightIN * IN_2_MM;
}

-(WizardItemNotReadyAction) notReadyAction {
    return WizardItemNotReadyActionContinue;
}

@end
