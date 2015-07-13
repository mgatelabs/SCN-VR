//
//  VirtualPositionWizardItem.h
//  scn-vr
//
//  Created by Michael Fuller on 7/12/15.
//  Copyright (c) 2015 M-Gate Labs. All rights reserved.
//

#import "WizardItem.h"
#import "VirtualDeviceWizardItem.h"

@interface VirtualPositionWizardItem : WizardItem

@property (weak, nonatomic, readonly) VirtualDeviceWizardItem * vdw;
@property (assign, nonatomic, readonly) BOOL allowShift;

- (instancetype)initWith:(VirtualDeviceWizardItem *) virtualWizardItem isX:(BOOL) isX;

-(void) updateInfo;

@end
