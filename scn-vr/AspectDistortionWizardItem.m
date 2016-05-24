//
//  AspectDistortionWizardItem.m
//  scn-vr
//
//  Created by Michael Fuller on 5/9/16.
//  Copyright © 2016 M-Gate Labs. All rights reserved.
//

#import "AspectDistortionWizardItem.h"
#import "SCNVRResourceBundler.h"

@implementation AspectDistortionWizardItem{
    HmdWizardItem * hmds;
    NSString * selectedHmdValueId;
}

- (instancetype)initWith:(HmdWizardItem *) hmdWizardItem
{
    self = [super initWith: NSLocalizedStringFromTableInBundle(@"WIZARD_ITEM_TITLE_CASP", @"SCN-VRProfile", [SCNVRResourceBundler getSCNVRResourceBundle], @"Correct Aspect") info: NSLocalizedStringFromTableInBundle(@"WIZARD_ITEM_INFO_CASP", @"SCN-VRProfile", [SCNVRResourceBundler getSCNVRResourceBundle], @"Correct aspect ratio") itemId:WIZARD_ITEM_CORRECT_ASPECT type:WizardItemDataTypeInt];
    if (self) {
        hmds = hmdWizardItem;
        selectedHmdValueId = @"nope";
        self.valueIndex = 0;
        self.valueId = @"default";
        [self reset];
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
            if (hmds.selected.deviceUsed == NO) {
                self.count = 1;
                self.valueIndex = 0;
                self.valueId = [self stringForIndex:self.valueIndex];
            } else {
                self.count = 2;
                self.valueIndex = 1;
                self.valueId = [self stringForIndex:self.valueIndex];
            }
        }
    } else {
        self.count = 1;
        self.valueIndex = 0;
        self.valueId = [self stringForIndex:self.valueIndex];
    }
}

-(BOOL) available {
    return self.count > 1;
}

-(BOOL) ready {
    return self.count > 1;
}

-(NSString *) stringForIndex:(int) index {
    switch (index) {
        case 1:
            return NSLocalizedStringFromTableInBundle(@"VALUE_CASP_ON", @"SCN-VRProfile", [SCNVRResourceBundler getSCNVRResourceBundle], @"Correct Aspect Ration On");
        case 0:
            return NSLocalizedStringFromTableInBundle(@"VALUE_CASP_OFF", @"SCN-VRProfile", [SCNVRResourceBundler getSCNVRResourceBundle], @"Correct Aspect Ration Off");
        default:
            return NSLocalizedStringFromTableInBundle(@"VALUE_UNKNOWN", @"SCN-VRProfile", [SCNVRResourceBundler getSCNVRResourceBundle], nil);
    }
}

-(void) selectedIndex:(int) index {
    self.valueIndex = index;
    self.valueId = [self stringForIndex:self.valueIndex];
}

-(void) updateProfileInstance:(ProfileInstance *) instance {
    switch (self.valueIndex) {
        case 1:
            instance.correctHeightWidth = YES;
            break;
        case 0:
        default:
            instance.correctHeightWidth = NO;
            break;
    }
}

@end
