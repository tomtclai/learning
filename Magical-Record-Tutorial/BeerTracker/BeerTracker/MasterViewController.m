//  MasterViewController.m
//  BeerTracker
//  Copyright (c) 2013 Ray Wenderlich. All rights reserved.

#import "MasterViewController.h"
#import "AMRating/AMRatingControl.h"
#import "BeerViewController.h"
#import "ImageSaver.h"

@interface MasterViewController ()<UISearchBarDelegate>
@property (nonatomic) NSMutableArray *beers;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@end

NSString * const SORT_KEY_NAME   = @"name";
NSString * const SORT_KEY_RATING = @"beerDetails.rating";
NSString * const WB_SORT_KEY     = @"WB_SORT_KEY";

@implementation MasterViewController

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	// Check if the user's sort preference has been saved.
	if (![[NSUserDefaults standardUserDefaults] objectForKey:WB_SORT_KEY]) {
		[[NSUserDefaults standardUserDefaults] setObject:SORT_KEY_RATING forKey:WB_SORT_KEY];
	}
	if ([[[NSUserDefaults standardUserDefaults] objectForKey:WB_SORT_KEY] isEqualToString:SORT_KEY_NAME]) {
		self.segmentedControl.selectedSegmentIndex = 1;
	}
	[self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.tableView.contentOffset = CGPointMake(0, 44);
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	BeerViewController *upcoming = segue.destinationViewController;
    if ([[segue identifier] isEqualToString:@"editBeer"]) {
    
	} else if ([segue.identifier isEqualToString:@"addBeer"]) {
		upcoming.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonSystemItemCancel target:upcoming action:@selector(cancelAdd)];
		upcoming.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonSystemItemAdd target:upcoming action:@selector(addNewBeer)];
	}
}

- (void)fetchAllBeers {

}

- (void)saveContext {

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.beers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"
															forIndexPath:indexPath];
	[self configureCell:cell atIndex:indexPath];
	return cell;
}

- (void)configureCell:(UITableViewCell*)cell atIndex:(NSIndexPath*)indexPath {

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {

    }
}

#pragma mark - Search Bar Delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
	if ([self.searchBar.text length] > 0) {
		[self doSearch];
	} else {
		[self fetchAllBeers];
		[self.tableView reloadData];
	}
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	[self.searchBar resignFirstResponder];
	// Clear search bar text
	self.searchBar.text = @"";
	// Hide the cancel button
	self.searchBar.showsCancelButton = NO;
	// Do a default fetch of the beers
	[self fetchAllBeers];
	[self.tableView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
	self.searchBar.showsCancelButton = YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[self.searchBar resignFirstResponder];
	[self doSearch];
}

- (void)doSearch {
	[self.tableView reloadData];
}

// Change the sort key used when fetching object.
- (IBAction)changeSortKey:(id)sender {
	switch ([(UISegmentedControl*)sender selectedSegmentIndex]) {
		case 0: {
			[[NSUserDefaults standardUserDefaults] setObject:SORT_KEY_RATING forKey:WB_SORT_KEY];
			[self fetchAllBeers];
			[self.tableView reloadData];
		}
			break;
		case 1: {
			[[NSUserDefaults standardUserDefaults] setObject:SORT_KEY_NAME forKey:WB_SORT_KEY];
			[self fetchAllBeers];
			[self.tableView reloadData];
		}
			break;
		default:
			break;
	}
}

@end
