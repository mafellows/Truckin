//
//  ProfileViewController.m
//  Truckin
//
//  Created by Michael Fellows on 4/5/14.
//  Copyright (c) 2014 Broadway Lab, Inc. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileHeaderView.h"
#import "MyTruckViewController.h"

typedef NS_ENUM(NSInteger, CellIndex) {
    kCellFavorites,
    kCellMyTruck,
    kCellGoOffline,
    kCellUpdateLocation,
    kCellLogOut,
    kCellCount
};

@interface ProfileViewController ()

@property (nonatomic, strong) PFGeoPoint *userLocation;

@end

@implementation ProfileViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.tabBarItem.image = [UIImage imageNamed:@"people"];
        self.navigationItem.title = @"Profile";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (error) {
            [[[UIAlertView alloc] initWithTitle:@"Error"
                                        message:@"Unable to find geo point"
                                       delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil] show];
        } else {
            self.userLocation = geoPoint;
        }
    }];

    self.tableView.tableHeaderView = [[ProfileHeaderView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 50.0f)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kCellCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    if (indexPath.row == kCellFavorites) {
        cell.textLabel.text = @"Favorites";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (indexPath.row == kCellMyTruck) {
        cell.textLabel.text = @"My Truck";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (indexPath.row == kCellLogOut) {
        cell.textLabel.text = @"Log Out";
        cell.textLabel.textColor = [UIColor redColor];
    } else if (indexPath.row == kCellGoOffline) {
        cell.textLabel.text = @"Go Offline";
    } else if (indexPath.row == kCellUpdateLocation) {
        cell.textLabel.text = @"Update Location";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 80.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == kCellLogOut) {
        [self logOut];
    } else if (indexPath.row == kCellMyTruck) {
        [self showMyTruck];
    } else if (indexPath.row == kCellGoOffline) {
        [self goOffline];
    } else if (indexPath.row == kCellUpdateLocation) {
        [self updateLocation];
    }
}

#pragma mark - Helpers

- (void)logOut
{
    [PFUser logOut];
    self.tabBarController.selectedIndex = 0; 
}

- (void)showMyTruck
{
    MyTruckViewController *myTruckVC = [[MyTruckViewController alloc] init];
    [self.navigationController pushViewController:myTruckVC animated:YES]; 
}

- (void)goOffline
{
    PFQuery *truckQuery = [PFQuery queryWithClassName:@"Truck"];
    [truckQuery whereKey:@"twitter_id" equalTo:[PFUser currentUser].objectId];
    [truckQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            [[[UIAlertView alloc] initWithTitle:@"Error"
                                        message:@"Unable to go offline"
                                       delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil] show];
        } else {
            
            if (objects.count == 0) {
                [[[UIAlertView alloc] initWithTitle:@"Uh oh! "
                                            message:@"Looks like you don't have any trucks!"
                                           delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil, nil] show];
            } else {
                PFObject *truck = [objects firstObject];
                PFGeoPoint *geoPoint = [[PFGeoPoint alloc] init];
                geoPoint.latitude = 0.0;
                geoPoint.longitude = 0.0;
                truck[@"location"] = geoPoint;
                [truck saveInBackgroundWithBlock:^(BOOL succeeded, NSError *saveError) {
                    if (saveError) {
                        [[[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:@"Unable to save"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil] show];
                    } else {
                        [[[UIAlertView alloc] initWithTitle:@"Whooo!"
                                                    message:@"What a day. We took you off the map."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil] show];
                    }
                }];
            }
        }
    }];
}

- (void)updateLocation
{
    PFQuery *query = [PFQuery queryWithClassName:@"Truck"];
    [query whereKey:@"twitter_id" equalTo:[[PFUser currentUser] objectId]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            [[[UIAlertView alloc] initWithTitle:@"Error"
                                        message:@"We didn't find any of your trucks."
                                       delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil] show];
        } else {
            if (objects.count == 0) {
                [[[UIAlertView alloc] initWithTitle:@"Uh oh!"
                                            message:@"Looks like you don't have any food trucks.."
                                           delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil, nil] show];
            } else {
                PFObject *truck = [objects objectAtIndex:0];
                truck[@"location"] = self.userLocation;
                [truck saveInBackgroundWithBlock:^(BOOL succeeded, NSError *saveError) {
                    if (saveError) {
                        [[[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:@"Unable to update location"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil] show];
                    } else {
                        [[[UIAlertView alloc] initWithTitle:@"Hey Truckster"
                                                    message:@"We succesfully updated your location"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil] show];
                    
                    }
                }];
            }
            
        }
    }];
}

@end
