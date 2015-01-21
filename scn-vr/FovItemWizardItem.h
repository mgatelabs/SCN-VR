//
//  FovItemWizardItem.h
//  scn-vr
//
//  Created by Michael Fuller on 1/20/15.
//  Copyright (c) 2015 M-Gate Labs. All rights reserved.
//

#import "WizardItem.h"
#import "FovWizardItem.h"

@interface FovItemWizardItem : WizardItem

- (instancetype)initWith:(FovWizardItem *) fovWizardItem second:(BOOL) secondItem;

@end
