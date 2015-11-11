/************************************************************************
	
 
	Copyright (C) 2015  Michael Glen Fuller Jr.
 
	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.
 
	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.
 
	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.
 
 ************************************************************************/

#import "TrackerWizardItem.h"
#import "TrackingManager.h"
#import "SCNVRResourceBundler.h"

@implementation TrackerWizardItem {
    TrackingManager * tm;
    TrackerBase * tracker;
}

- (instancetype)init
{
    self = [super initWith: NSLocalizedStringFromTableInBundle(@"WIZARD_ITEM_TITLE_TRACKER", @"SCN-VRProfile", [SCNVRResourceBundler getSCNVRResourceBundle], @"Head Tracker") info: NSLocalizedStringFromTableInBundle(@"WIZARD_ITEM_INFO_TRACKER", @"SCN-VRProfile", [SCNVRResourceBundler getSCNVRResourceBundle], @"Select your preferred head tracker.") itemId:WIZARD_ITEM_HEADTRACKER type:WizardItemDataTypeString];
    if (self) {
        tm = [TrackingManager sharedManager];
        // Just one tracker for now, don't care
        //if (tm.trackers.count == 1) {
        [self reset];
        //}
    }
    return self;
}

-(void) reset {
    tracker = [tm.trackers objectAtIndex:0];
    self.valueId = tracker.identity;
    self.valueIndex = 0;
    self.count = (int)tm.trackers.count;
}

-(WizardItemChangeAction) changeAction {
    return WizardItemChangeActionNone;
}

-(WizardItemNotReadyAction) notReadyAction {
    return WizardItemNotReadyActionContinue;
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

-(NSString *) stringForIndex:(int) index {
    TrackerBase * temp = [tm.trackers objectAtIndex:index];
    return temp.name;
}

-(void) selectedIndex:(int) index {
    self.valueIndex = index;
    TrackerBase * temp = [tm.trackers objectAtIndex:index];
    tracker = temp;
    self.valueId = temp.identity;
}

-(BOOL) available {
    return self.count > 0;
}

-(BOOL) ready {
    return self.count > 0;
}

-(void) updateProfileInstance:(ProfileInstance *) instance {
    instance.tracker = tracker;
}

@end
