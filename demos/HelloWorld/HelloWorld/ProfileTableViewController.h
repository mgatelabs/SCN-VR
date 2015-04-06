//
//  ProfileTableViewController.h
//  Mobile VR Player
//
//  Created by Michael Fuller on 1/17/15.
//  Copyright (c) 2015 M-Gate Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "scn-vr/WizardManager.h"
#import "scn-vr/ProfileConfiguration.h"

@interface ProfileTableViewController : UITableViewController

@property (weak, nonatomic) WizardManager * wizard;
@property (weak, nonatomic) ProfileConfiguration * profile;

@property (strong, nonatomic) NSArray * extendedStorage;

- (IBAction)returnFromWizardItemHome:(UIStoryboardSegue *)segue;

-(void) fillExtendedStorage;

@end
