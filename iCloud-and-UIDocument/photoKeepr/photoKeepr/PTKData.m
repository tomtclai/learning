//
//  PTKData.m
//  photoKeepr
//
//  Created by Tom Lai on 9/20/15.
//  Copyright © 2015 Lai. All rights reserved.
//

#import "PTKData.h"

@implementation PTKData

- (id)initWithPhoto:(UIImage *)photo {
    if ((self = [super init])) {
        self.photo = photo;
    }
    return self;
}

- (id)init {
    return [self initWithPhoto:nil];
}

#pragma mark NSCoding
#define kVersionKey @"version"
#define kPhotoKey @"Photo"

- (void)encodeWithCoder:(NSCoder *)aCoder {
    //if you add a new field, you bump up the version number
    [aCoder encodeInt:1 forKey:kVersionKey];
    [aCoder encodeObject:UIImagePNGRepresentation(self.photo) forKey:kPhotoKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    [aDecoder decodeIntForKey:kVersionKey];
    NSData *data = [aDecoder decodeObjectForKey:kPhotoKey];
    UIImage *photo = [UIImage imageWithData:data];
    return [self initWithPhoto:photo];
}
@end
