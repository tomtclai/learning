//
//  documentHandler.m
//  Shutterbug
//
//  Created by Tom Lai on 9/8/15.
//  Copyright (c) 2015 Tom Lai. All rights reserved.
//

#import "DocumentHandler.h"
@interface DocumentHandler ()
- (void)objectsDidChange:(NSNotification *)notification;
- (void)contextDidSave:(NSNotification *)notification;
@end


@implementation DocumentHandler

@synthesize document = _document;

static DocumentHandler *_sharedInstance;

+ (DocumentHandler *)sharedDocumentHandler
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}


- (id)init
{
    self = [super init];
    if (self) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSURL *documentsDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
        NSString *documentName = @"Shutterbug";
        // this creates the UIManagedDocument instance, but does not open nor create the underlying file
        NSURL *url = [documentsDirectory URLByAppendingPathComponent:documentName];
        UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(objectsDidChange:)
                                                     name:NSManagedObjectContextObjectsDidChangeNotification
                                                   object:self.document.managedObjectContext];
//        // Open / create the underlying file
//        self.document = document;
//        if ([[NSFileManager defaultManager]fileExistsAtPath:[url path]]) {
//            [document openWithCompletionHandler:^(BOOL success) {
//                if (success) [self documentIsReady];
//            }];
//        } else {
//            [document saveToURL:url
//               forSaveOperation:UIDocumentSaveForCreating
//              completionHandler:^(BOOL success) {
//                  if (success) [self documentIsReady];
//              }];
//        }
    }
    return self;
}

- (void)performWithDocument:(OnDocumentReady)onDocumentReady
{
    void (^OnDocumentDidLoad)(BOOL) = ^(BOOL success) {
        onDocumentReady(self.document);
    };
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.document.fileURL path]]) {
        [self.document saveToURL:self.document.fileURL
                forSaveOperation:UIDocumentSaveForCreating
               completionHandler:OnDocumentDidLoad];
    }
}

- (void)objectsDidChange:(NSNotification *)notification
{
    NSLog(@"NSmanagedObjects did change");
}

- (void)contextDidSave:(NSNotification *)notification
{
    NSLog(@"NSManagedContext did save");
}
@end
