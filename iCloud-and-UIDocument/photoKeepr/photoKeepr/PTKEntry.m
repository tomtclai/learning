//
//  PTKEntry.m
//  photoKeepr
//
//  Created by Tom Lai on 9/21/15.
//  Copyright © 2015 Lai. All rights reserved.
//

#import "PTKEntry.h"

@implementation PTKEntry
- (id)initWithFileURL:(NSURL *)fileURL metadata:(PTKMetadata *)metadata state:(UIDocumentState)state version:(NSFileVersion *)version {
    if (self = [super init]) {
        self.fileURL = fileURL;
        self.metadata = metadata;
        self.state = state;
        self.version = version;
    }
    return self;
}

- (NSString *)description {
    return [[self.fileURL lastPathComponent] stringByDeletingPathExtension];
}
@end
