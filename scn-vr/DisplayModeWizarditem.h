//
//  DisplayModeWizarditem.h
//  scn-vr
//
//  Created by Michael Fuller on 12/11/16.
//  Copyright © 2016 M-Gate Labs. All rights reserved.
//

#import "WizardItem.h"
#import "HmdWizardItem.h"

@interface DisplayModeWizarditem : WizardItem

- (instancetype)initWith:(HmdWizardItem *) hmdWizardItem;

-(int) indexForString:(NSString *) source;

@end
