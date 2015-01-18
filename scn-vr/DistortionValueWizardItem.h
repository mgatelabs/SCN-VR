//
//  DistortionValueWizardItem.h
//  scn-vr
//
//  Created by Michael Fuller on 1/16/15.
//  Copyright (c) 2015 M-Gate Labs. All rights reserved.
//

#import "WizardItem.h"
#import "DistortionWizardItem.h"

@interface DistortionValueWizardItem : WizardItem

- (instancetype)initWith:(DistortionWizardItem *) distortionWizardItem second:(BOOL) second;

@end
