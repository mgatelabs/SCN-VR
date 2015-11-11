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
        [_trackers addObject:[[CoreMotionTracker alloc] initWithoutMagnet]];
        // Does not work, please fix
        //[_trackers addObject:[[IMUTracker alloc] init]];
        
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
    
    //NSLog(@"Logic problem, selected item is not in array");
    
    return -1;
}

-(void) selectListItemAt:(int) index {
    _tracker = [_trackers objectAtIndex:index];
    [self persist];
}

@end
