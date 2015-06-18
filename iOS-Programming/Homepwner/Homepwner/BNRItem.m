//
//  BNRItem.m
//  Homepwner
//
//  Created by Tom Lai on 6/17/15.
//  Copyright © 2015 Tsz Chun Lai. All rights reserved.
//

#import "BNRItem.h"
@implementation BNRItem
@synthesize assetType, orderingValue, itemKey, thumbnail,itemName, serialNumber,valueInDollars, dateCreated, thumbnailData;

#pragma mark - NSManaged Object
- (void)awakeFromInsert
{
    [super awakeFromInsert];
    
    self.dateCreated = [NSDate date];
    
    // Create an NSUUID object - get its string representation
    NSUUID *uuid = [[NSUUID alloc] init];
    NSString *key = [uuid UUIDString];
    self.itemKey = key;
}
// Insert code here to add functionality to your managed object subclass
#pragma mark - other

- (void)setThumbnailFromImage:(UIImage *)image
{
    CGSize origImageSize = image.size;
    
    // The rectangle of the thumbnail
    CGRect rectOfThumbnail = CGRectMake(0,0,40,40);
    
    // Figure out a scaling ratio to make sure we maintain the same aspect ratio
    // This crops the image to make it retangular
    float ratio = MAX(rectOfThumbnail.size.width/origImageSize.width,
                      rectOfThumbnail.size.height/origImageSize.height);
    
    
    // Create a transparent bitmap context with a scaling factor
    // equal to that of the screen
    UIGraphicsBeginImageContextWithOptions(rectOfThumbnail.size, NO, 0.0);
    
    // Create a rounded rectangle path
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rectOfThumbnail cornerRadius:5.0];
    
    // Make all subsequent drawing clip to this rounded rectangle
    [path addClip];
    
    // Center the image in the thumbnail rectangle
    CGRect imageRect;
    imageRect.size.width = ratio * origImageSize.width;
    imageRect.size.height= ratio * origImageSize.height;
    imageRect.origin.x = (rectOfThumbnail.size.width - imageRect.size.width) / 2.0;
    imageRect.origin.y = (rectOfThumbnail.size.height - imageRect.size.height) / 2.0;
    
    
    // Draw the image on projectRect
    [image drawInRect:imageRect];
    
    // Get the image from the image context; keep as thumbnail
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    self.thumbnail = smallImage;
    
    // Clean up image context resources; we're done
    UIGraphicsEndImageContext();
}

@end
