//
//  SamplingWizardItem.m
//  scn-vr
//
//  Created by Michael Fuller on 4/5/15.
//  Copyright (c) 2015 M-Gate Labs. All rights reserved.
//

#import "SamplingWizardItem.h"
#import "SCNVRResourceBundler.h"

@implementation SamplingWizardItem{
    HmdWizardItem * hmds;
    NSString * selectedHmdValueId;
}

- (instancetype)initWith:(HmdWizardItem *) hmdWizardItem
{
    self = [super initWith: NSLocalizedStringFromTableInBundle(@"WIZARD_ITEM_TITLE_SS", @"SCN-VRProfile", [SCNVRResourceBundler getSCNVRResourceBundle], @"Super Sampling") info: NSLocalizedStringFromTableInBundle(@"WIZARD_ITEM_INFO_SS", @"SCN-VRProfile", [SCNVRResourceBundler getSCNVRResourceBundle], @"Super sampling is a technique that will increase quality, but degrade performance.") itemId:WIZARD_ITEM_SUPER_SAMPLING type:WizardItemDataTypeInt];
    if (self) {
        hmds = hmdWizardItem;
        selectedHmdValueId = hmds.valueId;
        if (hmds.selected.deviceUsed == NO) {
            self.count = 1;
        } else {
            self.count = 4;
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
            if (hmds.selected.deviceUsed == NO) {
                self.count = 1;
                self.valueIndex = 0;
                self.valueId = @"default";
            } else {
                self.count = 4;
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
    if (self.count == 1) {
        self.valueIndex = 0;
        
    } else {
        switch (value) {
            case 200:
                self.valueIndex = 3;
                break;
            case 150:
                self.valueIndex = 2;
                break;
            case 125:
                self.valueIndex = 1;
                break;
            case 100:
            default:
                self.valueIndex = 0;
                break;
        }
    }
    self.valueId = [self stringForIndex:self.valueIndex];
}

-(int) prepValueToSave {
    switch (self.valueIndex) {
        case 3:
            return 200;
        case 2:
            return 150;
        case 1:
            return 125;
        case 0:
        default:
            return 100;
    }
}

-(NSString *) stringForIndex:(int) index {
    switch (index) {
        case 0:
            return NSLocalizedStringFromTableInBundle(@"VALUE_SS_1X", @"SCN-VRProfile", [SCNVRResourceBundler getSCNVRResourceBundle], @"1x - Standard");
        case 1:
            return NSLocalizedStringFromTableInBundle(@"VALUE_SS_125X", @"SCN-VRProfile", [SCNVRResourceBundler getSCNVRResourceBundle], @"1.25x");
        case 2:
            return NSLocalizedStringFromTableInBundle(@"VALUE_SS_15X", @"SCN-VRProfile", [SCNVRResourceBundler getSCNVRResourceBundle], @"1.5x");
        case 3:
            return NSLocalizedStringFromTableInBundle(@"VALUE_SS_2X", @"SCN-VRProfile", [SCNVRResourceBundler getSCNVRResourceBundle], @"2x");
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
        case 3:
            instance.ssMode = ProfileInstanceSS2X;
            break;
        case 2:
            instance.ssMode = ProfileInstanceSS15X;
            break;
        case 1:
            instance.ssMode = ProfileInstanceSS125X;
            break;
        case 0:
        default:
            instance.ssMode = ProfileInstanceSS1X;
            break;
    }
}

@end
