//
//  AxesView.h
//  Calculator
//
//  Created by Oleksandr Kulakov on 5/7/13.
//  Copyright (c) 2013 Oleksandr Kulakov. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CalculatorBrain;

@interface AxesView : UIView

@property (nonatomic) CGFloat scale;
@property (strong, nonatomic) CalculatorBrain *avBrain;
@property (nonatomic) CGPoint midPoint;
@property (nonatomic) CGFloat size;


@end
