//
//  MapManager.h
//  DealMe
//
//  Created by Michael Fellows on 3/7/14.
//  Copyright (c) 2014 Michael Fellows. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapManager : NSObject

- (id)initWithCoordinates:(CGFloat)latitude longitude:(CGFloat)longitude userLocation:(PFGeoPoint *)userLocation; 

- (MKCoordinateRegion)mapRegion;

@end
