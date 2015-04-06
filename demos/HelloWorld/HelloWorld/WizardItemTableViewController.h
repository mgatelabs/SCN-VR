//
//  WizardItemTableViewController.h
//  Mobile VR Player
//
//  Created by Michael Fuller on 1/15/15.
//  Copyright (c) 2015 M-Gate Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "scn-vr/WizardManager.h"

@interface WizardItemTableViewController : UITableViewController

@property (assign, nonatomic) int visibleIndex;
@property (strong, nonatomic) WizardManager * manager;
@property (strong, nonatomic) WizardItem * item;
@end
