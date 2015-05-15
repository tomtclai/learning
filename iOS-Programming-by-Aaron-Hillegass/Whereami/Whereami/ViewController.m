//
//  ViewController.m
//  Whereami
//
//  Created by Tsz Chun Lai on 2/15/15.
//  Copyright (c) 2015 BNR. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Create location manager object
        locationManager = [[CLLocationManager alloc] init];
        
        [locationManager setDelegate:self];
        
        // And we want it to be as accurate as possible
        // Regardless of how much time/ power it takes
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        
        // Tell our manager to start looking for its location immediately
        [locationManager startUpdatingLocation];
    }
    
    return self;
}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view, typically from a nib.
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"%@", newLocation);
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"Could not find location: %@", error);
}
@end
