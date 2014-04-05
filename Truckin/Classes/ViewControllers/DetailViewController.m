//
//  DetailViewController.m
//  Truckin
//
//  Created by Michael Fellows on 4/5/14.
//  Copyright (c) 2014 Broadway Lab, Inc. All rights reserved.
//

#import "DetailViewController.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>


@interface DetailViewController ()

@property (nonatomic, strong) Truck *truck;
@property (nonatomic, strong) ACAccountStore *accountStore;
@property (nonatomic, strong) NSMutableArray *tweets;

@end

@implementation DetailViewController

- (id)initWithTruck:(Truck *)truck
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.truck = truck;
        self.accountStore = [[ACAccountStore alloc] init];
        self.tweets = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchTimeLineForUser:self.truck.twitterName];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [self.tweets objectAtIndex:indexPath.row];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping; 
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

#pragma mark - Twitter

- (BOOL)userHasAccessToTwitter
{
    return [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter];
}

- (void)fetchTimeLineForUser:(NSString *)username
{
    if ([self userHasAccessToTwitter]) {
        ACAccountType *twitterAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        [self.accountStore requestAccessToAccountsWithType:twitterAccountType options:NULL completion:^(BOOL granted, NSError *error) {
            if (granted) {
                NSArray *twitterAccounts = [self.accountStore accountsWithAccountType:twitterAccountType];
                NSURL *url = [NSURL URLWithString:@"https://api.twitter.com"
                              @"/1.1/statuses/user_timeline.json"];
                NSDictionary *params = @{@"screen_name" : username,
                                         @"include_rts" : @"0",
                                         @"trim_user" : @"1",
                                         @"count" : @"30"};
                SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:url parameters:params];
                [request setAccount:[twitterAccounts lastObject]];
                
                [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *requestError) {
                    if (responseData) {
                        if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300) {
                            NSError *jsonError;
                            NSDictionary *timelineData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&jsonError];
                            if (timelineData) {
                                NSLog(@"%@", timelineData); // We has the data!!!
                                for (NSDictionary *tweet in timelineData) {
                                    NSString *text = [tweet valueForKey:@"text"];
                                    [self.tweets addObject:text];
                                }
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self.tableView reloadData];
                                });
                            } else {
                                NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
                            }
                        } else {
                            NSLog(@"The server did not respond: %@", [requestError localizedDescription]);
                        }
                    }
                }];
            } else {
                NSLog(@"Access was not granted. An error occured: %@", [error localizedDescription]);
            }
        }];
    }
}

@end
