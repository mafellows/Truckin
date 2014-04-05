//
//  TruckHeaderView.m
//  Truckin
//
//  Created by Michael Fellows on 4/5/14.
//  Copyright (c) 2014 Broadway Lab, Inc. All rights reserved.
//

#import "TruckHeaderView.h"
#import <SAMCircleProgressView.h>


@implementation TruckHeaderView

- (id)initWithFrame:(CGRect)frame truck:(Truck *)truck
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.headerImageView = [[PFImageView alloc] initWithFrame:CGRectMake(0, 0, 320.0f, 200.0f)];
        self.headerImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.headerImageView];
        
        PFFile *headerFile = truck.headerImage;
        SAMCircleProgressView *headerProgressView = [[SAMCircleProgressView alloc] initWithFrame:CGRectMake(0, 0, 55.0f, 55.0f)];
        headerProgressView.center = self.headerImageView.center;
        if (!self.headerImageView.image) {
            [self.headerImageView addSubview:headerProgressView];
        }
        
        [headerFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (error) {
                NSLog(@"%@", [error localizedDescription]);
            } else {
                self.headerImageView.image = [UIImage imageWithData:data];
                [headerProgressView removeFromSuperview];
            }
        } progressBlock:^(int percentDone) {
            headerProgressView.progress = (float)percentDone / 100;
        }];
        
        UIView *tintView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320.0f, 200.0f)];
        tintView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
        [self.headerImageView addSubview:tintView];
        
        CGFloat padding = 10.0f;
        CGFloat diameter = 80.0f;
        self.profileImageView = [[PFImageView alloc] initWithFrame:CGRectMake(padding, padding, diameter, diameter)];
        self.profileImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.profileImageView.layer.cornerRadius = diameter / 2;
        self.profileImageView.layer.masksToBounds = YES;
        self.profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.profileImageView.layer.borderWidth = 1.0f;
        [self.headerImageView addSubview:self.profileImageView];
        
        PFFile *truckFile = truck.image;
        SAMCircleProgressView *profileImageProgressView = [[SAMCircleProgressView alloc] initWithFrame:CGRectMake(0, 0, 40.0f, 40.0f)];
        profileImageProgressView.center = self.profileImageView.center;
        
        if (!self.profileImageView.image) {
            [self.profileImageView addSubview:profileImageProgressView];
        }
        [truckFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (error) {
                NSLog(@"Error: %@", [error localizedDescription]);
            } else {
                self.profileImageView.image = [UIImage imageWithData:data];
                [profileImageProgressView removeFromSuperview];
            }
        } progressBlock:^(int percentDone) {
            dispatch_async(dispatch_get_main_queue(), ^{
                profileImageProgressView.progress = (float)percentDone / 100;
            });
        }];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(diameter + 2*padding, padding, 220, 40.0f)];
        nameLabel.text = truck.name;
        nameLabel.font = [UIFont boldSystemFontOfSize:30.0f];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.adjustsFontSizeToFitWidth = YES;
        nameLabel.textColor = [UIColor whiteColor];
        [self.headerImageView addSubview:nameLabel];
        
        CGRect descriptionFrame = CGRectMake(100.0f, 30.0f, 220.0f, 100.0f);
        UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:descriptionFrame];
        descriptionLabel.text = truck.truckDescription;
        descriptionLabel.numberOfLines = 0;
        descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        descriptionLabel.textColor = [UIColor whiteColor];
        [self.headerImageView addSubview:descriptionLabel];
        

        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
