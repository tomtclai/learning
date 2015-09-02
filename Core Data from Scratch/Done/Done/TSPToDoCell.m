//
//  TSPToDoCell.m
//  Done
//
//  Created by Tom Lai on 9/1/15.
//  Copyright (c) 2015 Lai. All rights reserved.
//

#import "TSPToDoCell.h"

@implementation TSPToDoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupView];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
     
#pragma mark - View Methods
- (void)setupView {
    UIImage *imageNormal = [UIImage imageNamed:@"button-done-normal"];
    UIImage *imageSelected = [UIImage imageNamed:@"button-done-selected"];
    
    [self.doneButton setImage:imageNormal forState:UIControlStateNormal];
    [self.doneButton setImage:imageNormal forState:UIControlStateDisabled];
    [self.doneButton setImage:imageSelected forState:UIControlStateSelected];
    [self.doneButton setImage:imageSelected forState:UIControlStateHighlighted];
    
    [self.doneButton addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - Actions
- (void)didTapButton: (UIButton *)button {
    if (self.didTapButtonBlock) {
        self.didTapButtonBlock();
    }
}
@end
