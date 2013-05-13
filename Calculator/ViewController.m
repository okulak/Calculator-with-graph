//
//  ViewController.m
//  Calculator
//
//  Created by Oleksandr Kulakov on 4/12/13.
//  Copyright (c) 2013 Oleksandr Kulakov. All rights reserved.
//

#include <math.h>
#import "ViewController.h"
#import "CalculatorBrain.h"
#import "GraphViewController.h"
#import "AxesView.h"

@interface ViewController ()

@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic) BOOL topOfTheLine;
@property (nonatomic) BOOL checkForOperation;
@property (nonatomic) BOOL checkForVariables;
@property (nonatomic, weak) IBOutlet AxesView *axesView;

@end

@implementation ViewController
@synthesize display;
@synthesize secondDisplay;
@synthesize userIsInTheMiddleOfEnteringANumber;
@synthesize topOfTheLine;
@synthesize brain = _brain;
@synthesize checkForOperation;
@synthesize checkForVariables;
@synthesize axesView = _axesView;
@synthesize graph = _graph;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.axesView.avBrain = self.brain;
    CGPoint midPoint;
    CGFloat widhtOfView;
    midPoint.x = self.axesView.bounds.size.width/2;
    midPoint.y = self.axesView.bounds.size.height/2;
    widhtOfView = self.axesView.bounds.size.width;
    NSLog(@"midPoint in ViewController %f %f", midPoint.x, midPoint.y);
    self.axesView.midPoint = midPoint;
    self.axesView.size = widhtOfView;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidLoad];
    double result = [self.brain performOperetion:@"nothing"];
    self.display.text = [NSString stringWithFormat:@"%g", result];     
}

- (CalculatorBrain *) brain
{
    if (!_brain)
    {
        _brain = [[CalculatorBrain alloc]init];        
    }
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender
{
    checkForOperation = NO;
    NSString *digit = [sender currentTitle];
    if (self.userIsInTheMiddleOfEnteringANumber)
    {
       self.display.Text = [self.display.text stringByAppendingString:digit];       
    }
    else
    {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)enterPressed
{
    if (checkForVariables)
    {
        [self.brain pushVariable:self.display.text];
        checkForVariables = NO;
    }
    else
    {
        [self.brain pushOperand:[self.display.text doubleValue]];
    }
    self.display.text = @"0";
    self.userIsInTheMiddleOfEnteringANumber = NO;    
    if (topOfTheLine && ![self.secondDisplay.text isEqualToString:@"Error"])
    {
        self.secondDisplay.text = [self.secondDisplay.text stringByAppendingString:@" "];
        self.secondDisplay.text = [self.secondDisplay.text stringByAppendingString:[self.brain lastObject]];        
    }
    else 
    {
        self.secondDisplay.text= [self.brain lastObject];
        topOfTheLine = YES;
    }
    checkForOperation = YES;
}


- (IBAction)operationPressed:(UIButton *)sender
{
    if (self.userIsInTheMiddleOfEnteringANumber)
    {
        [self enterPressed];
    }
    NSString *operation = [sender currentTitle];
    double result = [self.brain performOperetion:operation];
    NSString *secondResult = [self.brain secondPerformOperetion];
    self.display.text = [NSString stringWithFormat:@"%g", result];
    self.secondDisplay.Text = [NSString stringWithFormat:@"%@", secondResult];
    checkForOperation = YES;
}


- (IBAction)pointPressed:(UIButton *)sender
{
    NSString *point = [sender currentTitle];
    NSRange range = [self.display.text rangeOfString:point];
    if (range.length == 0)
    {
        self.display.text = [self.display.text stringByAppendingString:point];
        self.userIsInTheMiddleOfEnteringANumber = YES;   
    }
}


- (IBAction)cPressed
{
    [self.brain clearMemory];
    self.display.text = [NSString stringWithFormat:@"0"];
    self.secondDisplay.text = [NSString stringWithFormat:@""];
    NSArray *testValues;
    testValues = [NSArray arrayWithObjects:[NSNumber numberWithDouble: 0], nil];
    [self.brain setTestVariableValue: testValues];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.topOfTheLine = NO;
    checkForOperation = YES;
    [self.axesView setNeedsDisplay];
}

- (IBAction)setVariables:(id)sender
{   
    double result = [self.brain performOperetion:@"nothing"];
    NSString *secondResult = [self.brain secondPerformOperetion];
    self.display.text = [NSString stringWithFormat:@"%g", result];
    self.secondDisplay.Text = [NSString stringWithFormat:@"%@", secondResult];
    [self.axesView setNeedsDisplay];
}

- (IBAction)variablesPressed:(id)sender
{
    if (![self.display.text isEqual:@"0"])
    {
        [self enterPressed]; 
    }
    checkForVariables = YES;
    checkForOperation = NO;
    NSString *digit = [sender currentTitle];
    if (self.userIsInTheMiddleOfEnteringANumber)
    {
        self.display.Text = [self.display.text stringByAppendingString:digit];        
    }
    else
    {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
   [self enterPressed];
}

- (IBAction)undoPressed
{
    if (self.userIsInTheMiddleOfEnteringANumber && self.display.text.length > 0)
    {
        NSMutableString *text = [self.display.text mutableCopy];
        [text deleteCharactersInRange:NSMakeRange([text length]-1, 1)];
        self.display.text = text;
        if (!self.display.text.length)
        {
            self.userIsInTheMiddleOfEnteringANumber= NO;           
        }
    }
    else
    {
        [self.brain deleteLastObject];
        double result = [self.brain performOperetion:@"nothing"];
        NSString *secondResult = [self.brain secondPerformOperetion];
        self.display.text = [NSString stringWithFormat:@"%g", result];
        self.secondDisplay.Text = [NSString stringWithFormat:@"%@", secondResult];
    }   
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //TODO pass brain to GraphView
    GraphViewController *gvc= (GraphViewController*)segue.destinationViewController;    
    gvc.gvcBrain = self.brain;
}

- (IBAction)controlPan:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self.axesView];
    CGPoint newMidPoint;
    newMidPoint.x = self.axesView.midPoint.x + translation.x;
    newMidPoint.y = self.axesView.midPoint.y + translation.y;
    self.axesView.midPoint = newMidPoint;
    [recognizer setTranslation:CGPointMake(0,0) inView:self.view];
    [self.axesView setNeedsDisplay];
}

- (IBAction)handTap:(UITapGestureRecognizer *)sender
{
    CGPoint midPoint;
    midPoint.x = self.axesView.bounds.size.width/2;
    midPoint.y = self.axesView.bounds.size.height/2;
    self.axesView.midPoint = midPoint;
    [self.axesView setNeedsDisplay];
}


- (void)setGraph:(int)graph
{
    _graph = graph;
    [self.axesView setNeedsDisplay]; // any time our Model changes, redraw our View
}


- (void)setAxesView:(AxesView *)axesView
{
    _axesView = axesView;
    // enable pinch gestures in the FaceView using its pinch: handler
    [self.axesView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.axesView action:@selector(pinch:)]];
}

@end
