//
//  PTKDocument.h
//  photoKeepr
//
//  Created by Tom Lai on 9/20/15.
//  Copyright © 2015 Lai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PTKData;
@class PTKMetadata;

#define PTK_EXTENSION @"ptk"

@interface PTKDocument : UIDocument

// Data
- (UIImage *)photo;
- (void) setPhoto:(UIImage *)photo;

// Metadata
@property (nonatomic, strong) PTKMetadata *metadata;
- (NSString *) description;

@end
