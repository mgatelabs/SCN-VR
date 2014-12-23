//
//  HmdMobileDevicePair.h
//  SCN-VR
//
//  Created by Michael Fuller on 12/19/14.
//  Copyright (c) 2014 M-Gate Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HmdDeviceConfiguration.h"
#import "MobileDeviceConfiguration.h"

@interface HmdMobileDevicePair : NSObject

@property (readonly, weak, nonatomic) HmdDeviceConfiguration * hmd;
@property (readonly, weak, nonatomic) MobileDeviceConfiguration * mobile;

- (instancetype)initWith:(HmdDeviceConfiguration *) hmd mobile:(MobileDeviceConfiguration *) mobile;

@end
