//
//  PTKDocument.m
//  photoKeepr
//
//  Created by Tom Lai on 9/20/15.
//  Copyright © 2015 Lai. All rights reserved.
//

#import "PTKDocument.h"
#import "PTKData.h"
#import "PTKMetadata.h"
#import "UIImageExtras/UIImageExtras.h"

#define METADATA_FILENAME @"photo.metadata"
#define DATA_FILENAME @"photo.data"
@interface PTKDocument ()
@property (nonatomic, strong) PTKData *data;
@property (nonatomic, strong) NSFileWrapper *fileWrapper;
@end
@implementation PTKDocument
//@synthesize data = _data;
//@synthesize fileWrapper = _fileWrapper;
//@synthesize metadata = _metadata;

- (void)encodeObject:(id<NSCoding>)object toWrappers:(NSMutableDictionary *)wrappers preferredFileName:(NSString *)preferredFilename {
    NSMutableData * data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:object forKey:@"data"];
    [archiver finishEncoding];
    NSFileWrapper * wrapper = [[NSFileWrapper alloc] initRegularFileWithContents:data];
    [wrappers setObject:wrapper forKey:preferredFilename];
}

- (id)contentsForType:(NSString *)typeName error:(NSError * _Nullable __autoreleasing *)outError
{
    if (self.metadata == nil || self.data == nil) {
        return nil;
    }
    
    NSMutableDictionary * wrappers = [NSMutableDictionary dictionary];
    [self encodeObject:self.metadata toWrappers:wrappers preferredFileName:METADATA_FILENAME];
    [self encodeObject:self.data toWrappers:wrappers preferredFileName:DATA_FILENAME];
    NSFileWrapper * fileWrapper = [[NSFileWrapper alloc] initDirectoryWithFileWrappers:wrappers];
    
    return fileWrapper;
}
@end
