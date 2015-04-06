//
//  ProfileNameTableViewCell.m
//  Mobile VR Player
//
//  Created by Michael Fuller on 1/17/15.
//  Copyright (c) 2015 M-Gate Labs. All rights reserved.
//

#import "ProfileNameTableViewCell.h"

@implementation ProfileNameTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction) nameFieldChanged:(id)sender {
    _pc.name = self.textfield.text;
    if (_pc.name.length == 0) {
        _pc.name = @"Default";
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    _pc.name = self.textfield.text;
    if (_pc.name.length == 0) {
        _pc.name = @"Default";
    }
    [self.textfield resignFirstResponder];
    return NO;
}

@end
