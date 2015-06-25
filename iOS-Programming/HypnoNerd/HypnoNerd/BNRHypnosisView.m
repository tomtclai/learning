//
//  BNRHypnosisView.m
//  Hypnosister
//
//  Created by Tsz Chun Lai on 2/15/15.
//  Copyright (c) 2015 Big Nerd Ranch. All rights reserved.
//

#import "BNRHypnosisView.h"
@interface BNRHypnosisView()

@property (strong, nonatomic) UIColor *circleColor;

@end

@implementation BNRHypnosisView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)drawRect:(CGRect)rect {
    CGRect bounds = self.bounds;
    // Find center
    CGPoint center;
    center.x = bounds.origin.x + bounds.size.width / 2.0;
    center.y = bounds.origin.y + bounds.size.height / 2.0;
    // The circle will be the largest that will fit in the view
    float maxRadius = hypot(bounds.size.width, bounds.size.height)/ 2.0;
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    for (float currentRadius = maxRadius; currentRadius > 0; currentRadius -=20)
    {
        [path moveToPoint:CGPointMake(center.x+currentRadius, center.y)];
        [path addArcWithCenter:center
                        radius:currentRadius
                    startAngle:0.0
                      endAngle:M_PI * 2.0
                     clockwise:YES];
        
        
    }
    path.lineWidth = 10;
    [self.circleColor setStroke];
    [path stroke];
    
    
    UIImage* BNRlogo = [UIImage imageNamed:@"logo.png"];
    
    float logoX = center.x- BNRlogo.size.width/4;
    float logoY = center.y- BNRlogo.size.height/4;
    CGRect logo = CGRectMake(logoX, logoY, BNRlogo.size.width/2.0, BNRlogo.size.height/2.0);
    
    
    
    
    
    
    CGFloat locations[2] = {0.0, 1.0};
    CGFloat components[8] = {0.0, 1.0, 0.0, 1.0, //Green
        1.0, 1.0, 0.0, 1.0}; //Yellow
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    CGGradientRef gradient = CGGradientCreateWithColorComponents
    (colorspace, components, locations, 2);
    
    CGPoint startPoint = CGPointMake(center.x, logo.origin.y-10);
    CGPoint endPoint = CGPointMake(center.x, logo.origin.y+50+logo.size.height);
    
    UIBezierPath *triangle = [[UIBezierPath alloc] init];
    [triangle moveToPoint:CGPointMake(center.x, logo.origin.y)];
    [triangle addLineToPoint:CGPointMake(center.x-logo.size.width/2.0,
                                         logo.origin.y+logo.size.height+50)];
    [triangle addLineToPoint:CGPointMake(center.x+logo.size.width/2.0,
                                         logo.origin.y+logo.size.height+50)];
    
    CGContextSaveGState(UIGraphicsGetCurrentContext());
    [triangle addClip];
    
    CGContextDrawLinearGradient(UIGraphicsGetCurrentContext(),
                                gradient, startPoint, endPoint,
                                0);
    
    CGContextRestoreGState(UIGraphicsGetCurrentContext());
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorspace);
    
    
    
    
    CGContextSaveGState(UIGraphicsGetCurrentContext());
    CGContextSetShadow(UIGraphicsGetCurrentContext(), CGSizeMake(4, 7), 3);
    [BNRlogo drawInRect:logo];
    CGContextRestoreGState(UIGraphicsGetCurrentContext());

    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.circleColor = [UIColor lightGrayColor];
    }
    self.restorationIdentifier = NSStringFromClass([self class]);
    return self;
}

// When a finger touches the screen
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%@ was touched", self);
    
    // Get 3 random numbers between 0 and 1
    float red = (arc4random() %100) / 100.0;
    float green = (arc4random() %100) /100.0;
    float blue = (arc4random() %100) / 100.0;
    
    UIColor* randomColor = [UIColor colorWithRed:red
                                           green:green
                                            blue:blue
                                           alpha:1.0];
    self.circleColor = randomColor;
}

- (void)setCircleColor:(UIColor *)circleColor
{
    _circleColor = circleColor;
    [self setNeedsDisplay];
}
#pragma mark - state restoration

//+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(nonnull NSArray *)
//identifierComponents coder:(nonnull NSCoder *)coder
//{
//    NSBundle *appBundle = [NSBundle mainBundle];
//    return [[self alloc]initWithNibName:@"BNRHypnosisView" bundle:appBundle];
//}
- (void)encodeRestorableStateWithCoder:(nonnull NSCoder *)coder
{
    [coder encodeObject:self.circleColor forKey:@"self.circleColor"];
}
- (void)decodeRestorableStateWithCoder:(nonnull NSCoder *)coder
{
    
    self.circleColor = [coder decodeObjectForKey:@"self.circleColor"];
}
@end


