//
//  TopPhotosFromPlaceViewController.m
//  Shutterbug
//
//  Created by Tom Lai on 9/3/15.
//  Copyright (c) 2015 Tom Lai. All rights reserved.
//

#import "TopPhotosFromPlaceViewController.h"
#import "FlickrFetcher.h"

@interface TopPhotosFromPlaceViewController ()

@end

@implementation TopPhotosFromPlaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchPhotos];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)fetchPhotos
{
//    [self.refreshControl beginRefreshing];
//    NSURL *url = [FlickrFetcher URLforPhotosInPlace:self.flickrID maxResults:50];
//    dispatch_queue_t fetchQ = dispatch_queue_create("flickr photo fetcher", NULL);
//    dispatch_async(fetchQ, ^{
//        NSData *jsonResults = [NSData dataWithContentsOfURL:url];
//        NSDictionary *propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResults
//                                                                            options:0
//                                                                              error:NULL];
//        NSArray *photos = [propertyListResults valueForKeyPath:FLICKR_RESULTS_PHOTOS];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSLog(@"%@", propertyListResults);
//            self.photos = photos;
//            [self.refreshControl endRefreshing];
//        });
//    });
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
