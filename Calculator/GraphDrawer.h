//
//  GraphDrawer.h
//  Calculator
//
//  Created by Oleksandr Kulakov on 5/8/13.
//  Copyright (c) 2013 Oleksandr Kulakov. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CalculatorBrain;

@interface GraphDrawer : NSObject

+ (void)drawGraphInRect:(CGRect)bounds
         originAtPoint:(CGPoint)axisOrigin
                 scale:(CGFloat)pointsPerUnit
              withBrain: (CalculatorBrain*) brain
                withSize:(CGFloat) size;


@end
