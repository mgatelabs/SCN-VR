//
//  IpdWizardItem.m
//  scn-vr
//
//  Created by Michael Fuller on 1/16/15.
//  Copyright (c) 2015 M-Gate Labs. All rights reserved.
//

#import "IpdWizardItem.h"

@implementation IpdWizardItem {
    HmdWizardItem * hmds;
    NSString * selectedHmdValueId;
}

- (instancetype)initWith:(HmdWizardItem *) hmdWizardItem
{
    self = [super initWith:@"IPD" info:@"IPD refers to the distance between your eyes." itemId:WIZARD_ITEM_IPD type:WizardItemDataTypeString];
    if (self) {
        hmds = hmdWizardItem;
        selectedHmdValueId = hmds.valueId;
        if ([selectedHmdValueId isEqualToString:@"mono"] || [selectedHmdValueId isEqualToString:@"none"]) {
            self.count = 1;
        } else {
            if (hmds.selected.extraIpdAvailable) {
                self.count = 5;
            } else {
                self.count = 3;
            }
        }
        self.valueIndex = 0;
        self.valueId = [self stringForIndex:0];
    }
    return self;
}

-(void) chainUpdated {
    if ([hmds ready]) {
        if (![hmds.valueId isEqualToString:selectedHmdValueId]) {
            selectedHmdValueId = hmds.valueId;
            
            if ([selectedHmdValueId isEqualToString:@"mono"] || [selectedHmdValueId isEqualToString:@"none"]) {
                self.count = 1;
                self.valueIndex = 0;
                self.valueId = [self stringForIndex:0];
            } else {
                if (hmds.selected.extraIpdAvailable) {
                    self.count = 5;
                } else {
                    self.count = 3;
                }
            }
            
            if (self.valueIndex >= self.count) {
                self.valueIndex = 0;
                self.valueId = [self stringForIndex:0];
            }
            
        }
    } else {
        self.count = 1;
        self.valueIndex = 0;
        self.valueId = [self stringForIndex:0];
    }
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
            return @"Center";
        case 1:
            return @"Default";
        case 2:
            return @"Custom";
        case 3:
            return @"Adult";
        case 4:
            return @"Child";
        
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
            self.valueId =  @"Center";
            break;
        case 1:
            self.valueId = @"Default";
            break;
        case 2:
            self.valueId =  @"Custom";
            break;
        case 3:
            self.valueId = @"Adult";
            break;
        case 4:
            self.valueId =  @"Child";
            break;
        default:
            self.valueId =  @"Unknown";
    }
}

-(void) updateProfileInstance:(ProfileInstance *) instance {
    switch (self.valueIndex) {
        case 1:
            instance.centerIPD = NO;
            break;
        case 0:
            instance.centerIPD = YES;
            break;
        case 2:
            // Will defer
            instance.centerIPD = NO;
            break;
        case 3:
            instance.centerIPD = NO;
            instance.cameraIPD = hmds.selected.ipdAdult;
            instance.viewerIPD = instance.cameraIPD;
            break;
        case 4:
            instance.centerIPD = NO;
            instance.cameraIPD = hmds.selected.ipdChild;
            instance.viewerIPD = instance.cameraIPD;
            break;
        
        default:
            break;
    }
}

@end
