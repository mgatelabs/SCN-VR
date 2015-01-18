//
//  HmdWizardItem.h
//  scn-vr
//
//  Created by Michael Fuller on 1/16/15.
//  Copyright (c) 2015 M-Gate Labs. All rights reserved.
//

#import "WizardItem.h"
#import "HmdDeviceConfiguration.h"

@interface HmdWizardItem : WizardItem

@property (strong, nonatomic) HmdDeviceConfiguration * selected;

@end
