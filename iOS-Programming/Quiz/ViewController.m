//
//  ViewController.m
//  Quiz
//
//  Created by Tsz Chun Lai on 2/1/15.
//  Copyright (c) 2015 BNR. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, assign) int currentQuestionIndex;

// The model objects
@property (nonatomic ,copy) NSMutableArray *questions;
@property (nonatomic ,copy) NSMutableArray *answers;

// The view objects - don't worry about IBOutlet -
// we'll talk about it shortly
@property (nonatomic ,weak) IBOutlet UILabel *questionLabel;
@property (nonatomic ,weak) IBOutlet UILabel *answerLabel;
@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    // Call the init method implemented by the superclass
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Create two arrays and make the pointers point to them
        _questions = [[NSMutableArray alloc] init];
        _answers = [[NSMutableArray alloc] init];

        // Add _questions and _answers to the arrays
        [_questions addObject:@"What is 7+7?"];
        [_answers addObject:@"14"];

        [_questions addObject:@"What is the capital of Vermont"];
        [_answers addObject:@"Montpelier"];

        [_questions addObject:@"From what is cognac made?"];
        [_answers addObject:@"Grapes"];
    }

    // Return the address of the new object
    return self;
}

- (IBAction)showQuestion:(id)sender
{
    // Step to the next question
    _currentQuestionIndex++;

    // Am I pass the last question?
    if ( _currentQuestionIndex == [_questions count])
    {
        // Go back the the first question
        _currentQuestionIndex = 0;
    }

    // Get the string at that index in the _questions array
    NSString* question = [_questions objectAtIndex:_currentQuestionIndex];

    // Log the string to the console
    NSLog(@"displaying question %@", question);

    [self flyLabel:_questionLabel];

    // Display the string in the question field
    [_questionLabel setText:question];

    // Clear the answer field
    [_answerLabel setText:@"???"];

}
- (void)flyLabelsAnimation
{
    [self flyLabel:self.answerLabel];
    [self flyLabel:self.questionLabel];
}

- (void)flyLabel:(UILabel *)aLabel
{
    CGRect labelRectOrig = aLabel.frame;
    
    int viewWidth = self.view.frame.size.width;
    int labelCenterY = aLabel.center.y;
    
    UILabel * oldLabel = [[UILabel alloc]initWithFrame:labelRectOrig];
    oldLabel.text = [aLabel.text copy];
    [oldLabel setTextAlignment:NSTextAlignmentCenter];


    [[self view] addSubview:oldLabel];
    // Fly-in-from-left starts here
    aLabel.alpha = 0;
    aLabel.center = CGPointMake(0, labelCenterY);


    [UIView animateKeyframesWithDuration:.5
                                   delay:0
                                 options:0
                              animations:^{
                                  aLabel.frame = labelRectOrig;
                                  aLabel.alpha = 1;

                                  oldLabel.center = CGPointMake(viewWidth, labelCenterY);
                                  oldLabel.alpha = 0;
                              }
                              completion:nil];

}
- (IBAction)showAnswer:(id)sender
{
    // What is the answer to the current question?
    NSString * answer = [_answers objectAtIndex:_currentQuestionIndex];
    NSLog(@"displaying answer %@", answer);
    [self flyLabel:_answerLabel];
    // Display it in the answer field
    [_answerLabel setText:answer];
}
@end
