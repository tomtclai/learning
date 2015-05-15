//
//  BNRDrawView.m
//  TouchTracker
//
//  Created by Tsz Chun Lai on 3/23/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#import "BNRDrawView.h"
#import "BNRColorPickerViewController.h"
@implementation BNRDrawView

- (instancetype)initWithFrame:(CGRect)r
{
    self = [super initWithFrame:r];
    
    if (self) {
        self.linesInProgress = [[NSMutableDictionary alloc] init];
        self.finishedLines = [[NSMutableArray alloc] init];
        self.backgroundColor = [UIColor grayColor];
        self.multipleTouchEnabled = YES;
        UITapGestureRecognizer *doubleTapRecognizer =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(doubleTap:)];
        doubleTapRecognizer.numberOfTapsRequired = 2;
        doubleTapRecognizer.delaysTouchesBegan = YES;
        [self addGestureRecognizer:doubleTapRecognizer];
        
        UITapGestureRecognizer *tapRecognizer =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(tap:)];
        tapRecognizer.delaysTouchesBegan = YES;
        [tapRecognizer requireGestureRecognizerToFail:doubleTapRecognizer];
        [self addGestureRecognizer:tapRecognizer];
        
        UILongPressGestureRecognizer *pressRecognizer =
        [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                      action:@selector(longPress:)];
        [self addGestureRecognizer:pressRecognizer];
        
        self.moveRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                      action:@selector(moveLine:)];
        self.moveRecognizer.delegate = self;
        self.moveRecognizer.cancelsTouchesInView = NO;
        [self.moveRecognizer requireGestureRecognizerToFail:tapRecognizer];
        [self addGestureRecognizer:self.moveRecognizer];
        
        UISwipeGestureRecognizer *threeFingerSwipeUpRecognizer =
        [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(threeFingerSwipeUp:)];
        [threeFingerSwipeUpRecognizer setDirection:UISwipeGestureRecognizerDirectionUp];
        [threeFingerSwipeUpRecognizer setNumberOfTouchesRequired:3];
        
        [self addGestureRecognizer:threeFingerSwipeUpRecognizer];
        
        UIPinchGestureRecognizer *pinchRecognizer =
        [[UIPinchGestureRecognizer alloc]
         initWithTarget:self
         action:@selector(pinch:)];
        
        [self addGestureRecognizer:pinchRecognizer];
    }
    
    return self;
}
#pragma mark - Gesture actions
- (void)pinch:(UIPinchGestureRecognizer *)gr
{
//    [gr scale]
}
- (void)threeFingerSwipeUp:(UISwipeGestureRecognizer *)gr
{
    NSLog(@"Reconized three finger swipe");
    if (!self.cpvc) self.cpvc = [[BNRColorPickerViewController alloc]init];
    [[self cpvc] showInView:self animated:YES];
}

- (void)moveLine:(UIPanGestureRecognizer *)gr
{
    // if we have not selected a line, we do not do anything here
    if (!self.selectedLine) return;

    
    // When the pan recognizer changes its position...
    if (gr.state == UIGestureRecognizerStateChanged) {
        // How far has the pan moved?
        CGPoint translation = [gr translationInView:self];
        
        // Add the translation to the current beginning and end points of the
        // line
        CGPoint begin = self.selectedLine.begin;
        CGPoint end = self.selectedLine.end;
        
        // Set the new beginning and end points of the line
        self.selectedLine.begin = [self translatePoint:begin
                                         withIncrement:translation];
        self.selectedLine.end = [self translatePoint:end
                                       withIncrement:translation];
        
        // Redraw the screen
        [self setNeedsDisplay];
        
        [gr setTranslation:CGPointZero inView:self];
    }
}

- (CGPoint)translatePoint:(CGPoint) orig withIncrement:(CGPoint) incr
{
    orig.x += incr.x;
    orig.y += incr.y;
    return orig;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return (gestureRecognizer == self.moveRecognizer);
}

- (void)longPress:(UIGestureRecognizer *)gr
{
    if (gr.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [gr locationInView:self];
        self.selectedLine = [self lineAtPoint:point];
        
        if (self.selectedLine) {
            [self.linesInProgress removeAllObjects];
        }
    } else if (gr.state == UIGestureRecognizerStateEnded) {
        self.selectedLine = nil;
    }
    
    [self setNeedsDisplay];
}

- (int)numOfLines
{
    int count= 0;
    if (self.linesInProgress && self.finishedLines)
        count = [self.linesInProgress count] + [self.finishedLines count];
    return count;
}

- (void)doubleTap:(UIGestureRecognizer *)gr
{
    NSLog(@"Reconized Double Tap");
    
    [self.linesInProgress removeAllObjects];
    [self.finishedLines removeAllObjects];
    [self setNeedsDisplay];
}

- (void)tap:(UIGestureRecognizer *)gr
{
    NSLog(@"Reconized Tap");
    
    CGPoint point = [gr locationInView:self];
    self.selectedLine = [self lineAtPoint:point];
    
    if (self.selectedLine) {
        // Make ourselves the target of menu item action messages
        
        [self becomeFirstResponder];
        
        // Grab the menu controller
        UIMenuController *menu = [UIMenuController sharedMenuController];
        
        // Create a new "Delete" UIMenuItem
        UIMenuItem *deleteItem = [[UIMenuItem alloc] initWithTitle:@"Delete"
                                                            action:@selector(deleteLine:)];
        menu.menuItems = @[deleteItem];
        
        // Tell the menu it should come from and show it
        [menu setTargetRect:CGRectMake(point.x, point.y, 2, 2) inView:self];
        [menu setMenuVisible:YES animated:YES];
        
    } else {
        [[UIMenuController sharedMenuController] setMenuVisible:NO
                                                       animated:YES];
    }
    
    [self setNeedsDisplay];
    
}

#pragma mark - UIResponder implementation
- (BOOL)canBecomeFirstResponder
{
    return YES;
}
#pragma mark - Other
- (void)deleteLine:(id)sender
{
    // Remove the selected line from the list of _finishedLines
    [self.finishedLines removeObject:self.selectedLine];
    
    // Redraw
    [self setNeedsDisplay];
}

- (void)strokeLine:(BNRLine *)line
{
    UIBezierPath *bp = [UIBezierPath bezierPath];
    bp.lineWidth = [line width];
    bp.lineCapStyle = kCGLineCapRound;
    [bp moveToPoint:line.begin];
    [bp addLineToPoint:line.end];
    bp.lineWidth *=2;
    [bp stroke];
}

- (void)drawLine:(BNRLine*)line
{
    [[line color] set];
    
    [self strokeLine:line];
}

- (void)drawRect:(CGRect)rect
{
    for (BNRLine *line in [self finishedLines]) {
        [self drawLine:line];
    }
    
    for (NSValue *key in [self linesInProgress]) {
        [self drawLine:[self linesInProgress][key]];
    }
    
    if (self.selectedLine) {
        [self drawLine:self.selectedLine];
    }

}



- (BNRLine *)lineAtPoint:(CGPoint)p
{
    // Find a line closs to p
    for (BNRLine *l in self.finishedLines) {
        CGPoint start = l.begin;
        CGPoint end = l.end;
        for (float t = 0.0; t <= 1.0; t+= 0.05) {
            float x = start.x + t * (end.x - start.x);
            float y = start.y + t * (end.y - start.y);
            
            // If the tapped point is within its width,
            // let's return this line
            if (hypot(x - p.x, y - p.y) < l.width) {
                return l;
            }
        }
    }
    return nil;
}

- (float)lineToAngleRadian:(BNRLine *)line
{
    float opposite = line.end.y - line.begin.y;
    float adjacent = line.end.x - line.begin.x;
    return atan2f(opposite, adjacent);
}

- (UIColor *)radianToColor:(float) rad
{
    float angle = rad+ M_PI;
    float redVal, greenVal, blueVal;
    // each pi/3 interval gets different rules
    
    const static float rad_30 = M_PI * 1.0 / 6.0;
    const static float rad_90 = M_PI * 3.0 / 6.0;
    const static float rad_150 = M_PI * 5.0 / 6.0;
    const static float rad_210 = M_PI * 7.0 / 6.0;
    const static float rad_270 = M_PI * 9.0 / 6.0;
    const static float rad_330 = M_PI * 11.0 / 6.0;
    const static float rad_360 = M_PI * 2;
    
    //0 to 30deg
    if (angle < rad_30) {
        redVal = [self normalizeAngle:angle
                                 from: 0
                                   to: rad_30];
        greenVal = 1;
        blueVal = 0;
        //30 to 90deg
    } else if (angle < rad_90) {
        
        redVal = 1;
        greenVal = 1 - [self normalizeAngle:angle
                                       from:rad_30
                                         to:rad_90];
        blueVal = 0;
        //90 to 150deg
    } else if (angle < rad_150){
        redVal = 1;
        greenVal = 0;
        blueVal = [self normalizeAngle:angle
                                  from:rad_90
                                    to:rad_150];
        //150 to 210deg
    } else if (angle < rad_210) {
        redVal = 1 - [self normalizeAngle:angle
                                     from:rad_150
                                       to:rad_210];
        greenVal = 0;
        blueVal = 1;
        //210 to 270deg
    } else if (angle < rad_270) {
        redVal = 0;
        greenVal = [self normalizeAngle:angle
                                   from:rad_210
                                     to:rad_270];
        blueVal = 1;
        //270 to 330deg
    } else if (angle < rad_330){
        redVal = 0;
        greenVal = 1;
        blueVal = 1 - [self normalizeAngle:angle
                                      from:rad_270
                                        to:rad_330];
        //330 to 360deg
    } else {
        redVal = [self normalizeAngle:angle
                                 from:rad_330
                                   to:rad_360];
        greenVal = 1;
        blueVal = 0;
    }
    return [UIColor colorWithRed:redVal
                                 green:greenVal
                                  blue:blueVal
                                 alpha:1];
}

-(bool) angle:(float) a
 isLargerThan:(float) min
   isLessThanOrEqualTo:(float) max
{
    return (a > min && a <= max);
}

- (float)normalizeAngle:(float)angle
                   from:(float)min
                     to:(float)max
{
    if (angle > max || angle < min) {
        NSLog(@"normalizeAngle out of range,");
    }
    
    return (angle - min) / (max - min);
}
#pragma mark - Touch events
- (void)touchesBegan:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    self.selectedLine = nil;
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
    // Let's put in a log statement to see the order of events
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches) {
        CGPoint location = [t locationInView:self];
        
        BNRLine *line = [[BNRLine alloc] init];
        line.begin = location;
        line.end = location;
        
        NSValue *key = [NSValue valueWithNonretainedObject:t];

        self.linesInProgress[key] = line;
    }
    
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    // Let's put in a log statement to see the order of events
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches) {
        
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        
        BNRLine *line = self.linesInProgress[key];
        
        [self velocityToWidth:t withLine:line];
        
        line.end = [t locationInView:self];
        
        if (self.fixedColor == nil)
        {
            float rad = [self lineToAngleRadian: line];
            line.color = [self radianToColor:rad];
        }
        else {
            line.color = [self fixedColor];
        }
    }
    
    [self setNeedsDisplay];
}

- (void)velocityToWidth:(UITouch *)touch withLine:(BNRLine*) line
{
    CGPoint location = [touch locationInView:self];
    CGPoint prevLocation = [touch previousLocationInView:self];
    CGFloat distanceFromPrevious = hypot(location.x-prevLocation.x,
                                         location.y-prevLocation.y);
    line.width = distanceFromPrevious/7.5 + 5;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Let's put in a log statement to see the order of events
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        
        BNRLine *line = self.linesInProgress[key];
        
        [self.finishedLines addObject:line];
        [self.linesInProgress removeObjectForKey:key];
    }
    
    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet *)touches
               withEvent:(UIEvent *)event
{
    // Let's put in a log statement to see the order of events
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        [self.linesInProgress removeObjectForKey:key];
    }
    
    [self setNeedsDisplay];
}
@end
