//
//  BNRDetailViewController.m
//  Homepwner
//
//  Created by Tsz Chun Lai on 3/20/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//
#import "BNRItem.h"
#import "BNRItemStore.h"
#import "BNRImageStore.h"
#import "BNRAppDelegate.h"
#import "BNRItemsViewController.h"
#import "BNRDetailViewController.h"
#import "BNRPopoverBackgroundView.h"
#import "BNRDetailDateViewController.h"
#import "BNRAssetTypeViewController.h"
@interface BNRDetailViewController () <UINavigationControllerDelegate,
    UIImagePickerControllerDelegate, UITextFieldDelegate,
    UIPopoverControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *serialNumberField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *trash;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *assetTypeButton;
@property (strong, nonatomic) UIPopoverController *imagePickerPopover;
@property (strong, nonatomic) UIPopoverController *assetTypeViewPopover;

@end

@implementation BNRDetailViewController

#pragma mark - init
- (instancetype)initForNewItem:(BOOL)isNew
{
    //what happens if i just call init?
    self = [super initWithNibName:@"BNRDetailViewController" bundle:nil];
    if (self) {
        
        // state restoration support
        self.restorationIdentifier = NSStringFromClass([self class]);
        self.restorationClass = [self class];
        
        if (isNew) {
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc]
                                         initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                         target:self
                                         action:@selector(save:)];
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                           target:self
                                           action:@selector(cancel:)];
            self.navigationItem.rightBarButtonItem = doneItem;
            self.navigationItem.leftBarButtonItem = cancelItem;
        }
        
        NSNotificationCenter *defaultCetner = [NSNotificationCenter defaultCenter];
        [defaultCetner addObserver:self
                          selector:@selector(updateFonts)
                              name:UIContentSizeCategoryDidChangeNotification
                            object:nil];
    }
    return self;
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    @throw [NSException exceptionWithName:@"Wrong initilizer"
                                   reason:@"Use initForNewItem"
                                 userInfo:nil];
    return nil;
}

#pragma mark - View controller

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *iv = [[UIImageView alloc] initWithImage:nil];
    
    //the contentMode of the image view in the XIB was Aspect Fit:
    iv.contentMode = UIViewContentModeScaleAspectFit;
    
    // Do not produce a translated constraint for this view
    iv.translatesAutoresizingMaskIntoConstraints = NO;
    
    // The image view was a subview of the view
    [self.view addSubview:iv];
    
    // The image view was pointed to by the imageVIew property
    self.imageView = iv;
    
    NSDictionary *nameMap = @{@"imageView" : self.imageView,
                              @"dateLabel" : self.dateLabel,
                              @"toolbar"   : self.toolbar};
    
    // imageView is 0 pts from superview at left and right edges
    NSArray *horizontalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]-0-|"
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    
    // imageView is 8 pts from dateLable at its top edge...
    // ... and 8 pts from toolbar at its bottom edge
    NSArray *verticalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[dateLabel]-[imageView]-[toolbar]"
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    
    [self.view addConstraints:horizontalConstraints];
    [self.view addConstraints:verticalConstraints];
    
    // Set the vertical priorities to be less than
    // those of the other subviews
    [self.imageView setContentHuggingPriority:200
                                      forAxis:UILayoutConstraintAxisVertical];
    [self.imageView setContentCompressionResistancePriority:700
                                                    forAxis:UILayoutConstraintAxisVertical];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIInterfaceOrientation io = [[UIApplication sharedApplication] statusBarOrientation];
    [self prepareViewsForOrientation:io];
    
    BNRItem *item = self.item;
    
    self.nameField.text = item.itemName;
    self.serialNumberField.text = item.serialNumber;
    self.valueField.text = [NSString stringWithFormat:@"%d", item.valueInDollars];
    
    // You need an NSDateFormatter that will turn a data into a simple date string
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    
    // Use filtered NSDate object to set dateLabel contentes
    self.dateLabel.text = [dateFormatter stringFromDate:item.dateCreated];
    
    NSString *imageKey = self.item.itemKey;
    // Get the image for its image key from the image store
    UIImage *imageToDisplay = [[BNRImageStore sharedStore] imageForKey:imageKey];
    
    // Use that image to put on screen in the image view
    self.imageView.image = imageToDisplay;
    
    [self setTypeLabel];

    
    // Call method to use the preferred Body style
    [self updateFonts];
}

- (void) setTypeLabel
{
    NSString *typeLabel = [self.item.assetType valueForKey:@"label"];
    if (!typeLabel) {
        typeLabel = NSLocalizedString(@"None",@"Type label None");
    }
    
    self.assetTypeButton.title = [NSString stringWithFormat:
                                  NSLocalizedString(@"Type: %@", @"Asset type button")
                                  , typeLabel];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Clear first responder
    [self.view endEditing:YES];
    
    // "Save" changes to item
    BNRItem *item = self.item;
    item.itemName = self.nameField.text;
    item.serialNumber = self.serialNumberField.text;
//    item.valueInDollars = [self.valueField.text intValue];
    int newValue = [self.valueField.text intValue];
    
    // is it changed?
    if (newValue != item.valueInDollars) {
        // Put it in the item
        item.valueInDollars = newValue;
        
        // Store it as the default value for the next item
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:newValue
                      forKey:BNRNextItemValuePrefsKey];
    }
}


- (void)prepareViewsForOrientation:(UIInterfaceOrientation)orientation
{
    // Is it an iPad? No preparation necessary
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return;
    }
    
    // Is it landsacpe?
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        self.imageView.hidden = YES;
        self.cameraButton.enabled = NO;
    } else {
        self.imageView.hidden = NO;
        self.cameraButton.enabled = YES;
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration
{
    [self prepareViewsForOrientation:toInterfaceOrientation];
}

# pragma mark - image picker controller
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Get picked image from info dictionary
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    // create a thumbnail
    [self.item setThumbnailFromImage:image];
    
    // Store the image in the BNRImageStore for this key
    [[BNRImageStore sharedStore] setImage:image
                                   forKey:self.item.itemKey];
    
    
    // Put that image onto the screen in our image view
    self.imageView.image = image;
    
    
    // Do I have a popover?
    if (self.imagePickerPopover) {
        // Dismiss it
        [self.imagePickerPopover dismissPopoverAnimated:YES];
        self.imagePickerPopover = nil;
    } else {
        // Dismiss the modal image picker
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)updateFonts
{
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
    self.nameLabel.font = font;
    self.serialNumberLabel.font = font;
    self.valueLabel.font = font;
    self.dateLabel.font = font;
    
    self.nameField.font = font;
    self.serialNumberField.font = font;
    self.valueField.font = font;
}
#pragma mark - popover controller
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    NSLog(@"User dismissed popover");
    if (popoverController == self.imagePickerPopover)
    {
        self.imagePickerPopover = nil;
    }
    else if (popoverController == self.assetTypeViewPopover)
    {
        [self setTypeLabel];
    }
}

# pragma mark - text field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - buttons
- (void)save:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:self.dismissBlock];
}
- (void)cancel:(id)sender
{
    // If the user cancelled, then remove the BNRItem from the store
    [[BNRItemStore sharedStore] removeItem:self.item];
    
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:self.dismissBlock];
}

- (IBAction)takePicture:(id)sender {
    if ([self.assetTypeViewPopover isPopoverVisible]) {
        // If the popover is already up, get rid of it
        [self.assetTypeViewPopover dismissPopoverAnimated:NO];
        self.assetTypeViewPopover = nil;
    }
    UIImagePickerController *imagePicker =
    [[UIImagePickerController alloc] init];
    // if the device has a camera, take a picture, otherwise, photo library
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    imagePicker.delegate = self;
    // Allow editing
    imagePicker.allowsEditing = YES;
    // Place image picker on the screen
    // CHeck for iPad device before instantiating the popover controller
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        // Create a new popover contoller that will display the imagepicker
        self.imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        self.imagePickerPopover.delegate = self;
        
        // Display the popover controller; sender
        // is the camera bar button item
        [self.imagePickerPopover presentPopoverFromBarButtonItem:sender
                                        permittedArrowDirections:UIPopoverArrowDirectionAny
                                                        animated:YES];
    } else {
        [self presentViewController:imagePicker animated:YES completion:nil];
    }

}
- (IBAction)removePhoto:(id)sender {
    // Delete the image in the BNRImageStore for this key
    [[BNRImageStore sharedStore] deleteImageForKey:self.item.itemKey];
    
    self.imageView.image=nil;
    
}


- (IBAction)changeDate:(id)sender {
    BNRDetailDateViewController *ddvc = [[BNRDetailDateViewController alloc] init];
    ddvc.item = self.item;
    [self.navigationController setTitle:@"Change Date"];
    [self.navigationController pushViewController:ddvc animated:YES];
}
- (IBAction)backgroundTapped:(id)sender {
    [self.view endEditing:YES];
}


- (void)setItem:(BNRItem *)item {
    _item = item;
    self.navigationItem.title = _item.itemName;
}

- (IBAction)showAssetTypePicker:(id)sender {
    [self.view endEditing:YES];
    
    if ([self.imagePickerPopover isPopoverVisible]) {
        // If the popover is already up, get rid of it
        [self.imagePickerPopover dismissPopoverAnimated:NO];
        self.imagePickerPopover = nil;
    }
    
    BNRAssetTypeViewController *avc = [[BNRAssetTypeViewController alloc] init];
    avc.item = self.item;
    if ([[UIDevice currentDevice]userInterfaceIdiom ]== UIUserInterfaceIdiomPad)
    {
        
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:avc];
        nc.delegate = self;
        
        UIPopoverController * pc= [[UIPopoverController alloc]initWithContentViewController:nc];
        
        
        [pc presentPopoverFromBarButtonItem:self.assetTypeButton
                   permittedArrowDirections:UIPopoverArrowDirectionAny
                                   animated:YES];
        self.assetTypeViewPopover = pc;
        pc.delegate = self;
        avc.padPopover = pc;
        avc.dvc = self;

        
    } else
    {
        [self.navigationController pushViewController:avc
                                             animated:YES];
    }
}


#pragma mark - dealloc
- (void)dealloc
{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self];
}

#pragma mark - state restoration
+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(nonnull NSArray *)path coder:(nonnull NSCoder *)coder
{
    BOOL isNew = NO;
    if ([path count] == 3) {
        isNew = YES;
    }
    
    return [[self alloc]initForNewItem:isNew];
}

- (void)encodeRestorableStateWithCoder:(nonnull NSCoder *)coder
{
    [coder encodeObject:self.item.itemKey
                 forKey:@"item.itemKey"];
    
    // Save changes into item
    self.item.itemName = self.nameField.text;
    self.item.serialNumber = self.serialNumberField.text;
    self.item.valueInDollars = [self.valueField.text intValue];
    
    // Have store save changes to disk
    [[BNRItemStore sharedStore] saveChanges];
    
    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(nonnull NSCoder *)coder
{
    NSString *itemKey = [coder decodeObjectForKey:@"item.itemKey"];
    
    for (BNRItem *item in [[BNRItemStore sharedStore] allItems]) {
        if ([itemKey isEqualToString:item.itemKey]) {
            self.item = item;
            break;
        }
    }
    [super decodeRestorableStateWithCoder:coder];
}
@end
