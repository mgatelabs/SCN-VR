//
//  VirtualCustomWizardItem.h
//  scn-vr
//
//  Created by Michael Fuller on 1/19/15.
//  Copyright (c) 2015 M-Gate Labs. All rights reserved.
//

#import "WizardItem.h"
#import "PhysicalDeviceWizardItem.h"
#import "VirtualDeviceWizardItem.h"

@interface VirtualCustomWizardItem : WizardItem

@property (assign, nonatomic, readonly) int mode;

@property (weak, nonatomic, readonly) PhysicalDeviceWizardItem * physicalWizard;

@property (weak, nonatomic, readonly) VirtualDeviceWizardItem * virtualWizard;

- (instancetype)initWithVirtual:(VirtualDeviceWizardItem *) virtualWizard physical:(PhysicalDeviceWizardItem *) physicalWizard mode:(int) mode;

@end
