//
//  BNRItemCell.m
//  Homepwner
//
//  Created by Tom Lai on 5/18/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#import "BNRItemCell.h"
#import <UIKit/UIKit.h>

@implementation BNRItemCell

- (IBAction)showImage:(id)sender
{
    if (self.actionBlock) {
        self.actionBlock();
    }
}

- (void)updateInterfaceForDynamicTypeSize
{
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.nameLabel.font = font;
    self.serialNumberLabel.font = font;
    self.valueLabel.font = font;
    
    static NSDictionary *imageSizeDictionary;
    
    if (!imageSizeDictionary) {
        imageSizeDictionary = @{
                                 UIContentSizeCategoryExtraSmall : @44,
                                 UIContentSizeCategorySmall : @44,
                                 UIContentSizeCategoryMedium : @44,
                                 UIContentSizeCategoryLarge : @44,
                                 UIContentSizeCategoryExtraLarge : @55,
                                 UIContentSizeCategoryExtraExtraLarge: @65,
                                 UIContentSizeCategoryExtraExtraExtraLarge :@75
                                 };
    }
    
    NSString *userSize = [[UIApplication sharedApplication] preferredContentSizeCategory];
    
    NSNumber *imageSize = imageSizeDictionary[userSize];
    self.imageViewHeightConstraint.constant = imageSize.floatValue;
    self.imageViewWidthConstraint.constant = imageSize.floatValue;
    
}

- (void)awakeFromNib
{
    [self updateInterfaceForDynamicTypeSize];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(updateInterfaceForDynamicTypeSize)
               name:UIContentSizeCategoryDidChangeNotification
             object:nil];
}

- (void)dealloc
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
}

@end
