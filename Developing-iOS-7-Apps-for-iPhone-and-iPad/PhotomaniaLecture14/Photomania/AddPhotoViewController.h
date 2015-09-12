//
//  AddPhotoViewController.h
//  Photomania
//
//  Created by Tom Lai on 9/12/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photographer.h"
#import "Photo.h"
@interface AddPhotoViewController : UIViewController
// in
@property (nonatomic, strong) Photographer *photographerTakingPhoto;

// out
@property (nonatomic, strong, readonly) Photo *addedPhoto;
@end
