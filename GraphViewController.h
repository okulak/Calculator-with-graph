//
//  GraphViewController.h
//  Calculator
//
//  Created by Oleksandr Kulakov on 5/7/13.
//  Copyright (c) 2013 Oleksandr Kulakov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrainDelegate.h"
#import "SplitViewBarButtonItemPresenter.h"


@class UIPopoverController;
@class ViewController;
@class CalculatorBrain;

@interface GraphViewController : UIViewController <SplitViewBarButtonItemPresenter>

@property (nonatomic) int graph;
@property (nonatomic, weak) id <BrainDelegate> delegate;
@property (nonatomic) CalculatorBrain * gvBrain;
@property (nonatomic) UIPopoverController *masterPopoverController;

- (void) axesViewSetNeedDisplay;

@end
