//
//  ViewController.h
//  Calculator
//
//  Created by Oleksandr Kulakov on 4/12/13.
//  Copyright (c) 2013 Oleksandr Kulakov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CalculatorBrain;

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *display;
@property (weak, nonatomic) IBOutlet UILabel *secondDisplay;
@property (nonatomic) int graph;
@property (nonatomic) CGFloat lastScale;


@end
