//
//  MapViewController.m
//  Truckin
//
//  Created by Michael Fellows on 4/5/14.
//  Copyright (c) 2014 Broadway Lab, Inc. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>

@interface MapViewController ()

@property (nonatomic, strong) MKMapView *mapView;

@end

@implementation MapViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.navigationItem.title = @"Around Me";
        self.tabBarItem.image = [UIImage imageNamed:@"pushpin"];
        
        self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds]; 
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
