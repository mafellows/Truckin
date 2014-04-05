//
//  ProfileHeaderView.m
//  Truckin
//
//  Created by Michael Fellows on 4/5/14.
//  Copyright (c) 2014 Broadway Lab, Inc. All rights reserved.
//

#import "ProfileHeaderView.h"

@implementation ProfileHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat padding = 10.0f;
        CGFloat diameter = 80.0f;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(padding, padding, diameter, diameter)];
        imageView.image = [UIImage imageNamed:@"avatar"]; 
        imageView.layer.cornerRadius = diameter / 2;
        imageView.layer.masksToBounds = YES;
        [self addSubview:imageView];
        
        CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.height;
        CGRect nameFrame = CGRectMake(diameter + 2*padding, padding, screenWidth - diameter - 2*padding, 30.0f);
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:nameFrame];
        nameLabel.text = @"Michael Fellows";
        [self addSubview:nameLabel]; 
        
        CGRect locationFrame = CGRectMake(diameter + 2*padding, 2*padding + 30.0f, screenWidth - diameter - 2*padding, 20.0f);
        UILabel *locationLabel = [[UILabel alloc] initWithFrame:locationFrame];
        locationLabel.text = @"Indianapolis, IN";
        [self addSubview:locationLabel];
    }
    return self;
}

@end
