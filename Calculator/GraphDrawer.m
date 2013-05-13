//
//  GraphDrawer.m
//  Calculator
//
//  Created by Oleksandr Kulakov on 5/8/13.
//  Copyright (c) 2013 Oleksandr Kulakov. All rights reserved.
//

#import "GraphDrawer.h"
#import "ViewController.h"
#import "CalculatorBrain.h"

@interface GraphDrawer ()


@end

@implementation GraphDrawer



+ (void)drawGraphInRect:(CGRect)bounds originAtPoint:(CGPoint)axisOrigin scale:(CGFloat)scale withBrain: (CalculatorBrain*) brain withSize:(CGFloat)size
{

    NSLog(@"programStack %@", [brain program]);
    CGContextRef context = UIGraphicsGetCurrentContext();
	UIGraphicsPushContext(context);
    CGContextSetLineWidth(context, 2.0);
    [[UIColor blueColor] setStroke];
    CGContextBeginPath(context);
   	BOOL firstLine = NO;
    NSLog(@"axesOrigin %f", size);
    for ( CGFloat x = 0; x <= size; x+=0.5)
    {
        CGPoint zeroPoint;
        CGPoint realValue;
        zeroPoint.x = (x - axisOrigin.x);
        realValue.x = zeroPoint.x/scale;
        NSArray *testValues;
        testValues = [NSArray arrayWithObjects: [NSNumber numberWithFloat:realValue.x],[NSNumber numberWithFloat:0],[NSNumber numberWithFloat:0], nil];
        [brain setTestVariableValue: testValues];              
        realValue.y = [brain performOperetion: @"nothing"];
        zeroPoint.y = realValue.y * scale;
        zeroPoint.y = realValue.y * scale;
        CGFloat function = axisOrigin.y-zeroPoint.y;
        testValues = [NSArray arrayWithObjects: [NSNumber numberWithFloat:0],[NSNumber numberWithFloat:0],[NSNumber numberWithFloat:0], nil];
        [brain setTestVariableValue: testValues];
        
        if (!firstLine)
        {
            CGContextMoveToPoint(context, x, function);
            firstLine = YES;
                 
        }
        else if (!realValue.y || !isfinite(realValue.y))
        {
            CGContextMoveToPoint(context, x, axisOrigin.y);
            firstLine = NO;
        }
        else
        {       
           CGContextAddLineToPoint(context,x, function);  
        }
        
        
    }
    CGContextStrokePath(context);
    [[UIColor greenColor] setFill];    
	UIGraphicsPopContext();
    
}
@end
