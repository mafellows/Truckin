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
    kCellLogOut,
    kCellCount
};

@interface ProfileViewController ()

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

@end
