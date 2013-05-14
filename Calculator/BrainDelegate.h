//
//  BrainDelegate.h
//  Calculator
//
//  Created by Oleksandr Kulakov on 5/14/13.
//  Copyright (c) 2013 Oleksandr Kulakov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CalculatorBrain;

@protocol BrainDelegate

- (CalculatorBrain *) brain;

@end

