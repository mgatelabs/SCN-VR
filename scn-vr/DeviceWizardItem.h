//
//  DeviceWizardItem.h
//  scn-vr
//
//  Created by Michael Fuller on 1/15/15.
//  Copyright (c) 2015 M-Gate Labs. All rights reserved.
//

#import "WizardItem.h"
#import "MobileDeviceConfiguration.h"

@interface DeviceWizardItem : WizardItem

@property (strong, nonatomic) MobileDeviceConfiguration * selected;

- (instancetype)init;

@end
