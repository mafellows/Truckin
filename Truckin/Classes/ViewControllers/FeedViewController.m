//
//  FeedViewController.m
//  Truckin
//
//  Created by Michael Fellows on 4/5/14.
//  Copyright (c) 2014 Broadway Lab, Inc. All rights reserved.
//

#import "FeedViewController.h"
#import "LoginViewController.h"
#import "FeedCell.h"
#import "Truck.h"
#import "DetailViewController.h"

@interface FeedViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) PFGeoPoint *currentLocation;
@property (nonatomic, copy) NSArray *trucks;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation FeedViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"Truckin";
        self.tabBarItem.image = [UIImage imageNamed:@"feed"];
        
        self.trucks = [NSArray array];
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        self.refreshControl = [[UIRefreshControl alloc] init];
        [self.refreshControl addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventValueChanged];
        [self.tableView addSubview:self.refreshControl];
        
        // [self.tableView registerClass:[FeedCell class] forCellReuseIdentifier:@"FeedCell"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad]; 
    
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (error) {
            [[[UIAlertView alloc] initWithTitle:@"Error"
                                        message:[[error userInfo] valueForKey:@"error"]
                                       delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil] show];
        } else {
            self.currentLocation = geoPoint;
            [self findTrucksNearGeoPoint:self.currentLocation];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self checkLogin];
}

#pragma mark - Helpers

- (void)checkLogin
{
    if (![PFUser currentUser]) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self presentViewController:loginVC animated:NO completion:nil];
    }
}

- (void)refreshData:(id)sender
{
    [self findTrucksNearGeoPoint:self.currentLocation];
}

- (void)findTrucksNearGeoPoint:(PFGeoPoint *)geoPoint
{
    PFQuery *query = [PFQuery queryWithClassName:@"Truck"];
    [query whereKey:@"location" nearGeoPoint:geoPoint withinMiles:50];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            [[[UIAlertView alloc] initWithTitle:@"Error"
                                        message:[[error userInfo] valueForKey:@"error"]
                                       delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil] show];
        } else {
            self.trucks = objects;
            if ([self.refreshControl isRefreshing]) {
                [self.refreshControl endRefreshing]; 
            }
            
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f; 
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.trucks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FeedCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    Truck *truck = [[Truck alloc] initWithObject:[self.trucks objectAtIndex:indexPath.row]];
    NSLog(@"%@", truck);
    
    cell.textLabel.text = truck.name;
    CGFloat distance = [truck.location distanceInMilesTo:self.currentLocation];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%0.1f miles away", distance];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Truck *truck = [[Truck alloc] initWithObject:[self.trucks objectAtIndex:indexPath.row]];
    DetailViewController *detailVC = [[DetailViewController alloc] initWithTruck:truck];
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
