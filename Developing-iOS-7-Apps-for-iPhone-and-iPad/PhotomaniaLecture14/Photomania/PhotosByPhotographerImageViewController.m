//
//  PhotosByPhotographerImageViewController.m
//  Photomania
//
//  Created by Tom Lai on 9/11/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

#import "PhotosByPhotographerImageViewController.h"
#import "PhotosByPhotographerMapViewController.h"
@interface PhotosByPhotographerImageViewController ()
@property (nonatomic, strong)PhotosByPhotographerMapViewController *mapvc;
@end
@implementation PhotosByPhotographerImageViewController

- (void)setPhotographer:(Photographer *)photographer
{
    _photographer = photographer;
    self.title = photographer.name;
    self.mapvc.photographer = self.photographer;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[PhotosByPhotographerMapViewController class]]) {
        PhotosByPhotographerMapViewController *pbpmapvc = (PhotosByPhotographerMapViewController *)segue.destinationViewController;
        
        pbpmapvc.photographer = self.photographer;
        self.mapvc = pbpmapvc;
    } else {
        [super prepareForSegue:segue sender:sender];
    }
}
@end
