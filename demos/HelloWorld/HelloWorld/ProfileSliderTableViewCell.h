//
//  ProfileSliderTableViewCell.h
//  Mobile VR Station
//
//  Created by Michael Fuller on 5/22/15.
//  Copyright (c) 2015 M-Gate Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "scn-vr/WizardItem.h"
#import "scn-vr/WizardManager.h"

@interface ProfileSliderTableViewCell : UITableViewCell

@property (weak, nonatomic) WizardItem * item;
@property (weak, nonatomic) WizardManager * manager;

@property (strong, nonatomic) IBOutlet UILabel * nameLabel;
@property (strong, nonatomic) IBOutlet UILabel * valueLabel;
@property (strong, nonatomic) IBOutlet UISlider * slider;

-(void) update;

-(IBAction) sliderValueChanged:(id)sender;

@end
