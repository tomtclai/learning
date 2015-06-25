//
//  BNRHypnosisViewController.m
//  HypnoNerd
//
//  Created by Tsz Chun Lai on 2/21/15.
//  Copyright (c) 2015 Big Nerd Ranch. All rights reserved.
//

#import "BNRHypnosisViewController.h"
#import "BNRHypnosisView.h"
#import "AppDelegate.h"
@interface BNRHypnosisViewController()
<UITextFieldDelegate>
@property (nonatomic, strong) NSMutableArray* labels;
@end

@implementation BNRHypnosisViewController

#pragma mark - init
- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // State restoration support
        self.restorationIdentifier = NSStringFromClass([self class]);
        self.restorationClass = [self class];
        
        // Set the tab bar item's title
        self.tabBarItem.title = @"Hypnotize";
        
        // Create a UIImage from a file
        // This will use Hypno@2x.png on retina display devices
        UIImage *i = [UIImage imageNamed:@"Hypno.png"];
        
        // Put that inmage on the tab bar item
        self.tabBarItem.image = i;
        
        if (!self.labels)
        {
            self.labels = [[NSMutableArray alloc]init];
        }
    }
    return self;
}
#pragma mark - UI View
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"BNRHypnosisViewController loaded its view");
}

#pragma mark - other
- (void)loadView
{
    CGRect frame = [UIScreen mainScreen].bounds;
    
    // Create a view
    BNRHypnosisView *backgroundView = [[BNRHypnosisView alloc] initWithFrame:frame];
    
    CGRect textFieldRect = CGRectMake(60, 70, 240, 30);
    
    UITextField *textField = [[UITextField alloc] initWithFrame:textFieldRect];
    
    // Setting the border style on the text field will allow us to see it mroe easily
    textField.borderStyle = UITextBorderStyleRoundedRect;
    
    textField.placeholder = @"Hypnotize me";
    
    textField.returnKeyType = UIReturnKeyDone;
    
    textField.delegate =  self;
    
    [backgroundView addSubview:textField];
    
    // Set it as *the* view of this view controller
    self.view = backgroundView;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self drawHypnoticeMessage:textField.text];
    
    textField.text = @"";
    [textField resignFirstResponder];
    return YES;
}

- (void)drawHypnoticeMessage:(NSString *)message
{
    for (int i = 0; i < 100; i++)
    {
        UILabel *messageLabel = [[UILabel alloc] init];
        
        // Configure the label's colors and text
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.text = message;
        
        // This method resizes the label, which will be relative
        // to the text that it is displaying
        [messageLabel sizeToFit];
        
        // Get a random x value that fits within the hypnosis view's width
        int width = (int) (self.view.bounds.size.width -
                           messageLabel.bounds.size.width);
        // Get a random y value that fits within the hypnosis view's height
        int height = (int) (self.view.bounds.size.height -
                           messageLabel.bounds.size.height);
        
        int x = arc4random() % width;
        int y = arc4random() % height;
        
        // Update the label's frame
        CGRect frame = messageLabel.frame;
        frame.origin = CGPointMake(x, y);
        messageLabel.frame = frame;
        
        // Add the label to the hierarchy
        [self.view addSubview:messageLabel];
        [self.labels addObject:messageLabel];
        UIInterpolatingMotionEffect *motionEffect;
        motionEffect = [[UIInterpolatingMotionEffect alloc]
                        initWithKeyPath:@"center.x"
                        type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        motionEffect.minimumRelativeValue = @(-25);
        motionEffect.maximumRelativeValue = @(25);
        [messageLabel addMotionEffect:motionEffect];
        
        motionEffect = [[UIInterpolatingMotionEffect alloc]
                        initWithKeyPath:@"center.y"
                        type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        motionEffect.minimumRelativeValue = @(-25);
        motionEffect.maximumRelativeValue = @(25);
        [messageLabel addMotionEffect:motionEffect];
        
    }
}
#pragma mark - state restoration
+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents
                                                           coder:(NSCoder *)coder
{
    UIViewController* hvc = [[self alloc]init];
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    UITabBarController *tbc = (UITabBarController *)appDelegate.window.rootViewController;
    [tbc addChildViewController:hvc];
    
    return hvc;
}
- (void)encodeRestorableStateWithCoder:(nonnull NSCoder *)coder
{
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:self.labels];
    [coder encodeObject:data forKey:@"hvc.labels"];
    
}
- (void)decodeRestorableStateWithCoder:(nonnull NSCoder *)coder
{
    
    NSError *err = nil;
    [self.labels setArray:[NSKeyedUnarchiver unarchiveObjectWithData:[coder decodeObjectForKey:@"hvc.labels" error:&err]]];

    for (UILabel* i in self.labels)
    {
        [self.view addSubview:i];
    }
    if (err) NSLog(@"%@",err);
}
@end
