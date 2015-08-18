//
//  ViewController.m
//  Dropit
//
//  Created by Tom Lai on 8/17/15.
//  Copyright (c) 2015 Lai. All rights reserved.
//

#import "ViewController.h"
#import "DropitBehavior.h"
#import "BezierPathView.h"
@interface ViewController () <UIDynamicAnimatorDelegate>
@property (weak, nonatomic) IBOutlet BezierPathView *gameView;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) DropitBehavior *dropitBehavior;
@property (strong, nonatomic) UIAttachmentBehavior *attachment;
@property (strong, nonatomic) UIView *droppingView;
@end

@implementation ViewController

static const CGSize DROP_SIZE = { 25, 25 };

- (UIDynamicAnimator *)animator
{
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.gameView];
        _animator.delegate = self;
    }
    return _animator;
}
- (DropitBehavior *)dropitBehavior
{
    if (!_dropitBehavior ) {
        _dropitBehavior = [[DropitBehavior alloc] init];
        [self.animator addBehavior:_dropitBehavior];
    }
    return _dropitBehavior;
}
- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{

    [self removeCompletedRows];
}

- (BOOL)removeCompletedRows
{
    NSMutableArray *dropsToRemove = [[NSMutableArray alloc] init];
    for (CGFloat y = self.gameView.bounds.size.height - DROP_SIZE.height/2; y > 0; y -= DROP_SIZE.height)
    {
        BOOL rowIsComplete = YES;
        NSMutableArray *dropsFound = [[NSMutableArray alloc] init];
        for (CGFloat x = DROP_SIZE.width/2; x <= self.gameView.bounds.size.width - DROP_SIZE.width/2; x+= DROP_SIZE.width)
        {
            UIView *hitView = [self.gameView hitTest:CGPointMake(x, y) withEvent:NULL];
            if ([hitView superview] == self.gameView) {
                [dropsFound addObject: hitView];
            } else {
                rowIsComplete = NO;
                break;
            }
        }
        if (![dropsFound count]) break; // if 0, break
        if (rowIsComplete) [dropsToRemove addObjectsFromArray:dropsFound];
    }
    
    
    if ([dropsToRemove count]) {
        for (UIView *drop in dropsToRemove) {
            [self.dropitBehavior removeItem:drop];
        }
        [self animateRemovingDrops:dropsToRemove];
    }
    
    return NO;
}

- (void)animateRemovingDrops: (NSArray *) dropsToRemove
{
    [UIView animateWithDuration:1.0
                     animations:^{
                         for (UIView *drop in dropsToRemove) {
                             int x =(arc4random() % (int)(self.gameView.bounds.size.width*5)) - (int)self.gameView.bounds.size.width*2;
                             int y = self.gameView.bounds.size.height;
                             drop.center = CGPointMake(x, -y);
                         }
                     } completion:^(BOOL finished) {
                         [dropsToRemove makeObjectsPerformSelector:@selector(removeFromSuperview)];
                     }];
}


- (IBAction)tap:(UITapGestureRecognizer *)sender { // should be a better name
    [self drop];
}

- (IBAction)pan:(UIPanGestureRecognizer *)sender { // should be a better name
    CGPoint gesturePoint = [sender locationInView:self.gameView];
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self attachDroppingViewToPoint:gesturePoint];
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        self.attachment.anchorPoint = gesturePoint;
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        [self.animator removeBehavior:self.attachment];
        self.gameView.path = nil;
    }
}

- (void)attachDroppingViewToPoint:(CGPoint) anchorPoint
{
    if (self.droppingView) {
        self.attachment = [[UIAttachmentBehavior alloc] initWithItem:self.droppingView
                                                    attachedToAnchor:anchorPoint];
        UIView *droppingView = self.droppingView;
        __weak ViewController *weakSelf = self;
        self.attachment.action = ^{
            UIBezierPath *path = [[UIBezierPath alloc] init];
            [path moveToPoint:weakSelf.attachment.anchorPoint];
            [path addLineToPoint:droppingView.center];
            weakSelf.gameView.path = path;
        };
        
        self.droppingView = nil; // only one try at grabbing that thing
        
        [self.animator addBehavior:self.attachment];
    }
}

- (void)drop
{
    CGRect frame;
    frame.origin = CGPointZero;
    frame.size = DROP_SIZE;
    int x = (arc4random() %(int)self.gameView.bounds.size.width)/ DROP_SIZE.width;
    frame.origin.x = x * DROP_SIZE.width;
    
    UIView *dropView = [[UIView alloc] initWithFrame:frame];
    
    dropView.backgroundColor = [self randomColor];
    [self.gameView addSubview:dropView];
    [self.dropitBehavior addItem:dropView];
    self.droppingView = dropView;
}

- (UIColor *)randomColor
{
    
    return [UIColor colorWithRed:arc4random() % 2
                           green:arc4random() % 2
                            blue:arc4random() % 2
                           alpha:1];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
