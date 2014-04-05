//
//  Truck.m
//  Truckin
//
//  Created by Michael Fellows on 4/5/14.
//  Copyright (c) 2014 Broadway Lab, Inc. All rights reserved.
//

#import "Truck.h"

@implementation Truck

- (id)initWithObject:(PFObject *)object
{
    self = [super init];
    if (self) {
        _name = [object valueForKey:@"name"];
        _description = [object valueForKey:@"description"];
        _location = [object objectForKey:@"location"];
        _twitterName = [object valueForKey:@"twitter"];
        _urlString = [object valueForKey:@"url"];
        _image = [object objectForKey:@"image"];
        _headerImage = [object objectForKey:@"header_image"];
        
    }
    return self;
}

@end
