//
//  LoginViewController.m
//  Truckin
//
//  Created by Michael Fellows on 4/5/14.
//  Copyright (c) 2014 Broadway Lab, Inc. All rights reserved.
//

#import "LoginViewController.h"
#import <FBShimmeringView.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        FBShimmeringView *shimmeringView = [[FBShimmeringView alloc] initWithFrame:CGRectMake(0, 0, 320.0f, 200.0f)];
        [self.view addSubview:shimmeringView];

        CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
        CGFloat padding = 10.0f;
        UILabel *truckinLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, 100.0f, screenWidth - 2*padding, 80.0f)];
        truckinLabel.textAlignment = NSTextAlignmentCenter;
        truckinLabel.text = @"Truckin";
        truckinLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:60.0f];
        // truckinLabel.textColor = [UIColor whiteColor];
        shimmeringView.contentView = truckinLabel;
        
        shimmeringView.shimmering = YES;
        
        CGRect twitterLoginFrame = CGRectMake(padding, 250.0f, screenWidth - 2*padding, 80.0f);
        UIButton *twitterLoginButton = [[UIButton alloc] initWithFrame:twitterLoginFrame];
        twitterLoginButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [twitterLoginButton setImage:[UIImage imageNamed:@"twitterLogin"] forState:UIControlStateNormal];
        twitterLoginButton.layer.masksToBounds = YES;
        [twitterLoginButton addTarget:self action:@selector(logInWithTwitter:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:twitterLoginButton];

        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Selector

- (void)logInWithTwitter:(id)sender
{
    [PFTwitterUtils logInWithBlock:^(PFUser *user, NSError *error) {
        if (error) {
            [[[UIAlertView alloc] initWithTitle:@"Uh oh!"
                                        message:[[error userInfo] objectForKey:@"error"]
                                       delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil] show];
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

@end
