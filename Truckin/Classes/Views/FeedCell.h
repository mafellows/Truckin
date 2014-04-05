//
//  FeedCell.h
//  Truckin
//
//  Created by Michael Fellows on 4/5/14.
//  Copyright (c) 2014 Broadway Lab, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SAMCircleProgressView.h>

@interface FeedCell : UITableViewCell

@property (nonatomic, strong) PFImageView *imageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) SAMCircleProgressView *progressView; 

@end
