//
//  BNRQuizViewController.m
//  Quiz
//
//  Created by John Gallagher on 1/6/14.
//  Copyright (c) 2014 John Gallagher. All rights reserved.
//

#import "BNRQuizViewController.h"

@interface BNRQuizViewController ()

@property (nonatomic, assign) int currentQuestionIndex;
@property (nonatomic, copy) NSArray *answers;
@property (nonatomic, copy) NSArray *questions;

@property (nonatomic, weak) IBOutlet UILabel *questionLabel;
@property (nonatomic, weak) IBOutlet UILabel *answerLabel;

@end

@implementation BNRQuizViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    // Call the init method implemented by the superclass
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self) {
        // Create two arrays filled with questions and answers
        // and make the pointers point to them

        self.questions = @[@"From what is cognac made?",
                           @"What is 7+7?",
                           @"What is the capital of Vermont?"];

        self.answers = @[@"Grapes",
                         @"14",
                         @"Montpelier"];
    }

    // Return the address of the new object
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)showQuestionButtonPressed:(UIButton *)sender
{
    // Step to the next question
    self.currentQuestionIndex++;

    // Am I pas the last question?
    if (self.currentQuestionIndex == [self.questions count]) {

        // Go back to the first question
        self.currentQuestionIndex = 0;
    }

    // Get the string at the index in the questions array
    NSString *question = self.questions[self.currentQuestionIndex];

    // Display the string in the question label
    self.questionLabel.text = question;

    // Reset the answer label
    self.answerLabel.text = @"???";


    [self flyLabelsAnimation];
}
- (void)flyLabelsAnimation
{
    CGRect questionRectOrig = self.questionLabel.frame;
    CGRect questionRectLeft = self.questionLabel.frame;
    CGRect questionRectRight = self.questionLabel.frame;
    CGRect answerRectOrig = self.answerLabel.frame;
    CGRect answerRectLeft = self.answerLabel.frame;
    CGRect answerRectRight = self.answerLabel.frame;
    
    UILabel * oldQuestionLabel = [[UILabel alloc]initWithFrame:questionRectOrig];
    oldQuestionLabel.text = self.questionLabel.text;
    
    UILabel * oldAnswerLabel = [[UILabel alloc]initWithFrame:answerRectOrig];
    oldAnswerLabel.text = self.answerLabel.text;

    questionRectLeft.origin.x = 0;
    questionRectRight.origin.x *= 2;
    answerRectLeft.origin.x = 0;
    answerRectRight.origin.x *= 2;

    
    // Fly-in-from-left starts here
    self.questionLabel.alpha = 0;
    self.answerLabel.alpha = 0;
    self.questionLabel.frame = answerRectLeft;
    self.answerLabel.frame = questionRectLeft;
    
    [UIView animateKeyframesWithDuration:0.2
                                   delay:0
                                 options:0
                              animations:^{
                                  self.questionLabel.frame = questionRectOrig;
                                  self.answerLabel.frame = answerRectOrig;
                                  self.questionLabel.alpha = 1;
                                  self.answerLabel.alpha = 1;
                                  
                                  oldQuestionLabel.frame = questionRectRight;
                                  oldAnswerLabel.frame = answerRectRight;
                                  oldQuestionLabel.alpha = 0;
                                  oldAnswerLabel.alpha = 0;
                              }
                              completion:nil];
    
}
- (IBAction)showAnswerButtonPressed:(UIButton *)sender
{
    // What is the answer to the current question?
    NSString *answer = self.answers[self.currentQuestionIndex];

    // Display it in the answer label
    self.answerLabel.text = answer;
}

@end
