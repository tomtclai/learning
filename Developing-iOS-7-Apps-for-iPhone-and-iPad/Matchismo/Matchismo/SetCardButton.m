//
//  SetCardView.m
//  SuperCard
//
//  Created by Tom Lai on 8/21/15.
//  Copyright (c) 2015 Lai. All rights reserved.
//

#import "SetCardButton.h"
@implementation SetCardButton
#pragma mark - properties
- (void)setSymbol:(NSString *)shape
{
    _symbol = shape;
    [self setNeedsDisplay];
}

- (void)setColor:(NSString *)color
{
    _color = color;
    [self setNeedsDisplay];
}

- (void)setShading:(NSString *)shading
{
    _shading = shading;
    [self setNeedsDisplay];
}

- (void)setNumber:(NSUInteger)number
{
    _number = number;
    [self setNeedsDisplay];
}

- (void)setChosen:(BOOL)chosen
{
    _chosen = chosen;
    [self setNeedsDisplay];
}

#pragma mark - Drawing
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self drawSymbols];
}
#pragma mark - Symbols
#define SYMBOL_OFFSET_PERCENT_1 0.1;
#define SYMBOL_OFFSET_PERCENT_2 0.2;
#define SHAPE_LINE_WIDTH_PERCENT 0.02;
- (void)drawSymbols
{
    [[self uiColor] setStroke];
    CGPoint center = CGPointMake(self.bounds.size.width/2.0,
                                 self.bounds.size.height/2.0);
    CGFloat dx1 = self.bounds.size.width * SYMBOL_OFFSET_PERCENT_1;
    CGFloat dx2 = self.bounds.size.width * SYMBOL_OFFSET_PERCENT_2;
    if (self.number == 1 || self.number == 3) {
        [self drawSymbolAtPoint:CGPointMake(center.x , center.y)];
    }
    
    if (self.number == 2) {
        [self drawSymbolAtPoint:CGPointMake(center.x - dx1 , center.y)];
        [self drawSymbolAtPoint:CGPointMake(center.x + dx1 , center.y)];
    }
    
    if (self.number == 3) {
        [self drawSymbolAtPoint:CGPointMake(center.x - dx2, center.y)];
        [self drawSymbolAtPoint:CGPointMake(center.x + dx2, center.y)];
    }
    
    
}

- (UIColor *)uiColor
{
    if ([self.color isEqualToString:@"red"]) return [UIColor redColor];
    if ([self.color isEqualToString:@"green"]) return [UIColor greenColor];
    if ([self.color isEqualToString:@"purple"]) return [UIColor purpleColor];
    return nil;
}
- (void)drawSymbolAtPoint:(CGPoint)point
{
    if ([self.symbol isEqualToString:@"oval"]) [self drawOvalAtPoint:point];
    else if ([self.symbol isEqualToString:@"squiggle"]) [self drawSquiggleAtPoint:point];
    else if ([self.symbol isEqualToString:@"diamond"]) [self drawDiamondAtPoint:point];
}
#pragma mark Oval
#define OVAL_WIDTH_PERCENT 0.12
#define OVAL_HEIGHT_PERCENT 0.4
- (void)drawOvalAtPoint:(CGPoint)point
{
    // a retangle with very rounded corners
    CGFloat ovalWidth = self.bounds.size.width * OVAL_WIDTH_PERCENT;
    CGFloat ovalHeight =  self.bounds.size.height * OVAL_HEIGHT_PERCENT;
    CGFloat dx = ovalWidth / 2.0;
    CGFloat dy = ovalHeight / 2.0;
    CGPoint ovalTopLeft = CGPointMake(point.x - dx, point.y - dy);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:
                          CGRectMake(ovalTopLeft.x, ovalTopLeft.y, ovalWidth, ovalHeight) cornerRadius:dx];
    
    path.lineWidth = self.bounds.size.width * SHAPE_LINE_WIDTH_PERCENT;
    [self shadePath:path];
    [path stroke];
}
#pragma mark Squiggle
#define SQUIGGLE_WIDTH_PERCENT 0.12
#define SQUIGGLE_HEIGHT_PERCENT 0.3
#define SQUIGGLE_FACTOR 1.3
- (void)drawSquiggleAtPoint:(CGPoint)point
{
    // a combination of curves
    CGFloat dx = self.bounds.size.width * SQUIGGLE_WIDTH_PERCENT / 2.0;
    CGFloat dy = self.bounds.size.height * SQUIGGLE_HEIGHT_PERCENT / 2.0;
    CGPoint squiggleTopLeft = CGPointMake(point.x - dx, point.y - dy);
    CGPoint squiggleTopRight = CGPointMake(point.x + dx, point.y - dy);
    CGPoint squiggleBottomLeft = CGPointMake(point.x - dx, point.y + dy);
    CGPoint squiggleBottomRight = CGPointMake(point.x + dx, point.y + dy);
    CGFloat dsqx = dx * SQUIGGLE_FACTOR;
    CGFloat dsqy = dy * SQUIGGLE_FACTOR;
    UIBezierPath *path = [[UIBezierPath alloc] init];
    CGPoint startingPoint1 = squiggleTopLeft;
    CGPoint endingPoint1 =   squiggleTopRight;
    CGPoint controlPoint1 =  CGPointMake(point.x - dsqx, point.y - dy - dsqy);
    
    // i have no idea what these does
    [path moveToPoint:startingPoint1];
    [path addQuadCurveToPoint:endingPoint1 controlPoint:controlPoint1];
    
    [path addCurveToPoint:squiggleBottomRight
            controlPoint1:CGPointMake    (point.x + dx + dsqx, point.y - dy + dsqy)
            controlPoint2:CGPointMake    (point.x + dx - dsqx, point.y + dy - dsqy)];
    
    [path addQuadCurveToPoint:squiggleBottomLeft
                 controlPoint:CGPointMake(point.x + dsqx, point.y + dy + dsqy)];
    [path addCurveToPoint:CGPointMake    (point.x - dx, point.y - dy)
            controlPoint1:CGPointMake    (point.x - dx - dsqx, point.y + dy - dsqy)
            controlPoint2:CGPointMake    (point.x - dx + dsqx, point.y - dy + dsqy)];
    
    path.lineWidth = self.bounds.size.width * SHAPE_LINE_WIDTH_PERCENT;
    [self shadePath:path];
    [path stroke];
}
#pragma mark Diamond
#define DIAMOND_WIDTH_PERCENT 0.15
#define DIAMOND_HEIGHT_PERCENT 0.4

- (void)drawDiamondAtPoint:(CGPoint)point;
{
    CGFloat dx = self.bounds.size.width * DIAMOND_WIDTH_PERCENT / 2.0;
    CGFloat dy = self.bounds.size.height * DIAMOND_HEIGHT_PERCENT / 2.0;
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(point.x, point.y - dy)];
    [path addLineToPoint:CGPointMake(point.x + dx, point.y)];
    [path addLineToPoint:CGPointMake(point.x, point.y + dy)];
    [path addLineToPoint:CGPointMake(point.x - dx, point.y)];
    [path closePath];
    path.lineWidth = self.bounds.size.width * SHAPE_LINE_WIDTH_PERCENT;
    [self shadePath:path];
    [path stroke];
}
#pragma mark - Stripes
#define STRIPES_OFFSET 0.06
#define STRIPES_ANGLE 5
#pragma mark Shade
- (void)shadePath:(UIBezierPath *)path
{
    if ([self.shading isEqualToString:@"solid"]) {
        [[self uiColor] setFill];
        [path fill];
    } else if ([self.shading isEqualToString:@"striped"]) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        [path addClip];
        UIBezierPath *stripes = [[UIBezierPath alloc]init];
        CGPoint start = self.bounds.origin;
        CGPoint end = start;
        CGFloat dy = self.bounds.size.height * STRIPES_OFFSET;
        end.x += self.bounds.size.width;
        start.y += dy * STRIPES_ANGLE;
        for (int i = 0 ; i <  1 / STRIPES_OFFSET; i++) {
            [stripes moveToPoint:start];
            [stripes addLineToPoint:end];
            start.y += dy;
            end.y += dy;
        }
        stripes.lineWidth = self.bounds.size.width / 2 * SHAPE_LINE_WIDTH_PERCENT;
        [stripes stroke];
        CGContextRestoreGState(UIGraphicsGetCurrentContext());
        
    } else if ([self.shading isEqualToString:@"open"]) {
        [[UIColor clearColor] setFill];
    }
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
