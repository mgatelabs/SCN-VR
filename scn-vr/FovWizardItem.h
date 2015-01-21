//
//  FovWizardItem.h
//  scn-vr
//
//  Created by Michael Fuller on 1/20/15.
//  Copyright (c) 2015 M-Gate Labs. All rights reserved.
//

#import "WizardItem.h"
#import "HmdWizardItem.h"

@interface FovWizardItem : WizardItem

- (instancetype)initWith:(HmdWizardItem *) hmdWizardItem;

@end
