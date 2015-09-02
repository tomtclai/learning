//
//  TSPToDoCell.h
//  Done
//
//  Created by Tom Lai on 9/1/15.
//  Copyright (c) 2015 Lai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TSPToDoCellDidTapButtonBlock)();

@interface TSPToDoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@property (copy, nonatomic) TSPToDoCellDidTapButtonBlock didTapButtonBlock;
@end
