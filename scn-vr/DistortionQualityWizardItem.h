//
//  DistortionQualityWizardItem.h
//  scn-vr
//
//  Created by Michael Fuller on 1/26/15.
//  Copyright (c) 2015 M-Gate Labs. All rights reserved.
//

#import "WizardItem.h"
#import "DistortionWizardItem.h"

@interface DistortionQualityWizardItem : WizardItem

@property (weak, nonatomic) DistortionWizardItem * distortion;

- (instancetype)initWith:(DistortionWizardItem *) distortion;

@end
