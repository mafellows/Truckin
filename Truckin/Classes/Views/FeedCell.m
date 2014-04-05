//
//  FeedCell.m
//  Truckin
//
//  Created by Michael Fellows on 4/5/14.
//  Copyright (c) 2014 Broadway Lab, Inc. All rights reserved.
//

#import "FeedCell.h"

@implementation FeedCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat padding = 10.0f;
        CGFloat imageWidth = 80.0f;
        CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
//        self.imageView = [[PFImageView alloc] initWithFrame:CGRectMake(padding, padding, imageWidth, imageWidth)];
//        self.imageView.layer.cornerRadius = imageWidth / 2.0f;
//        self.imageView.layer.masksToBounds = YES;
//        self.imageView.contentMode = UIViewContentModeScaleAspectFill; 
//        [self addSubview:self.imageView];
        
//        self.progressView = [[SAMCircleProgressView alloc] initWithFrame:self.imageView.frame];
//        [self.imageView addSubview:self.progressView];
//        
        CGFloat labelHeight = 40.0f;
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(2*padding + imageWidth, padding, screenWidth - imageWidth - 3*padding, labelHeight)];
        [self.nameLabel sizeToFit];
        [self addSubview:self.nameLabel];
        self.nameLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:24.0f];
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        
        self.distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(2 * padding + imageWidth, 2*padding + labelHeight, screenWidth - imageWidth - 3*padding, 30.0f)];
        [self.distanceLabel sizeToFit];
        self.distanceLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:18.0f];
        self.distanceLabel.textColor = [UIColor lightGrayColor];
        self.distanceLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.distanceLabel];
    }
    return self;
}

@end
