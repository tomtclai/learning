//
//  BNRItem.m
//  RandomPossessions
//
//  Created by Tsz Chun Lai on 2/7/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#import "BNRItemOld.h"

@implementation BNRItemOld

@synthesize itemName, serialNumber,valueInDollars, dateCreated;

# pragma mark - Init
- (id)initWithItemName:(NSString *)name
        valueInDollars:(int)value
          serialNumber:(NSString *)sNumber
{
    // Call the superclass's designated initializer
    self = [super init];

    if (self) {
        // Give the instance variables initial values
        [self setItemName:name];
        [self setSerialNumber:sNumber];
        [self setValueInDollars:value];

        dateCreated = [[NSDate alloc] init];

        // Create an NSUUID object - get its string representation
        NSUUID *uuid = [[NSUUID alloc] init];
        NSString *key = [uuid UUIDString];
        self.itemKey = key;
    }
    // Return the address of the newly initilized object
    return self;
}

- (id)init
{
    return [self initWithItemName:@""
                   valueInDollars:0
                     serialNumber:@""];
}

- (id)initWithItemName:(NSString *)name
          serialNumber:(NSString *)sNumber
{
    return [self initWithItemName:name
                   valueInDollars:0
                     serialNumber:sNumber];
}

#pragma mark - accessor

- (NSString *)description
{
    NSString *descriptionString =
    [[NSString alloc] initWithFormat:@"%@ (%@): Worth $%d, recorded on %@",
     itemName,
     serialNumber,
     valueInDollars,
     dateCreated];

    return descriptionString;
}

+ (id)randomItem
{
    // Create an array of three adjectives
    NSArray *randomAdjectiveList = [NSArray arrayWithObjects:@"Fluffy",
                                                              @"Rusty",
                                                              @"Shiny", nil];
    // Create an array of three nouns
    NSArray *randomNounList = [NSArray arrayWithObjects:@"Bear",
                               @"Spork",
                               @"Mac", nil];

    // Get the index of a random adjective/nount from the lists
    NSInteger adjectiveIndex =  rand() % [randomAdjectiveList count];
    NSInteger nounIndex      =  rand() % [randomNounList count];

    // Note that NSINteger is not an object, but a type definition
    // for "unsiged long"

     NSString *randomName = [NSString stringWithFormat:@"%@ %@",
                             [randomAdjectiveList objectAtIndex:adjectiveIndex],
                             [randomNounList objectAtIndex:nounIndex]];

    int randomValue = rand() % 100;
    NSString *randomSerialNumber = [NSString stringWithFormat:@"%c%c%c%c%c",
                                    '0' + rand() % 10,
                                    'A' + rand() % 26,
                                    '0' + rand() % 10,
                                    'A' + rand() % 26,
                                    '0' + rand() % 10];

    BNRItem *newItem = [[self alloc] initWithItemName:randomName
                                       valueInDollars:randomValue
                                         serialNumber:randomSerialNumber];

    return newItem;
}

#pragma mark - dealloc
- (void)dealloc
{
    NSLog(@"Destroyed :%@", self);
}
#pragma mark - coder
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.itemName forKey:@"itemName"];
    [aCoder encodeObject:self.serialNumber forKey:@"serialNumber"];
    [aCoder encodeObject:self.dateCreated  forKey:@"dateCreated"];
    [aCoder encodeObject:self.itemKey forKey:@"itemKey"];
    [aCoder encodeInt:self.valueInDollars forKey:@"valueInDollars"];
    [aCoder encodeObject:self.thumbnail forKey:@"thumbnail"];
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        itemName = [aDecoder decodeObjectForKey:@"itemName"];
        serialNumber = [aDecoder decodeObjectForKey:@"serialNumber"];
        dateCreated = [aDecoder decodeObjectForKey:@"dateCreated"];
        self.itemKey = [aDecoder decodeObjectForKey:@"itemKey"];
        valueInDollars = [aDecoder decodeIntForKey:@"valueInDollars"];;
        self.thumbnail = [aDecoder decodeObjectForKey:@"thumbnail"];
        
    }
    return self;
}
#pragma mark - other

- (void)setThumbnailFromImage:(UIImage *)image
{
    CGSize origImageSize = image.size;
    
    // The rectangle of the thumbnail
    CGRect rectOfThumbnail = CGRectMake(0,0,40,40);
    
    // Figure out a scaling ratio to make sure we maintain the same aspect ratio
    // This crops the image to make it retangular
    float ratio = MAX(rectOfThumbnail.size.width/origImageSize.width,
                      rectOfThumbnail.size.height/origImageSize.height);
    
    
    // Create a transparent bitmap context with a scaling factor
    // equal to that of the screen
    UIGraphicsBeginImageContextWithOptions(rectOfThumbnail.size, NO, 0.0);
    
    // Create a rounded rectangle path
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rectOfThumbnail cornerRadius:5.0];
    
    // Make all subsequent drawing clip to this rounded rectangle
    [path addClip];
    
    // Center the image in the thumbnail rectangle
    CGRect imageRect;
    imageRect.size.width = ratio * origImageSize.width;
    imageRect.size.height= ratio * origImageSize.height;
    imageRect.origin.x = (rectOfThumbnail.size.width - imageRect.size.width) / 2.0;
    imageRect.origin.y = (rectOfThumbnail.size.height - imageRect.size.height) / 2.0;
    
    
    // Draw the image on projectRect
    [image drawInRect:imageRect];
    
    // Get the image from the image context; keep as thumbnail
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    self.thumbnail = smallImage;
    
    // Clean up image context resources; we're done
    UIGraphicsEndImageContext();
}

@end
