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

@interface FeedViewController ()

@property (nonatomic, strong) PFGeoPoint *currentLocation;
@property (nonatomic, copy) NSArray *trucks;

@end

@implementation FeedViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"Truckin";
        self.tabBarItem.image = [UIImage imageNamed:@"feed"];
        
        self.trucks = [NSArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self checkLogin];
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helpers

- (void)checkLogin
{
    if (![PFUser currentUser]) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self presentViewController:loginVC animated:NO completion:nil];
    }
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
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FeedCell";
    FeedCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[FeedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    
    return cell;
}

@end
