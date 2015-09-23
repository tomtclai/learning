//
//  PTKEntryCell.h
//  photoKeepr
//
//  Created by Tom Lai on 9/22/15.
//  Copyright © 2015 Lai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTKEntryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

@end
