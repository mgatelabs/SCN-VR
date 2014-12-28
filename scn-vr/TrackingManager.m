//
//  TrackingManager.m
//  SCN-VR
//
//  Created by Michael Fuller on 12/21/14.
//  Copyright (c) 2014 M-Gate Labs. All rights reserved.
//

#import "TrackingManager.h"

@implementation TrackingManager

+ (id)sharedManager {
    static TrackingManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _trackers = [[NSMutableArray alloc] initWithCapacity:2];
        
        [_trackers addObject:[[CoreMotionTracker alloc] init]];
        [_trackers addObject:[[IMUTracker alloc] init]];
        
        [self load];
    }
    return self;
}

-(void) persist {
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    [defs setValue:_tracker.identity forKey:@"scn-vr.trackers.selected"];
    [defs synchronize];
}

-(void) load {
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    
    NSString * selectedIndentity = [defs valueForKey:@"scn-vr.trackers.selected"];
    
    _tracker = [_trackers objectAtIndex:0];
    
    if (selectedIndentity != nil) {
        
        for (int i = 0; i < _trackers.count; i++) {
            TrackerBase * d = [_trackers objectAtIndex:i];
            if ([d.identity isEqualToString:selectedIndentity]) {
                _tracker = d;
                return;
            }
        }
    }
}

-(NSString *) getListName {
    return @"Head Tracking";
}

-(NSString *) getListItemNameFor:(int) index {
    TrackerBase * d = [_trackers objectAtIndex:index];
    return d.name;
}

-(int) getListItemCount {
    return (int)_trackers.count;
}

-(int) getSelectedItemIndex {
    
    if (_tracker == nil) {
        return - 1;
    }
    
    for (int i = 0; i < _trackers.count; i++) {
        TrackerBase * d = [_trackers objectAtIndex:i];
        if (d == _tracker) {
            return i;
        }
    }
    
    NSLog(@"Logic problem, selected item is not in array");
    
    return -1;
}

-(void) selectListItemAt:(int) index {
    _tracker = [_trackers objectAtIndex:index];
    [self persist];
}

@end
