//
//  AxesView.m
//  Calculator
//
//  Created by Oleksandr Kulakov on 5/7/13.
//  Copyright (c) 2013 Oleksandr Kulakov. All rights reserved.
//

#import "AxesView.h"
#import "AxesDrawer.h"
#import "GraphDrawer.h"
#import "CalculatorBrain.h"

@interface AxesView ()


@end

@implementation AxesView
@synthesize scale = _scale;
@synthesize avBrain = _avBrain;
@synthesize midPoint = _midPoint;
@synthesize size = _size;

#define DEFAULT_SCALE 10

- (CGFloat)scale
{
    if (!_scale)
    {
        return DEFAULT_SCALE;
    }
    else
    {
        return _scale;
    }
}

- (void)setScale:(CGFloat)scale
{
    if (scale != _scale)
    {
        _scale = scale;
        [self setNeedsDisplay]; // any time our scale changes, call for redraw
    }
}

- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
       (gesture.state == UIGestureRecognizerStateEnded))
    {
        self.scale *= gesture.scale; // adjust our scale
        gesture.scale = 1;          // reset gestures scale to 1 (so future changes are incremental, not cumulative)       
    }    
}

- (void)setup
{
    self.contentMode = UIViewContentModeRedraw; // if our bounds changes, redraw ourselves
}

- (void)awakeFromNib
{
    [self setup]; // get initialized when we come out of a storyboard
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    [self setup]; 
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    [[UIColor redColor] setStroke];   
    [AxesDrawer drawAxesInRect:self.bounds originAtPoint:[self midPoint] scale: self.scale];
    [GraphDrawer drawGraphInRect:self.bounds originAtPoint:[self midPoint] scale: self.scale withBrain:self.avBrain withSize: self.size];
}

//- (void) setAvBrain:(CalculatorBrain *)avBrain
//{
//    _avBrain = avBrain;
//}


@end
