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
        
        _tracker = [_trackers objectAtIndex:0];
    }
    return self;
}

@end
