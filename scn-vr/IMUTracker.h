//
//  IMUTracker.h
//  scn-vr
//
//  Created by Michael Fuller on 12/26/14.
//  Copyright (c) 2014 M-Gate Labs. All rights reserved.
//

#import "TrackerBase.h"
#import <CoreMotion/CoreMotion.h>

@interface IMUTracker : TrackerBase

@property (strong, nonatomic) CMMotionManager *motionManager;

@end
