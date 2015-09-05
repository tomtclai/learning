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
#import "TopPhotosFromPlaceViewController.h"
@interface TopPlacesTableViewController ()
@property (nonatomic, strong) NSArray * placesData; // from JSON
@property (nonatomic, strong) NSMutableArray * fetchedCities; // array of citiess
@property (nonatomic, strong) NSMutableDictionary * citiesByCountry; // NSString : Array of cities
@property (nonatomic, strong) NSIndexPath * selectedIndexPath;
@end

@implementation TopPlacesTableViewController
- (NSMutableDictionary *)citiesByCountry {
    if (!_citiesByCountry)
    {
        _citiesByCountry = [NSMutableDictionary dictionary];
    }
    return _citiesByCountry;
}
- (NSMutableArray*) fetchedCities {
    if (!_fetchedCities)
    {
        _fetchedCities = [NSMutableArray array];
    }
    return _fetchedCities;
}

- (NSArray*) placesData {
    if (!_placesData)
    {
        _placesData = [NSArray array];
    }
    return _placesData;
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
    return self.citiesByCountry.allKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *key = self.citiesByCountry.allKeys[section];
    NSArray *cities = self.citiesByCountry[key];
    return cities.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.citiesByCountry.allKeys[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = self.citiesByCountry.allKeys[indexPath.section];
    NSArray *cities = self.citiesByCountry[key];
    City *city =  cities[indexPath.row];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"mostViewPlaces"];
    cell.textLabel.text = city.name;
    cell.detailTextLabel.text = city.restOfAddress;
    return cell;
}
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexPath = indexPath;
    return indexPath;
}
- (IBAction)fetchURLforTopPlaces
{
    [self.refreshControl beginRefreshing];
    self.fetchedCities = nil;
    NSURL *url = [FlickrFetcher URLforTopPlaces];
    dispatch_queue_t fetchQ = dispatch_queue_create("flickr top places fetcher", NULL);
    dispatch_async(fetchQ, ^{
        NSData *jsonResults = [NSData dataWithContentsOfURL:url];
        NSDictionary *propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResults
                                                                            options:0
                                                                              error:NULL];
        
        self.placesData = [propertyListResults valueForKeyPath:FLICKR_RESULTS_PLACES];

        dispatch_async(dispatch_get_main_queue(), ^{
            for (NSDictionary *place in self.placesData) {
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
                city.country = countryName;
                city.restOfAddress = restOftheAddress;
                
                [self.fetchedCities addObject:city];
            }
            
            [self groupCitiesByCountry];
        });
    });
}

- (void)groupCitiesByCountry {
    self.citiesByCountry = nil;
    for (City *city in self.fetchedCities) {
        if (self.citiesByCountry[city.country] == nil)
        {
            NSMutableArray *cities = [NSMutableArray arrayWithObject:city];
            self.citiesByCountry[city.country] = cities;
        } else {
            
            [self.citiesByCountry[city.country] addObject:city];
        }
    }
    NSLog(@"%@",self.citiesByCountry);
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString: @"topPhotosFromPlace"])
    {
        TopPhotosFromPlaceViewController* tpfpvc = segue.destinationViewController;
        NSString *key = self.citiesByCountry.allKeys[self.selectedIndexPath.section];
        NSArray *cities = self.citiesByCountry[key];
        City *city =  cities[self.selectedIndexPath.row];
        tpfpvc.flickrID = city.flickrPlaceId;
        tpfpvc.navigationItem.title = city.name;
        self.selectedIndexPath = nil;
    }
}


@end
