//
//  ProfileNameTableViewCell.h
//  Mobile VR Player
//
//  Created by Michael Fuller on 1/17/15.
//  Copyright (c) 2015 M-Gate Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "scn-vr/ProfileConfiguration.h"

@interface ProfileNameTableViewCell : UITableViewCell <UITextViewDelegate>

@property (weak, nonatomic) ProfileConfiguration * pc;

@property (strong, nonatomic) IBOutlet UITextField * textfield;

-(IBAction) nameFieldChanged:(id)sender;

@end
