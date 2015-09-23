//
//  DetailViewController.h
//  photoKeepr
//
//  Created by Tom Lai on 9/20/15.
//  Copyright © 2015 Lai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PTKDocument;
@class DetailViewController;

@protocol DetailViewControllerDelegate <NSObject>
- (void)detailViewControllerDidClose:(DetailViewController *)detailViewController;
@end


@interface DetailViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) PTKDocument * doc;
// Note that we are passing an opened PTKDocument as the item to display (rather than the fileURL). This was a design decision. It can take time to open a document, especially if it is large or not fully synchronized with iCloud, and it depends where you want to spend that time – before transitioning to the detail view or after. We chose before for this.

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak) id <DetailViewControllerDelegate> delegate;

@end

