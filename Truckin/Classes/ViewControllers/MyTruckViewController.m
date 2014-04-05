//
//  MyTruckViewController.m
//  Truckin
//
//  Created by Michael Fellows on 4/5/14.
//  Copyright (c) 2014 Broadway Lab, Inc. All rights reserved.
//

#import "MyTruckViewController.h"

@interface MyTruckViewController ()

@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UITextField *descriptionField;

@end

@implementation MyTruckViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
            [self setEdgesForExtendedLayout:UIRectEdgeNone];
        }
        
        self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        CGFloat padding = 10.0f;
        CGFloat textFieldHeight = 40.0f;
        UITextField *nameField = [[UITextField alloc] initWithFrame:CGRectMake(padding, padding, 300.0f, textFieldHeight)];
        nameField.placeholder = @"Truck Name";
        nameField.borderStyle = UITextBorderStyleRoundedRect;
        [self.view addSubview:nameField];
        
        UITextField *descriptionField = [[UITextField alloc] initWithFrame:CGRectMake(padding, 2*padding + textFieldHeight, 300.0f, textFieldHeight)];
        descriptionField.placeholder = @"Truck description";
        descriptionField.borderStyle = UITextBorderStyleRoundedRect;
        [self.view addSubview:descriptionField];
        
        UIButton *profileImageButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [profileImageButton setTitle:@"Add profile Picture" forState:UIControlStateNormal];
        profileImageButton.frame  = CGRectMake(padding, descriptionField.frame.origin.y + textFieldHeight + padding, 300.0f, textFieldHeight);
        [profileImageButton addTarget:self action:@selector(addProfileButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:profileImageButton];
        
        UIButton *headerButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [headerButton setTitle:@"Add Header Photo" forState:UIControlStateNormal];
        headerButton.frame = CGRectMake(padding, profileImageButton.frame.origin.y + textFieldHeight + padding, 300.0f, textFieldHeight);
        [headerButton addTarget:self action:@selector(addHeaderButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:headerButton];
        
        UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(removeKeyboard:)];
        [self.view addGestureRecognizer:tgr];
        
        self.nameField = nameField;
        self.descriptionField = descriptionField;
        
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save"
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(saveTruck:)];
        self.navigationItem.rightBarButtonItem = saveButton;
        
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"My Truck";
}

#pragma mark - Selector

- (void)addProfileButton:(id)sender
{
    // Add the image
}

- (void)addHeaderButton:(id)sender
{
    //
}

- (void)removeKeyboard:(UIGestureRecognizer *)recognizer
{
    NSArray *textFields = @[ self.nameField, self.descriptionField ];
    for (UITextField *textField in textFields) {
        if ([textField isFirstResponder]) {
            [textField resignFirstResponder];
        }
    }
}

- (void)saveTruck:(id)sender
{
    
}

@end
