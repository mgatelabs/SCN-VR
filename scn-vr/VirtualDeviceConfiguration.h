//
//  VirtualDeviceConfiguration.h
//  scn-vr
//
//  Created by Michael Fuller on 1/5/15.
//  Copyright (c) 2015 M-Gate Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MobileDeviceConfiguration.h"

typedef NS_ENUM(NSInteger, VirtualDeviceConfigurationType) {
    VirtualDeviceConfigurationTypeLandscape = 0,
    VirtualDeviceConfigurationTypeLandscape169 = 1,
    VirtualDeviceConfigurationTypePortrait = 2,
    VirtualDeviceConfigurationTypePortrait169 = 3,
    VirtualDeviceConfigurationTypeLandscapeVirtual = 4,
    VirtualDeviceConfigurationTypePortraitVirtual = 5
};

@interface VirtualDeviceConfiguration : NSObject

@property (assign, readonly) VirtualDeviceConfigurationType type;

@property (strong, nonatomic) NSString * name;

@property (strong, nonatomic) NSString * key;

@property (strong, nonatomic, readonly) MobileDeviceConfiguration * virtualDevice;

- (instancetype)initWithType:(VirtualDeviceConfigurationType) type name:(NSString *) name key:(NSString *) key;

- (instancetype)initWithType:(VirtualDeviceConfigurationType) type name:(NSString *) name  key:(NSString *) key device:(MobileDeviceConfiguration *) device;

@end
