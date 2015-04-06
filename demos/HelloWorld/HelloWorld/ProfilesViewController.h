//
//  ProfileViewController.h
//  Mobile VR Player
//
//  Created by Michael Fuller on 1/17/15.
//  Copyright (c) 2015 M-Gate Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "scn-vr/ProfileManager.h"

@interface ProfilesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) ProfileManager * profiles;
@property (assign, nonatomic) BOOL wasEditing;
@property (assign, nonatomic) BOOL dirty;
@property (assign, nonatomic) int wasEditingIndex;
@property (strong, nonatomic) IBOutlet UITableView * tableView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem * actionButton;

@property (assign, nonatomic) int forcedEditIndex;

@property (assign, nonatomic) BOOL forceViewSelected;

-(IBAction) actionHit:(id)sender;
-(IBAction) createNewProfile:(id)sender;
-(IBAction) copyProfile:(id)sender;

-(IBAction) helpPressed:(id)sender;

@end
