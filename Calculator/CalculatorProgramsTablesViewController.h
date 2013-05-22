//
//  CalculatorProgramsTablesViewController.h
//  Calculator
//
//  Created by Oleksandr Kulakov on 5/21/13.
//  Copyright (c) 2013 Oleksandr Kulakov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CalculatorProgramsTablesViewController;
@protocol  CalculatorProgramsTablesViewControllerDelegate
@optional
- (void) calculatorProgramsTablesViewController: (CalculatorProgramsTablesViewController *)sender choseProgram: (id)program;

@end

@interface CalculatorProgramsTablesViewController : UITableViewController
@property (nonatomic, strong) NSMutableArray *programs;
@property (nonatomic, weak) id <CalculatorProgramsTablesViewControllerDelegate> delegate;
@end
