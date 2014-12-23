//
//  HmdMobileDevicePair.m
//  SCN-VR
//
//  Created by Michael Fuller on 12/19/14.
//  Copyright (c) 2014 M-Gate Labs. All rights reserved.
//

#import "HmdMobileDevicePair.h"

@implementation HmdMobileDevicePair

- (instancetype)initWith:(HmdDeviceConfiguration *) hmd mobile:(MobileDeviceConfiguration *) mobile
{
    self = [super init];
    if (self) {
        _hmd = hmd;
        _mobile = mobile;
    }
    return self;
}

@end
