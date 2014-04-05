//
//  Truck.h
//  Truckin
//
//  Created by Michael Fellows on 4/5/14.
//  Copyright (c) 2014 Broadway Lab, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Truck : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, strong) PFGeoPoint *location;
@property (nonatomic, strong) NSString *twitterName;
@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, strong) PFFile *image;
@property (nonatomic, strong) PFFile *headerImage;

- (id)initWithObject:(PFObject *)object; 

@end
