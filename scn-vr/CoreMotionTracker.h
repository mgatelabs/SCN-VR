//
//  CoreMotionTracker.h
//  SCN-VR
//
//  Created by Michael Fuller on 12/21/14.
//  Copyright (c) 2014 M-Gate Labs. All rights reserved.
//

#import "TrackerBase.h"
#import <CoreMotion/CoreMotion.h>

@interface CoreMotionTracker : TrackerBase

@property (strong, nonatomic) CMMotionManager *motionManager;

@end
