//
//  GraphViewController.h
//  Calculator
//
//  Created by Oleksandr Kulakov on 5/7/13.
//  Copyright (c) 2013 Oleksandr Kulakov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;
@class CalculatorBrain;

@interface GraphViewController : UIViewController

@property (nonatomic) int graph;
@property (nonatomic, strong) CalculatorBrain *gvcBrain;

@end
