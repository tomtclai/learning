//  ImageSaver.m
//  Magical_Record
//  Copyright (c) 2013 Ray Wenderlich. All rights reserved.

#import "ImageSaver.h"
//#import "Beer.h"
//#import "BeerDetails.h"

@implementation ImageSaver

+ (BOOL)saveImageToDisk:(UIImage*)image andToBeer:(Beer*)beer {
	NSData *imgData   = UIImageJPEGRepresentation(image, 0.5);
	NSString *name    = [[NSUUID UUID] UUIDString];
	NSString *path	  = [NSString stringWithFormat:@"Documents/%@.jpg", name];
	NSString *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:path];
	if ([imgData writeToFile:jpgPath atomically:YES]) {
//		beer.beerDetails.image = path;
	} else {
		[[[UIAlertView alloc] initWithTitle:@"Error"
									message:@"There was an error saving your photo. Try again."
								   delegate:nil
						  cancelButtonTitle:@"OK"
						  otherButtonTitles: nil] show];
		return NO;
	}
	return YES;
}

+ (void)deleteImageAtPath:(NSString *)path {
	NSError *error;
	NSString *imgToRemove = [NSHomeDirectory() stringByAppendingPathComponent:path];
	[[NSFileManager defaultManager] removeItemAtPath:imgToRemove error:&error];
}

@end
