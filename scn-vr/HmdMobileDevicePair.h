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
#import "VirtualDeviceConfiguration.h"

@interface HmdMobileDevicePair : NSObject

@property (readonly, weak, nonatomic) HmdDeviceConfiguration * hmd;
@property (readonly, weak, nonatomic) MobileDeviceConfiguration * mobile;
@property (readonly, weak, nonatomic) VirtualDeviceConfiguration * virtualDevice;

@property (readonly, assign, nonatomic) BOOL landscape;
@property (assign) int widthPx;
@property (assign) int heightPx;
@property (assign) int offsetPx;
@property (assign) int offsetPy;
@property (assign) float dpi;
@property (readonly, assign) float widthIN;
@property (readonly, assign) float heightIN;
@property (readonly, assign) float widthMM;
@property (readonly, assign) float heightMM;

- (instancetype)initWith:(HmdDeviceConfiguration *) hmd mobile:(MobileDeviceConfiguration *) mobile virtualDevice:(VirtualDeviceConfiguration *) virtualDevice;

@end
