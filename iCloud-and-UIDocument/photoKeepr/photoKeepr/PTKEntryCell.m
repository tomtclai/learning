//
//  PTKEntryCell.m
//  photoKeepr
//
//  Created by Tom Lai on 9/22/15.
//  Copyright © 2015 Lai. All rights reserved.
//

#import "PTKEntryCell.h"

@implementation PTKEntryCell

@synthesize titleTextField;
@synthesize photoImageView;
@synthesize subtitleLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


// Switch textfield into editing mode or not based on if the cell is being edited
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [UIView animateWithDuration:0.1 animations:^{
        if (editing) {
            titleTextField.enabled = YES;
            titleTextField.borderStyle = UITextBorderStyleRoundedRect;
        } else {
            titleTextField.enabled = NO;
            titleTextField.borderStyle = UITextBorderStyleNone;
        }
    }];
}

@end
