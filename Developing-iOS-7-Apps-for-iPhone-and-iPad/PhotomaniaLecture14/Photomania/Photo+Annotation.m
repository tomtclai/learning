//
//  Photo+Annotation.m
//  Photomania
//
//  Created by Tom Lai on 9/11/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

#import "Photo+Annotation.h"

@implementation Photo (Annotation) 


- (CLLocationCoordinate2D) coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [self.latitude doubleValue];
    coordinate.longitude = [self.longitude doubleValue];
    return coordinate;
}
@end
