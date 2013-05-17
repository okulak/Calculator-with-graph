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

@end

@implementation ViewController
@synthesize display;
@synthesize secondDisplay;
@synthesize userIsInTheMiddleOfEnteringANumber;
@synthesize topOfTheLine;
@synthesize brain = _brain;
@synthesize checkForOperation;
@synthesize checkForVariables;



- (GraphViewController *)splitViewGraphViewController
{
    id gvc = [self.splitViewController.viewControllers lastObject];
    if (![gvc isKindOfClass:[GraphViewController class]]) {
        gvc = nil;
    }
    return gvc;
}

- (void)setAndShowGraph:(CalculatorBrain *)brain
{
    if ([self splitViewGraphViewController])
    {                      // if in split view
        [self splitViewGraphViewController].gvBrain = brain;
        [[self splitViewGraphViewController] axesViewSetNeedDisplay];
        
    }
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
    [self setAndShowGraph:self.brain];
}

- (IBAction)setVariables:(id)sender
{   
    double result = [self.brain performOperetion:@"nothing"];
    NSString *secondResult = [self.brain secondPerformOperetion];
    self.display.text = [NSString stringWithFormat:@"%g", result];
    self.secondDisplay.Text = [NSString stringWithFormat:@"%@", secondResult];
    [self setAndShowGraph:self.brain];
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
    gvc.delegate = self;
}


- (void)awakeFromNib  // always try to be the split view's delegate
{
    [super awakeFromNib];
    self.splitViewController.delegate = self;
}

- (id <SplitViewBarButtonItemPresenter>)splitViewBarButtonItemPresenter
{
    id detailVC = [self.splitViewController.viewControllers lastObject];
    if (![detailVC conformsToProtocol:@protocol(SplitViewBarButtonItemPresenter)]) {
        detailVC = nil;
    }
    return detailVC;
}

- (id <BrainDelegate>)brainPresenter
{
    id brainVC = [self.splitViewController.viewControllers lastObject];
    if (![brainVC conformsToProtocol:@protocol(SplitViewBarButtonItemPresenter)]) {
        brainVC = nil;
    }
    return brainVC;
}


- (BOOL)splitViewController:(UISplitViewController *)svc
   shouldHideViewController:(UIViewController *)vc
              inOrientation:(UIInterfaceOrientation)orientation
{
    return [self splitViewBarButtonItemPresenter] ? UIInterfaceOrientationIsPortrait(orientation) : NO;
}

- (void)splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = self.navigationItem.title;
    NSLog(@"%@", self.title);
    [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = barButtonItem;
}

- (void)splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
       [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES; // support all orientations
}

@end
