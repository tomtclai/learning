//
//  PhotosByPhotographerImageViewController.h
//  Photomania
//
//  Created by Tom Lai on 9/11/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

#import "ImageViewController.h"
#import "Photographer.h"

@interface PhotosByPhotographerImageViewController : ImageViewController
@property (nonatomic, strong) Photographer *photographer;

@end
