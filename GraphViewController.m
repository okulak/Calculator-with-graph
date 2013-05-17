//
//  GraphViewController.m
//  Calculator
//
//  Created by Oleksandr Kulakov on 5/7/13.
//  Copyright (c) 2013 Oleksandr Kulakov. All rights reserved.
//

#import "GraphViewController.h"
#import "AxesView.h"

static GraphViewController* settings = nil;

@interface GraphViewController()
{
    NSUserDefaults *_userDefaults;
}

@property (nonatomic, weak) IBOutlet AxesView *axesView;
@property (nonatomic, weak) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) NSUserDefaults *defaults;

@end

@implementation GraphViewController

@synthesize graph = _graph;
@synthesize axesView = _axesView;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;
@synthesize toolbar = _toolbar;
@synthesize delegate = _delegate;
@synthesize gvBrain = _gvBrain;
@synthesize masterPopoverController = _masterPopoverController;




+ (GraphViewController*) sharedSettings
{
    if (settings == nil)
    {
        settings = [GraphViewController new];
        settings.defaults = [NSUserDefaults standardUserDefaults];
        [settings.defaults synchronize];
    }
    return settings;
}

- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
    if (splitViewBarButtonItem != _splitViewBarButtonItem) {
        NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
        if (_splitViewBarButtonItem) [toolbarItems removeObject:_splitViewBarButtonItem];
        if (splitViewBarButtonItem) [toolbarItems insertObject:splitViewBarButtonItem atIndex:0];
        self.toolbar.items = toolbarItems;
        _splitViewBarButtonItem = splitViewBarButtonItem;
        
        splitViewBarButtonItem.target = self;
        splitViewBarButtonItem.action = @selector(test:);
    }
}

- (IBAction)handTap:(UITapGestureRecognizer *)sender
{
    CGPoint midPoint;
    midPoint.x = self.axesView.bounds.size.width/2;
    midPoint.y = self.axesView.bounds.size.height/2;
    self.axesView.midPoint = midPoint;
    [self.axesView setNeedsDisplay];
}

- (IBAction)controlPan:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self.view];
    CGPoint newMidPoint;
    newMidPoint.x = self.axesView.midPoint.x + translation.x;
    newMidPoint.y = self.axesView.midPoint.y + translation.y;
    self.axesView.midPoint = newMidPoint;
    [recognizer setTranslation:CGPointMake(0,0) inView:self.view];
    [self.axesView setNeedsDisplay];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self axesViewSetNeedDisplay];
    self.masterPopoverController = [[UIPopoverController alloc] initWithContentViewController:[self.splitViewController.viewControllers objectAtIndex:0]];
}

-(void)test:(id)sender
{
    if(!self.masterPopoverController.isPopoverVisible)
        [self.masterPopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    else
        [self.masterPopoverController dismissPopoverAnimated:YES];
}

- (void) viewWillDisappear:(BOOL)animated
{
    CGFloat lastScale = self.axesView.scale;
    CGPoint midPoint =  self.axesView.midPoint;
    _userDefaults = [NSUserDefaults standardUserDefaults];
    [_userDefaults setFloat: lastScale forKey:@"Last scale"];
    [_userDefaults setFloat: midPoint.x forKey:@"Mid point by x"];
    [_userDefaults setFloat: midPoint.y forKey:@"Mid point by y"];    
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

- (void) axesViewSetNeedDisplay
{
    _userDefaults = [NSUserDefaults standardUserDefaults];
    self.axesView.avBrain = self.gvBrain;
    CGPoint midPoint;
    midPoint.x = [_userDefaults floatForKey:@"Mid point by x"];
    midPoint.y = [_userDefaults floatForKey:@"Mid point by y"];
    if (!midPoint.x || !midPoint.y)
    {
        midPoint.x = self.view.bounds.size.width/2;
        midPoint.y = self.view.bounds.size.height/2;
    }
    CGFloat size;
    size = self.axesView.bounds.size.width;
    self.axesView.midPoint = midPoint;
    self.axesView.size = size;
    self.axesView.scale = [_userDefaults floatForKey:@"Last scale"];
    [self.axesView setNeedsDisplay];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES; // support all orientations
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if (self.masterPopoverController.isPopoverVisible)
    {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}




@end

