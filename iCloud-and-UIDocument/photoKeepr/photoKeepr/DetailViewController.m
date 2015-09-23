//
//  DetailViewController.m
//  photoKeepr
//
//  Created by Tom Lai on 9/20/15.
//  Copyright © 2015 Lai. All rights reserved.
//

#import "DetailViewController.h"
#import "PTKDocument.h"
#import "PTKData.h"
#import "UIImageExtras.h"

@interface DetailViewController ()

@end

@implementation DetailViewController {
    UIImagePickerController *_picker;
}

#pragma mark - Managing the detail item

- (void)setDoc:(PTKDocument *)doc {
    if (_doc != doc) {
        _doc = doc;
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item
    self.title = [self.doc description];
    if (self.doc.photo) {
        self.imageView.image = self.doc.photo;
    } else {
        self.imageView.image = [UIImage imageNamed:@"defaultImage.png"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneTapped:)];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    [self.navigationItem setHidesBackButton:YES animated:YES];
    
    UITapGestureRecognizer *tapRegcognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    [self.view addGestureRecognizer:tapRegcognizer];
    
    [self configureView];
}

- (void)viewDidUnload {
    [self setImageView:nil];
    [super viewDidUnload];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (BOOL)shouldAutorotate {
    return YES;
}


#pragma mark Callbacks
- (void)imageTapped:(UITapGestureRecognizer *)recognizer {
    if (!_picker) {
        _picker = [UIImagePickerController new];
        _picker.delegate = self;
        _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _picker.allowsEditing = NO;
    }
    
    [self presentViewController:_picker animated:YES completion:nil];
}
- (void)doneTapped:(id)sender {
    NSLog(@"Closing %@", self.doc.fileURL);
    [self.doc saveToURL:self.doc.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
        [self.doc closeWithCompletionHandler:^(BOOL success) {
            dispatch_async(dispatch_get_main_queue(), ^{

                if (!success) {
                    NSLog(@"Failed to close %@", self.doc.fileURL);
                    // Continue anyway
                }
                
                [self.delegate detailViewControllerDidClose:self];
            });
        }];
    }];
}
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info {
    UIImage *image = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
    
    CGSize mainSize = self.imageView.bounds.size;
    UIImage *sImage = [image imageByBestFitForSize:mainSize]; // [image scaleToFitSize:mainSize];
    
    self.doc.photo = sImage;
    self.imageView.image = sImage;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
