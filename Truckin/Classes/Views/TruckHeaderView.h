//
//  TruckHeaderView.h
//  Truckin
//
//  Created by Michael Fellows on 4/5/14.
//  Copyright (c) 2014 Broadway Lab, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Truck.h"

@interface TruckHeaderView : UIView

@property (nonatomic, strong) PFImageView *headerImageView;
@property (nonatomic, strong) PFImageView *profileImageView;

- (id)initWithFrame:(CGRect)frame truck:(Truck *)truck; 

@end
