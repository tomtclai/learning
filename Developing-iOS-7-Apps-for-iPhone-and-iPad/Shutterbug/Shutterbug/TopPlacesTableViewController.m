//
//  TopPlacesTableViewController.m
//  Shutterbug
//
//  Created by Tom Lai on 8/31/15.
//  Copyright (c) 2015 Tom Lai. All rights reserved.
//

#import "TopPlacesTableViewController.h"
#import "FlickrFetcher.h"
#import "City.h"
@interface TopPlacesTableViewController ()
@property (nonatomic, strong) NSArray * topPlaces;
@property (nonatomic, strong) NSMutableArray * topPlacesDataSource;
@end

@implementation TopPlacesTableViewController
- (NSMutableArray*) topPlacesDataSource {
    if (!_topPlacesDataSource)
    {
        _topPlacesDataSource = [NSMutableArray array];
    }
    return _topPlacesDataSource;
}

- (NSArray*) topPlaces {
    if (!_topPlaces)
    {
        _topPlaces = [NSArray array];
    }
    return _topPlaces;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self fetchURLforTopPlaces];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}
- (void)fetchURLforTopPlaces
{
    NSURL *url = [FlickrFetcher URLforTopPlaces];
    dispatch_queue_t fetchQ = dispatch_queue_create("flickr top places fetcher", NULL);
    dispatch_async(fetchQ, ^{
        NSData *jsonResults = [NSData dataWithContentsOfURL:url];
        NSDictionary *propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResults
                                                                            options:0
                                                                              error:NULL];
        
        self.topPlaces = [propertyListResults valueForKeyPath:FLICKR_RESULTS_PLACES];
//        NSLog(@"%@",self.topPlaces);

        dispatch_async(dispatch_get_main_queue(), ^{
            for (NSDictionary *place in self.topPlaces) {
                NSString *address = place[@"_content"];
                NSArray *addressComponents = [address componentsSeparatedByString:@", "];
                
                NSString *placeId = place[@"place_id"];
                NSString *cityName = [addressComponents firstObject];
                NSString *countryName = [addressComponents lastObject];
                NSMutableString *restOftheAddress = [NSMutableString stringWithString:addressComponents[1]];
                
                for (int i = 2; i < addressComponents.count - 1 ; i++) {
                    [restOftheAddress appendFormat:@", %@", addressComponents[i]];
                }
                
                City *city = [[City alloc]init];
                city.flickrPlaceId = placeId;
                city.name = cityName;
                city.countryName = countryName;
                city.restOfAddress = restOftheAddress;
                
                [self.topPlacesDataSource addObject:city];
            }
            NSLog(@"%@",self.topPlacesDataSource);
        });
    });
    
   
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
