//
//  PhysicalDpiWizardItem.h
//  scn-vr
//
//  Created by Michael Fuller on 1/19/15.
//  Copyright (c) 2015 M-Gate Labs. All rights reserved.
//

#import "WizardItem.h"
#import "PhysicalDeviceWizardItem.h"

@interface PhysicalDpiWizardItem : WizardItem

@property (weak, nonatomic, readonly) PhysicalDeviceWizardItem * physicalWizard;

- (instancetype)initWith:(PhysicalDeviceWizardItem*) physicalWizard;

@end
