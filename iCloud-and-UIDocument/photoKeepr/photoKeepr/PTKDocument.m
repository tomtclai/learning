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

#pragma mark -
#pragma mark writing

- (void)encodeObject:(id<NSCoding>)object toWrappers:(NSMutableDictionary *)wrappers preferredFileName:(NSString *)preferredFilename {
    NSMutableData * data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:object forKey:@"data"];
    [archiver finishEncoding];
    NSFileWrapper * wrapper = [[NSFileWrapper alloc] initRegularFileWithContents:data];
    [wrappers setObject:wrapper forKey:preferredFilename];
}

- (id)contentsForType:(NSString *)typeName error:(NSError * _Nullable __autoreleasing *)outError {
    if (self.metadata == nil || self.data == nil) {
        return nil;
    }
    // To create a directory NSFileWrapper, you call initDirectoryWithFileWrapper and pass in a dictionary
    // that contains file NSFileWrapper as the objects, and the names of the files as the key.
    NSMutableDictionary * wrappers = [NSMutableDictionary dictionary];
    [self encodeObject:self.metadata toWrappers:wrappers preferredFileName:METADATA_FILENAME];
    [self encodeObject:self.data toWrappers:wrappers preferredFileName:DATA_FILENAME];
    NSFileWrapper * fileWrapper = [[NSFileWrapper alloc] initDirectoryWithFileWrappers:wrappers];
    
    return fileWrapper;
}

#pragma mark -
#pragma mark reading
- (id)decodeObjectWrapperWithPreferredFilename:(NSString *)preferredFilename {
    NSFileWrapper * fileWrapper = [self.fileWrapper.fileWrappers objectForKey:preferredFilename];
    if (!fileWrapper) {
        NSLog(@"Cnexpected error: Couldn't find %@ in file wrapper", preferredFilename);
        return nil;
    }
    
    NSData * data = [fileWrapper regularFileContents];
    NSKeyedUnarchiver * unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    
    return [unarchiver decodeObjectForKey:@"data"];
}

- (PTKMetadata *)metadata {
    if (_metadata == nil) {
        if (self.fileWrapper != nil) {
            NSLog(@"Loading meta data for %@", self.fileURL);
            self.metadata = [self decodeObjectWrapperWithPreferredFilename:METADATA_FILENAME];
        } else {
            self.metadata = [PTKMetadata new];
        }
    }
    return _metadata;
}

- (PTKData *)data {
    if (_data == nil) {
        if (self.fileWrapper != nil) {
            self.data = [self decodeObjectWrapperWithPreferredFilename:DATA_FILENAME];
        } else {
            self.data = [PTKData new];
        }
    }
    return _data;
}

- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError * _Nullable __autoreleasing *)outError {
    self.fileWrapper = (NSFileWrapper *) contents;
    
    // These will be lazy loaded
    self.data = nil;
    self.metadata = nil;
    
    return YES;
}

- (NSString *)description {
    return [[self.fileURL lastPathComponent] stringByDeletingPathExtension];
}

#pragma mark Accessors
- (void)setPhoto:(UIImage *)photo {
    if ([self.data.photo isEqual:photo]) return;
    UIImage * oldPhoto = self.data.photo;
    self.data.photo = photo;
    self.metadata.thumbnail = [self.data.photo imageByScalingAndCroppingForSize:CGSizeMake(145, 145)];
    
    [self.undoManager setActionName:@"Image Change"];
    [self.undoManager registerUndoWithTarget:self selector:@selector(setPhoto:) object:oldPhoto]; // WOW.
}
@end
