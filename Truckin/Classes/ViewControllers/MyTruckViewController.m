//
//  MyTruckViewController.m
//  Truckin
//
//  Created by Michael Fellows on 4/5/14.
//  Copyright (c) 2014 Broadway Lab, Inc. All rights reserved.
//

#import "MyTruckViewController.h"

@interface MyTruckViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UITextField *descriptionField;
@property (nonatomic, strong) UIImage *profileImage;
@property (nonatomic, strong) UIImage *headerImage;
@property (nonatomic, strong) UIImagePickerController *profilePicker;
@property (nonatomic, strong) UIImagePickerController *headerPicker;
@property (nonatomic, strong) PFGeoPoint *userLocation;

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
        
        self.profileImage = nil;
        self.headerImage = nil;
        
        
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
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (error) {
            [[[UIAlertView alloc] initWithTitle:@"Error"
                                        message:@"Unable to get current location"
                                       delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil] show];
        } else {
            self.userLocation = geoPoint;
        }
    }];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (picker == self.profilePicker) {
        self.profileImage = image;
    } else {
        self.headerImage = image;
    }
    [self dismissViewControllerAnimated:YES completion:nil]; 
}

#pragma mark - Selector

- (void)addProfileButton:(id)sender
{
    self.profilePicker = [[UIImagePickerController alloc] init];
    [self.profilePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    self.profilePicker.allowsEditing = YES;
    [self.profilePicker setDelegate:self];
    [self presentViewController:self.profilePicker animated:YES completion:nil];
}

- (void)addHeaderButton:(id)sender
{
    self.headerPicker = [[UIImagePickerController alloc] init];
    self.headerPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.headerPicker.allowsEditing = YES;
    self.headerPicker.delegate = self;
    [self presentViewController:self.headerPicker animated:YES completion:nil];
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
    PFObject *truck = [PFObject objectWithClassName:@"Truck"];
    truck[@"name"] = self.nameField.text;
    truck[@"truck_description"] = self.descriptionField.text;
    truck[@"twitter"] = @"mafellows";
    truck[@"url"] = @"http://www.example.com";
    truck[@"location"] = self.userLocation;
    
    NSData *profileImageData = UIImagePNGRepresentation(self.profileImage);
    PFFile *imageFile = [PFFile fileWithName:@"profile.png" data:profileImageData];
    truck[@"image"] = imageFile;
    
    NSData *headerImageData = UIImagePNGRepresentation(self.headerImage);
    PFFile *headerFile = [PFFile fileWithName:@"header.png" data:headerImageData];
    truck[@"header_image"] = headerFile;
    [truck saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            [[[UIAlertView alloc] initWithTitle:@"Error"
                                        message:@"Unable to save Food Truck"
                                       delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil] show];
        } else {
            // Handle success...
        }
    }];
    
    
}

@end
