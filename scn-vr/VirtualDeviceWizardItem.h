//
//  VirtualDeviceWizardItem.h
//  scn-vr
//
//  Created by Michael Fuller on 1/15/15.
//  Copyright (c) 2015 M-Gate Labs. All rights reserved.
//

#import "WizardItem.h"
#import "DeviceWizardItem.h"

@interface VirtualDeviceWizardItem : WizardItem

@property (strong, nonatomic, readonly) NSMutableArray * items;

- (instancetype)initWith:(DeviceWizardItem *) deviceWizardItem;

-(void) filterDevices;

@end
