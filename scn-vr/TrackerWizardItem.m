//
//  TrackerWizardItem.m
//  scn-vr
//
//  Created by Michael Fuller on 1/15/15.
//  Copyright (c) 2015 M-Gate Labs. All rights reserved.
//

#import "TrackerWizardItem.h"
#import "TrackingManager.h"

@implementation TrackerWizardItem {
    TrackingManager * tm;
    TrackerBase * tracker;
}

- (instancetype)init
{
    self = [super initWith:@"Head Tracker" info:@"Select your preferred head tracker." itemId:WIZARD_ITEM_HEADTRACKER type:WizardItemDataTypeString];
    if (self) {
        tm = [TrackingManager sharedManager];
        // Just one tracker for now, don't care
        if (tm.trackers.count == 1) {
            tracker = [tm.trackers objectAtIndex:0];
            self.valueId = tracker.identity;
            self.valueIndex = 0;
            self.count = 1;
        }
    }
    return self;
}

-(WizardItemChangeAction) changeAction {
    return WizardItemChangeActionNone;
}

-(void) loadForIdentity:(NSString *) identity {
    tracker = [tm.trackers objectAtIndex:0];
    self.valueId = tracker.identity;
    self.valueIndex = 0;
    
    for (int i = 0; i < tm.trackers.count; i++) {
        TrackerBase * temp = [tm.trackers objectAtIndex:i];
        if ([temp.identity isEqualToString:identity]) {
            tracker = temp;
            self.valueId = temp.identity;
            self.valueIndex = i;
            break;
        }
    }
    
}

-(BOOL) ready {
    return self.count > 0;
}

-(BOOL) available {
    return true;
}

-(NSString *) stringForIndex:(int) index {
    return tracker.name;
}

-(void) updateProfileInstance:(ProfileInstance *) instance {
    instance.tracker = tracker;
}

@end
