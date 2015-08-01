//
//  ProfileSliderTableViewCell.m
//  Mobile VR Station
//
//  Created by Michael Fuller on 5/22/15.
//  Copyright (c) 2015 M-Gate Labs. All rights reserved.
//

#import "ProfileSliderTableViewCell.h"

@implementation ProfileSliderTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) update {
    self.nameLabel.text = self.item.title;
    self.valueLabel.text = [self.item stringForSlider];
    self.slider.minimumValue = self.item.type == WizardItemDataTypeSlideFloat ? [self.item.slideMin floatValue] : [self.item.slideMin intValue];
    self.slider.maximumValue = self.item.type == WizardItemDataTypeSlideFloat ? [self.item.slideMax floatValue] : [self.item.slideMax intValue];
    self.slider.value = self.item.type == WizardItemDataTypeSlideFloat ? [self.item.slideValue floatValue] : [self.item.slideValue intValue];
}

-(IBAction) sliderValueChanged:(id)sender {
    if (self.item.type == WizardItemDataTypeSlideFloat) {
        float newStep = roundf((self.slider.value) / [self.item.slideStep floatValue]);
        self.slider.value = newStep * [self.item.slideStep floatValue];
        self.item.slideValue = [NSNumber numberWithFloat:self.slider.value];
    } else {
        float newStep = roundf((self.slider.value) / [self.item.slideStep floatValue]);
        self.slider.value = newStep * [self.item.slideStep intValue];
        self.item.slideValue = [NSNumber numberWithInt:self.slider.value];
    }
    [_manager makeDirty];
    self.valueLabel.text = [self.item stringForSlider];
}

@end
