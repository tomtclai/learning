//
//  GridViewController.m
//  Matchismo
//
//  Created by Tom Lai on 8/18/15.
//  Copyright (c) 2015 Lai. All rights reserved.
//

#import "GridViewController.h"
#import "Grid.h"
@interface GridViewController ()
@property (nonatomic, strong) Grid* grid;
// derived input
@property (nonatomic, readonly) CGSize sizeOfView;
@end

@implementation GridViewController

- (Grid*)grid {
    if (!_grid)
    {
        _grid = [[Grid alloc]init];
    }
    return _grid;
}

- (CGSize)sizeOfView {
    return self.view.bounds.size;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIDevice *device = [UIDevice currentDevice];
    [device beginGeneratingDeviceOrientationNotifications];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self
           selector:@selector(orientationChanged:)
               name:UIDeviceOrientationDidChangeNotification
             object:device];
    
    self.grid.size = self.sizeOfView;
    self.grid.cellAspectRatio = self.elementAspectRatio;
    self.grid.minimumNumberOfCells = self.minNumOfButtons;
    

}

- (void)viewDidLayoutSubviews
{
    [self layoutButtons];
}
- (void)orientationChanged:(NSNotification *)note {

    self.grid.size = self.sizeOfView;
    [self layoutButtons];
}
- (void)layoutButtons {
    if (self.grid.inputsAreValid) {
        NSUInteger row = self.grid.rowCount;
        NSUInteger col = self.grid.columnCount;
        
        for (NSUInteger y = 0 ; y < row; y ++)
        {
            for (NSUInteger x = 0; x < col; x ++)
            {
                if (x+y > self.cardButtons.count) break;
                
                UIButton * buttonI = (UIButton *) self.cardButtons[x+y];
                
                [buttonI setFrame:[self.grid frameOfCellAtRow:y
                                                    inColumn:x]];
                NSLog(@"%f", [self.grid frameOfCellAtRow:y
                                                inColumn:x].origin.x);
                NSLog(@"%f", buttonI.frame.origin.x);
                //TODO: animate this
            }
        }
    }
}
- (void)dealloc {
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
