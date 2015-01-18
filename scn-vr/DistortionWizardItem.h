//
//  DistortionWizardItem.h
//  scn-vr
//
//  Created by Michael Fuller on 1/16/15.
//  Copyright (c) 2015 M-Gate Labs. All rights reserved.
//

#import "WizardItem.h"
#import "HmdWizardItem.h"

@interface DistortionWizardItem : WizardItem

- (instancetype)initWith:(HmdWizardItem *) hmdWizardItem;

@end
