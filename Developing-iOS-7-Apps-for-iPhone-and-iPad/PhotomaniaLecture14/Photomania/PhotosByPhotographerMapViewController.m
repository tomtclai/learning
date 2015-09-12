//
//  PhotosByPhotographerMapViewController.m
//  Photomania
//
//  Created by Tom Lai on 9/11/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

#import "PhotosByPhotographerMapViewController.h"
#import "Photo+Annotation.h"
#import "ImageViewController.h"
@import MapKit;
@interface PhotosByPhotographerMapViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) NSArray<Photo*> *photosByPhotographer; // of photo
@property (nonatomic)  ImageViewController *imageViewController;
@end

@implementation PhotosByPhotographerMapViewController
- (ImageViewController *)imageViewController
{
    // for ipad
    id detailvc = [self.splitViewController.viewControllers lastObject];
    if ([detailvc isKindOfClass:[UINavigationController class]]) {
        detailvc = [((UINavigationController *)detailvc).viewControllers firstObject];
    }
    return [detailvc isKindOfClass:[ImageViewController class]]? detailvc : nil;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *reuseID = @"PhotosByPhotographerMapViewController";
    MKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseID];
    
    if (!view) {
        view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                               reuseIdentifier:reuseID];
        view.canShowCallout = YES;
        
        if (!self.imageViewController) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 46, 46)];
            view.leftCalloutAccessoryView = imageView;
            
            UIButton *disclousureButton = [[UIButton alloc] init];
            [disclousureButton setBackgroundImage:[UIImage imageNamed:@"disclosure"] forState:UIControlStateNormal];
            [disclousureButton sizeToFit];
            view.rightCalloutAccessoryView = disclousureButton;
        }
    }
    
    view.annotation = annotation;
    return view;
}
// checks to be sure that the annotationView's left callout is a UIImageView
// if it is and if the annotation is a Photo, then shows the thumbnail
// this should do that fetch in another thread
// but when the thumbnail image came back, it would need to double check the annotationView
// to be sure it is still displaying the annotation for which we fetched
// (because MKAnnotationViews, like UITableViewCells, are reused)

- (void)updateLeftCalloutAccessoryViewInAnnotationView:(MKAnnotationView *)annotationView
{
    UIImageView *imageView = nil;
    if ([annotationView.leftCalloutAccessoryView isKindOfClass:[UIImageView class]]) {
        imageView = (UIImageView *)annotationView.leftCalloutAccessoryView;
    }
    if (imageView) {
        Photo *photo = nil;
        if ([annotationView.annotation isKindOfClass:[Photo class]]) {
            photo = (Photo *)annotationView.annotation;
        }
        if (photo) {
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:photo.thumbnailURL]];
            NSURLSessionConfiguration *defaultConfig = [NSURLSessionConfiguration ephemeralSessionConfiguration];
            NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfig];
            
            
            NSURLSessionDownloadTask *task = [defaultSession downloadTaskWithRequest:request
                                              completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                  UIImage *image =  [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      imageView.image = image;
                                                  });
                                              }];
            [task resume];
        }
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"showPhoto" sender:view];
}

#pragma mark - Navigation
- (void)prepareViewController:(id)vc forSegue: (NSString *)segueIdentifier toShowAnnotaion:(id <MKAnnotation>) annotation
{
    Photo *photo = nil;
    if ([annotation isKindOfClass:[Photo class]]) {
        photo = (Photo *)annotation;
    }
    if (photo) {
        if (![segueIdentifier length] || [segueIdentifier isEqualToString:@"showPhoto"]) {
            if ([vc isKindOfClass:[ImageViewController class]]) {
                ImageViewController *ivc = (ImageViewController *)vc;
                ivc.imageURL = [NSURL URLWithString:photo.imageURL];
                ivc.title = photo.title;
            }
        }
    }


}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[MKAnnotationView class]]) {
        [self prepareViewController:segue.destinationViewController
                           forSegue:segue.identifier
                    toShowAnnotaion:((MKAnnotationView *)sender).annotation];
    }
}


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if (self.imageViewController)
    {
        [self prepareViewController:self.imageViewController
                           forSegue:nil
                    toShowAnnotaion:view.annotation];
    } else {
        [self updateLeftCalloutAccessoryViewInAnnotationView:view];
    }
}
- (void)updateMapViewAnnotations
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:self.photosByPhotographer];
    [self.mapView showAnnotations:self.photosByPhotographer animated:YES];
    
    if (self.imageViewController) {
        Photo *autoselectedPhoto = [self.photosByPhotographer firstObject];
        if (autoselectedPhoto) {
            [self.mapView selectAnnotation:autoselectedPhoto animated:YES];
            // because didSelect don't get called here
            [self prepareViewController:self.imageViewController
                               forSegue:nil
                        toShowAnnotaion:autoselectedPhoto];
        }
    }
}
- (void)setMapView:(MKMapView *)mapView
{
    _mapView = mapView;
    self.mapView.delegate = self;
    [self updateMapViewAnnotations];
}



- (void)setPhotographer:(Photographer *)photographer
{
    _photographer = photographer;
    self.title = photographer.name;

    // lazy fetch
    self.photosByPhotographer = nil;
    [self updateMapViewAnnotations];
}

- (NSArray *)photosByPhotographer
{
    if (!_photosByPhotographer) {
        // fetch photos from database
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
        request.predicate = [NSPredicate predicateWithFormat:@"whoTook = %@", self.photographer];
        _photosByPhotographer = [self.photographer.managedObjectContext executeFetchRequest:request
                                                                                      error:NULL];
    }
    return _photosByPhotographer;
}
@end
