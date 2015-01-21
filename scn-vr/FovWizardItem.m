//
//  FovWizardItem.m
//  scn-vr
//
//  Created by Michael Fuller on 1/20/15.
//  Copyright (c) 2015 M-Gate Labs. All rights reserved.
//

#import "FovWizardItem.h"

@implementation FovWizardItem{
    HmdWizardItem * hmds;
}

- (instancetype)initWith:(HmdWizardItem *) hmdWizardItem
{
    self = [super initWith:@"FOV" info:@"The field of view is how wide and high you can see." itemId:WIZARD_ITEM_FOV type:WizardItemDataTypeString];
    if (self) {
        hmds = hmdWizardItem;
        self.count = 2;
        self.valueIndex = 0;
        self.valueId = @"default";
    }
    return self;
}

-(void) chainUpdated {
    
}

-(BOOL) available {
    return self.count > 0;
}

-(BOOL) ready {
    return self.count > 0;
}

-(NSString *) stringForIndex:(int) index {
    switch (index) {
        case 0:
            return @"Default";
        case 1:
            return @"Custom";
        default:
            return @"Unknown";
    }
}

-(void) loadForIdentity:(NSString *) identity {
    
    if (self.count == 1) {
        self.valueIndex = 0;
        self.valueId = [self stringForIndex:0];
    } else {
        for (int i = 0; i < self.count; i++) {
            NSString * temp = [self stringForIndex:i];
            if ([temp isEqualToString:identity]) {
                self.valueIndex = i;
                self.valueId = temp;
                return;
            }
        }
        self.valueIndex = 0;
        self.valueId = [self stringForIndex:0];
    }
}

-(void) selectedIndex:(int) index {
    self.valueIndex = index;
    switch (index) {
        case 0:
            self.valueId = @"Default";
            break;
        case 1:
            self.valueId =  @"Custom";
            break;
        default:
            self.valueId =  @"Unknown";
    }
}

-(void) updateProfileInstance:(ProfileInstance *) instance {
    switch (self.valueIndex) {
        case 0:
            instance.hFov = hmds.selected.hFov;
            instance.vFov = hmds.selected.vFov;
            break;
        case 1:
            // Will defer
            break;
        default:
            break;
    }
}

-(WizardItemNotReadyAction) notReadyAction {
    return WizardItemNotReadyActionContinue;
}

@end
