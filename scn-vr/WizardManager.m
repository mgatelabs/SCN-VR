//
//  WizardManager.m
//  scn-vr
//
//  Created by Michael Fuller on 1/15/15.
//  Copyright (c) 2015 M-Gate Labs. All rights reserved.
//

#import "WizardManager.h"
#import "TrackerWizardItem.h"
#import "DeviceWizardItem.h"
#import "VirtualDeviceWizardItem.h"

@implementation WizardManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _baseItems = [[NSMutableArray alloc] initWithCapacity:10];
        _filteredItems = [[NSMutableArray alloc] initWithCapacity:10];
        _visibleItems = [[NSMutableArray alloc] initWithCapacity:10];
        
        // Head Tracking
        [_baseItems addObject:[[TrackerWizardItem alloc] init]];
        
        // Device Selection
        DeviceWizardItem * device = [[DeviceWizardItem alloc] init];
        [_baseItems addObject: device];
        
        // Virtual Devices
        [_baseItems addObject: [[VirtualDeviceWizardItem alloc] initWith:device]];
        
        [self filter];
    }
    return self;
}

-(void) item:(int) item changedTo:(int) index {
    
    WizardItem * wizardItem = [_visibleItems objectAtIndex:item];
    [wizardItem selectedIndex:index];
    
    for (int i = 0; i < _baseItems.count; i++) {
        WizardItem * item = [_baseItems objectAtIndex:i];
        [item chainUpdated];
    }
    
    [self filteredItems];
}

// Filter items based upon how well they did
-(void) filter {
    // Clean the filter
    [_filteredItems removeAllObjects];
    [_visibleItems removeAllObjects];
    
    for (int i = 0; i < _baseItems.count; i++) {
        WizardItem * item = [_baseItems objectAtIndex:i];
        
        if ([item ready]) {
            [_filteredItems addObject:item];
        } else {
            if ([item available]) {
                [_filteredItems addObject:item];
            }
            WizardItemNotReadyAction notReadyAct = [item notReadyAction];
            if (notReadyAct == WizardItemNotReadyActionBreak) {
                break;
            }
        }
    }
    
    for (int i = 0; i < _filteredItems.count; i++) {
        WizardItem * item = [_filteredItems objectAtIndex:i];
        if (item.count > 1) {
            [_visibleItems addObject:item];
        }
    }
}

@end
