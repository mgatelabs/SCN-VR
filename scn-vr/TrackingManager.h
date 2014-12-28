//
//  TrackingManager.h
//  SCN-VR
//
//  Created by Michael Fuller on 12/21/14.
//  Copyright (c) 2014 M-Gate Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreMotionTracker.h"
#import "IMUTracker.h"
#import "ListableArray.h"

@interface TrackingManager : ListableArray

@property (readonly, strong, nonatomic) NSMutableArray * trackers;

@property (readonly, weak, nonatomic) TrackerBase * tracker;

-(void) persist;

-(void) load;

+ (id)sharedManager;

@end
