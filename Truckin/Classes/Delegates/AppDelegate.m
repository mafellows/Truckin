//
//  AppDelegate.m
//  Truckin
//
//  Created by Michael Fellows on 4/5/14
//  Copyright (c) 2014 Broadway Lab, Inc.. All rights reserved.
//

#import "AppDelegate.h"
#import "BLBaseNavigationController.h"
#import "ProfileViewController.h"
#import "MapViewController.h"
#import "FeedViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    [Parse setApplicationId:@"YT9ie7LZtyFyjFJwtLzkAwuDHibewyksC5noN2Fd"
                  clientKey:@"0Fb5VQ5S8DJseP3ynei7nr1KtBNBpJS4wwdb29BV"];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    [PFTwitterUtils initializeWithConsumerKey:@"KuapMz1eXQ8qekVJUQY1AhhgG"
                               consumerSecret:@"yc0FsTp9cG11OIfoZdJgFS91mscZ1bSWj3sGtFSvZ2msW3n6sV"];
    
    FeedViewController *feedVC = [[FeedViewController alloc] init];
    BLBaseNavigationController *feedNav = [[BLBaseNavigationController alloc] initWithRootViewController:feedVC];
    
    MapViewController *mapVC = [[MapViewController alloc] init];
    BLBaseNavigationController *mapNav = [[BLBaseNavigationController alloc] initWithRootViewController:mapVC];
    
    ProfileViewController *profileVC = [[ProfileViewController alloc] init];
    BLBaseNavigationController *profileNav = [[BLBaseNavigationController alloc] initWithRootViewController:profileVC];
    
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[ feedNav, mapNav, profileNav ];
    
    self.window.rootViewController = tabBarController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
