//
//  DisplayModeWizarditem.m
//  scn-vr
//
//  Created by Michael Fuller on 12/11/16.
//  Copyright © 2016 M-Gate Labs. All rights reserved.
//

#import "DisplayModeWizarditem.h"
#import "SCNVRResourceBundler.h"

@implementation DisplayModeWizarditem{
    HmdWizardItem * hmds;
    NSString * selectedHmdValueId;
}

- (instancetype)initWith:(HmdWizardItem *) hmdWizardItem
{
    self = [super initWith: NSLocalizedStringFromTableInBundle(@"WIZARD_ITEM_TITLE_DM", @"SCN-VRProfile", [SCNVRResourceBundler getSCNVRResourceBundle], @"Display Mode") info: NSLocalizedStringFromTableInBundle(@"WIZARD_ITEM_INFO_DM", @"SCN-VRProfile", [SCNVRResourceBundler getSCNVRResourceBundle], @"Control how the eyes are displayed.") itemId:WIZARD_ITEM_DISPLAY_MODE type:WizardItemDataTypeInt];
    if (self) {
        hmds = hmdWizardItem;
        selectedHmdValueId = hmds.valueId;
        if (hmds.selected.viewpoints == HmdDeviceConfigurationViewpointsMono) {
            self.count = 1;
        } else {
            self.count = 2;
        }
        self.valueIndex = 0;
        self.valueId = @"default";
    }
    return self;
}

-(void) reset {
    [self chainUpdated];
}

-(void) chainUpdated {
    if ([hmds ready]) {
        if (![hmds.valueId isEqualToString:selectedHmdValueId]) {
            selectedHmdValueId = hmds.valueId;
            if (hmds.selected.viewpoints == HmdDeviceConfigurationViewpointsMono) {
                self.count = 1;
                self.valueIndex = 0;
                self.valueId = @"default";
            } else {
                self.count = 2;
            }
        }
    } else {
        self.count = 1;
        self.valueIndex = 0;
        self.valueId = @"default";
    }
}

-(BOOL) available {
    return self.count > 1;
}

-(BOOL) ready {
    return self.count > 1;
}

-(void) loadForInt:(int) value {
    self.valueIndex = value;
    self.valueId = [self stringForIndex:value];
}

-(void) selectedIndex:(int) index {
    self.valueIndex = index;
    self.valueId = [self stringForIndex:self.valueIndex];
}

-(WizardItemNotReadyAction) notReadyAction {
    return WizardItemNotReadyActionContinue;
}

-(NSString *) stringForIndex:(int) index {
    switch (index) {
        case 0:
            return NSLocalizedStringFromTableInBundle(@"VALUE_DM_LR", @"SCN-VRProfile", [SCNVRResourceBundler getSCNVRResourceBundle], @"Left/Right (Standard)");
        case 1:
            return NSLocalizedStringFromTableInBundle(@"VALUE_DM_RL", @"SCN-VRProfile", [SCNVRResourceBundler getSCNVRResourceBundle], @"Right/Left (Reversed)");
        default:
            return NSLocalizedStringFromTableInBundle(@"VALUE_UNKNOWN", @"SCN-VRProfile", [SCNVRResourceBundler getSCNVRResourceBundle], nil);
    }
}

-(void) updateProfileInstance:(ProfileInstance *) instance {
    switch (self.valueIndex) {
        case 1:
            instance.displayModeFlippedFlag = YES;
            break;
        case 0:
        default:
            instance.displayModeFlippedFlag = NO;
            break;
    }
}

@end
