//
//  BNRCoursesViewController.m
//  Nerdfeed
//
//  Created by Tom Lai on 6/14/15.
//  Copyright © 2015 Big Nerd Ranch. All rights reserved.
//

#import "BNRWebViewController.h"
#import "BNRCoursesViewController.h"
#import "BNRCoursesTableViewCell.h"
@interface BNRCoursesViewController () <NSURLSessionDataDelegate>


@property (nonatomic) NSURLSession *session;
@property (nonatomic, copy) NSArray *courses;

@end

@implementation BNRCoursesViewController

#pragma mark - init
- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.navigationItem.title = @"BNR Courses";
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        _session = [NSURLSession sessionWithConfiguration:config
                                                 delegate:self
                                            delegateQueue:nil];
        
        [self fetchFeed];
    }
    return self;
}

- (void)fetchFeed
{
    NSString *requestString = @"https://bookapi.bignerdranch.com/private/courses.json";
    NSURL *url = [NSURL URLWithString:requestString];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:req
                                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                         NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                                                                                    options:0
                                                                                                                      error:nil];
                                                         self.courses = jsonObject[@"courses"];
                                                         NSLog(@"%@",self.courses);
                                                         
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                             [self.tableView reloadData];
                                                         });
                                                     }
                                      ];
    [dataTask resume];
}
#pragma mark - Table View
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.courses count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    BNRCoursesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BNRCoursesTableViewCell"
                                                            forIndexPath:indexPath];

    if (cell==nil) {
        cell = [[BNRCoursesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:@"BNRCoursesTableViewCell"];
    }
    NSDictionary *course = self.courses[indexPath.row];
    cell.course.text = course[@"title"];
    
    NSMutableString *upcomingLabelText = [[NSMutableString alloc]initWithString:@"Upcoming: "];
    
    
    if ([course[@"upcoming"] count] != 0)
    {
        // JSON serialized data. Used [0] because we are accessing an array, not dictionary
        // in that particular level. Their types looks like this:
        // NSDictionary[@"upcoming"] -> NSArray[0] -> NSDictionary[@"start_date"]
        [upcomingLabelText appendString:course[@"upcoming"] [0] [@"start_date"]];
        
    } else
    {
        [upcomingLabelText appendString:@"--"];
    }
    cell.upcoming.text = upcomingLabelText;
    return cell;
}

- (void)tableView:(nonnull UITableView *)tableView
didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    NSDictionary *course = self.courses[indexPath.row];
    NSURL *URL = [NSURL URLWithString:course[@"url"]];
    
    self.webViewController.title = course[@"title"];
    self.webViewController.URL = URL;
    if (!self.splitViewController) {
        //if splitViewController exists. webview would alredy be on screen
        [self.navigationController pushViewController:self.webViewController
                                         animated:YES];
    }
}

- (CGFloat)tableView:(nonnull UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 56.0;
}
#pragma mark - UI view
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Load the NIB file
    UINib *nib = [UINib nibWithNibName:@"BNRCoursesTableViewCell" bundle:nil];
    
    [self.tableView registerNib:nib
           forCellReuseIdentifier:@"BNRCoursesTableViewCell"];
}

#pragma mark - NSURLSessionDataDelegate
- (void)URLSession:(nonnull NSURLSession *)session
              task:(nonnull NSURLSessionTask *)task
didReceiveChallenge:(nonnull NSURLAuthenticationChallenge *)challenge
 completionHandler:(nonnull void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * __nullable))completionHandler
{
    NSURLCredential *cred = [NSURLCredential credentialWithUser:@"BigNerdRanch"
                                                       password:@"AchieveNerdvana"
                                                    persistence:NSURLCredentialPersistenceForSession];
    completionHandler(NSURLSessionAuthChallengeUseCredential, cred);
}
@end
