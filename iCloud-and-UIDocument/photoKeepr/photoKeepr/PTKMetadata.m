//
//  PTKMetadata.m
//  photoKeepr
//
//  Created by Tom Lai on 9/20/15.
//  Copyright © 2015 Lai. All rights reserved.
//

#import "PTKMetadata.h"

@implementation PTKMetadata
@synthesize thumbnail = _thumbnail;

- (id)initWithThumbnail: (UIImage *)thumbnail {
    if ((self = [super init])) {
        self.thumbnail = thumbnail;
    }
    return self;
}

- (id)init {
    return [self initWithThumbnail:nil];
}

#pragma mark NSCoding

#define kVersionKey @"Version"
#define kThumbnailKey @"Thumbnail"

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInt:1 forKey:kVersionKey];
    NSData *thumbnailData = UIImagePNGRepresentation(self.thumbnail);
    [aCoder encodeObject:thumbnailData forKey:kThumbnailKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    [aDecoder decodeIntForKey:kVersionKey];
    NSData * thumbnailData = [aDecoder decodeObjectForKey:kThumbnailKey];
    UIImage * thumbnail = [UIImage imageWithData:thumbnailData];
    return [self initWithThumbnail:thumbnail];
}
@end
