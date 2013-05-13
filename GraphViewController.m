//
//  GraphViewController.m
//  Calculator
//
//  Created by Oleksandr Kulakov on 5/7/13.
//  Copyright (c) 2013 Oleksandr Kulakov. All rights reserved.
//

#import "GraphViewController.h"
#import "AxesView.h"

@interface GraphViewController()
@property (nonatomic, weak) IBOutlet AxesView *axesView;

@end

@implementation GraphViewController

@synthesize graph = _graph;
@synthesize axesView = _axesView;
@synthesize gvcBrain = _gvcBrain;

- (IBAction)handTap:(UITapGestureRecognizer *)sender
{
    CGPoint midPoint;
    midPoint.x = self.view.bounds.size.width/2;
    midPoint.y = self.view.bounds.size.height/2;
    ((AxesView*)self.view).midPoint = midPoint;
    [self.axesView setNeedsDisplay];
}

- (IBAction)controlPan: (UIPanGestureRecognizer*) recognizer
{
    CGPoint translation = [recognizer translationInView:self.view];
    CGPoint newMidPoint;
    newMidPoint.x = ((AxesView*)self.view).midPoint.x + translation.x;
    newMidPoint.y = ((AxesView*)self.view).midPoint.y + translation.y;
    ((AxesView*)self.view).midPoint = newMidPoint;
    [recognizer setTranslation:CGPointMake(0,0) inView:self.view];
    [self.axesView setNeedsDisplay];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    ((AxesView*)self.view).avBrain = self.gvcBrain;
    CGPoint midPoint;
    CGFloat size;
    size = self.axesView.bounds.size.width;
    midPoint.x = self.view.bounds.size.width/2;
    midPoint.y = self.view.bounds.size.height/2;
    ((AxesView*)self.view).midPoint = midPoint;
   ((AxesView*)self.view).size = size;
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



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    
    return YES; // support all orientations
}


@end

