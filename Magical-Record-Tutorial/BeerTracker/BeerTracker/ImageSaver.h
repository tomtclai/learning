//  ImageSaver.h
//  Magical_Record
//  Copyright (c) 2013 Ray Wenderlich. All rights reserved.

#import <Foundation/Foundation.h>
@class Beer;

@interface ImageSaver : NSObject

+ (BOOL)saveImageToDisk:(UIImage*)image andToBeer:(Beer*)beer;
+ (void)deleteImageAtPath:(NSString*)path;
@end
