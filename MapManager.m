//
//  MapManager.m
//  DealMe
//
//  Created by Michael Fellows on 3/7/14.
//  Copyright (c) 2014 Michael Fellows. All rights reserved.
//

#import "MapManager.h"

@interface MapManager () {
    CGFloat _latitude;
    CGFloat _longitude;
}

@property (nonatomic, strong) PFGeoPoint *userLocation;

@end

@implementation MapManager

- (id)initWithCoordinates:(CGFloat)latitude longitude:(CGFloat)longitude userLocation:(PFGeoPoint *)userLocation
{
    self = [super init];
    if (self) {
        _latitude = latitude;
        _longitude = longitude;
        self.userLocation = userLocation;
    }
    return self;
}

- (MKCoordinateRegion)mapRegion
{
    CLLocationCoordinate2D southWest = CLLocationCoordinate2DMake(self.userLocation.latitude, self.userLocation.longitude);
    CLLocationCoordinate2D northEast = southWest;
    
    southWest.latitude = MIN(southWest.latitude, _latitude);
    southWest.longitude = MIN(southWest.longitude, _longitude);
    
    northEast.latitude = MAX(northEast.latitude, _latitude);
    northEast.longitude = MAX(northEast.longitude, _longitude);
    
    CLLocation *locSouthWest = [[CLLocation alloc] initWithLatitude:southWest.latitude longitude:southWest.longitude];
    CLLocation *locNorthEast = [[CLLocation alloc] initWithLatitude:northEast.latitude longitude:northEast.longitude];
    
    CLLocationDistance meters = [locSouthWest distanceFromLocation:locNorthEast];
    
    MKCoordinateRegion mapRegion;
    mapRegion.center.latitude = (southWest.latitude + northEast.latitude) / 2.0;
    mapRegion.center.longitude = (southWest.longitude + northEast.longitude) / 2.0;
    mapRegion.span.latitudeDelta = meters / 111319.5; // ??? why that number ?
    mapRegion.span.longitudeDelta = 0.03;
    return mapRegion; 
}

@end
