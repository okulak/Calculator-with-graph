//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Oleksandr Kulakov on 4/12/13.
//  Copyright (c) 2013 Oleksandr Kulakov. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CalculatorBrain : NSObject


- (void) pushOperand: (double) operand;
- (void) pushVariable: (NSString *) variable;
- (void) updateWithProgram: (NSArray*)program;
- (void) deleteLastObject;
- (double) performOperetion: (NSString*) operation;
- (NSString *) secondPerformOperetion;
- (NSString *) lastObject;
- (void) clearMemory;

//program is always garanted to be Property List 
@property (nonatomic, readonly)NSMutableArray *program;
@property (strong, nonatomic)  NSArray *testVariableValue;

+ (double) runProgram: (id) program;
+ (NSString *) runSecondProgram: (id) program;
+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues;
+ (NSString *) descriptionOfProgram: (id) program;
@end
