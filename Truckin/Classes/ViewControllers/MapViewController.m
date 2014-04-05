//
//  MapViewController.m
//  Truckin
//
//  Created by Michael Fellows on 4/5/14.
//  Copyright (c) 2014 Broadway Lab, Inc. All rights reserved.
//

#import "MapViewController.h"
#import "Truck.h"
#import "MapManager.h"
#import <MapKit/MapKit.h>

@interface MapViewController () <MKMapViewDelegate>

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) PFGeoPoint *userLocation;
@property (nonatomic, copy) NSArray *trucks;

@end

@implementation MapViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.navigationItem.title = @"Around Me";
        self.tabBarItem.image = [UIImage imageNamed:@"pushpin"];
        
        self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:self.mapView];
        self.mapView.delegate = self;
        self.mapView.showsUserLocation = YES; 
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (error) {
            [[[UIAlertView alloc] initWithTitle:@"error"
                                        message:[[error userInfo] valueForKey:@"error"]
                                       delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil] show];
        } else {
            self.userLocation = geoPoint;
            [self findTrucksNearGeoPoint:self.userLocation];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Netowrking

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
            [self addAnnotations];
        }
    }];
}

#pragma mark - MapView Fun...

- (void)addAnnotations
{
    for (PFObject *object in self.trucks) {
        Truck *truck = [[Truck alloc] initWithObject:object];
        MKPointAnnotation *annotaiton = [[MKPointAnnotation alloc] init];
        annotaiton.coordinate = CLLocationCoordinate2DMake(truck.location.latitude, truck.location.longitude);
        annotaiton.title = truck.name;
        [self.mapView addAnnotation:annotaiton]; 
    }
    
    Truck *truck = [[Truck alloc] initWithObject:[self.trucks lastObject]];
    
    MapManager *manager = [[MapManager alloc] initWithCoordinates:truck.location.latitude
                                                        longitude:truck.location.longitude
                                                     userLocation:self.userLocation];
    MKCoordinateRegion mapRegion = [manager mapRegion];
    [self.mapView setRegion:mapRegion animated:YES]; 
}

@end
