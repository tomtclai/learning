//
//  Photo+CoreDataProperties.h
//  Photomania
//
//  Created by Tom Lai on 9/11/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Photographer.h"

NS_ASSUME_NONNULL_BEGIN

@interface Photo : NSManagedObject

@property (nullable, nonatomic, retain) NSString *imageURL;
@property (nullable, nonatomic, retain) NSString *subtitle;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *unique;
@property (nullable, nonatomic, retain) NSNumber *latitude;
@property (nullable, nonatomic, retain) NSNumber *longitude;
@property (nullable, nonatomic, retain) NSString *thumbnailURL;
@property (nullable, nonatomic, retain) Photographer *whoTook;

@end

NS_ASSUME_NONNULL_END
