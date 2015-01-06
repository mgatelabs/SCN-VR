//
//  VirtualDeviceConfiguration.m
//  scn-vr
//
//  Created by Michael Fuller on 1/5/15.
//  Copyright (c) 2015 M-Gate Labs. All rights reserved.
//

#import "VirtualDeviceConfiguration.h"

@implementation VirtualDeviceConfiguration

- (instancetype)initWithType:(VirtualDeviceConfigurationType) type name:(NSString *) name key:(NSString *) key
{
    self = [super init];
    if (self) {
        _type = type;
        _key = key;
        _name = name;
        _virtualDevice = nil;
    }
    return self;
}

- (instancetype)initWithType:(VirtualDeviceConfigurationType) type name:(NSString *) name key:(NSString *) key device:(MobileDeviceConfiguration *) device
{
    self = [super init];
    if (self) {
        _type = type;
        _key = key;
        _name = name;
        _virtualDevice = device;
    }
    return self;
}

@end
