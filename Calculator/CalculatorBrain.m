//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Oleksandr Kulakov on 4/12/13.
//  Copyright (c) 2013 Oleksandr Kulakov. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain ()
@property (nonatomic) BOOL topOfTheLine;

@property (strong, nonatomic) NSMutableArray *programStack;

@end

@implementation CalculatorBrain
@synthesize programStack = _programStack;
@synthesize topOfTheLine;
@synthesize testVariableValue = _testVariableValue;

- (id)init
{
    self = [super init];
    if (self) {
        [self setTestVariableValue:[NSArray arrayWithObjects:@0, @0, @0, nil]];
    }
    return self;
}

- (NSMutableArray *) programStack
{
    if (!_programStack)
    {
        _programStack = [[NSMutableArray alloc]init];
    }
    return _programStack;
}

- (NSArray *) testVariableValue
{
    if (!_testVariableValue)
    {
        _testVariableValue = [[NSMutableArray alloc]init];
    }
    return _testVariableValue;
}

- (void) pushOperand: (double) operand
{
    NSNumber *operandObject = [NSNumber numberWithDouble:operand];
    [self.programStack addObject:operandObject];
}

- (void) pushVariable:(NSString *)variable
{
    [self.programStack addObject:variable];
}

- (double) performOperetion: (NSString*) operation
{    
    NSArray *keys = [NSArray arrayWithObjects:@"x", @"a", @"b", nil];
    NSDictionary *variableValues = [NSDictionary dictionaryWithObjects:self.testVariableValue forKeys:keys];
    if (![operation isEqualToString:@"nothing"])
    {
        [self.programStack addObject:operation];
    }    
    return [CalculatorBrain runProgram: self.program usingVariableValues:variableValues];
}

- (NSString *) performOperetion2
{
    return [CalculatorBrain runProgram2:self.program];
}

- (id) program;
{
    return [self.programStack mutableCopy];
}


+ (NSString *) descriptionOfProgram:(id) program
{
    NSSet *twoOperand = [NSSet setWithObjects:@"+", @"-", @"*", @"/",nil];
    NSSet *oneOperand = [NSSet setWithObjects:@"sqrt", @"sin", @"cos",nil];
    NSSet *noOperand = [NSSet setWithObjects:@"π",nil];
    NSString *result = @"";
    NSMutableArray *stack = program;
    for (int i=0; i<[stack count]; i++)
    {
        if ([noOperand  containsObject: [stack objectAtIndex: i]])
        {
            result = @"π";
        }
        else if ([oneOperand  containsObject: [stack objectAtIndex: i]] && i >= 1)
        {
            NSString *object = [NSString stringWithFormat:@"%@",[stack objectAtIndex: (i-1)]];
            if ([object characterAtIndex: 0] == '(')
            {
                result = [NSString stringWithFormat:@"%@(%@)", [stack objectAtIndex:i], [stack objectAtIndex: (i-1)]];
                
            }
            else
            {
                result = [NSString stringWithFormat:@"%@(%@)", [stack objectAtIndex:i], [stack objectAtIndex: (i-1)]];
            }            
            [stack replaceObjectAtIndex:i withObject:result];
            [stack removeObjectAtIndex: (i-1)];
            result = [self descriptionOfProgram:stack];
        }
        else if ([oneOperand  containsObject: [stack objectAtIndex: i]] && i < 1)
        {
            result = [NSString stringWithFormat:@"Error"];
        }

        else if ([twoOperand  containsObject: [stack objectAtIndex: i]] && i >= 2)
        {
            if ([[stack objectAtIndex: i] isEqualToString:@"*"] || [[stack objectAtIndex: i] isEqualToString:@"/"])
            {
                if ([[stack objectAtIndex:(i-1)] isKindOfClass:[NSString class]] && [[stack objectAtIndex:(i-1)] length] > 1)
                {
                    if ([[stack objectAtIndex:(i-1)] rangeOfString:@"+"].location != NSNotFound || [[stack objectAtIndex:(i-1)] rangeOfString:@"-"].location != NSNotFound)
                    {
                        NSString *firstOperand;
                        if ([[stack objectAtIndex:(i-2)] isKindOfClass:[NSString class]])
                        {
                            if ([[stack objectAtIndex:(i-2)] rangeOfString:@"+"].location != NSNotFound || [[stack objectAtIndex:(i-2)] rangeOfString:@"-"].location != NSNotFound)
                            {
                                firstOperand = [NSString stringWithFormat:@"(%@)", [stack objectAtIndex:(i-2)]];
                            }
                        }
                        else
                        {
                            firstOperand = [NSString stringWithFormat:@"%@", [stack objectAtIndex:(i-2)]];
                        }
                        result = [NSString stringWithFormat:@"%@ %@ (%@)", firstOperand, [stack objectAtIndex:i], [stack objectAtIndex:(i-1)]];
                    }                                    }
                else if ([[stack objectAtIndex:(i-2)] isKindOfClass:[NSString class]] && [[stack objectAtIndex:(i-2)] length] > 1)
                {
                    result = [NSString stringWithFormat:@"(%@) %@ %@", [stack objectAtIndex:(i-2)], [stack objectAtIndex:i], [stack objectAtIndex:(i-1)]];
                }
                else
                {
                     result = [NSString stringWithFormat:@"%@ %@ %@", [stack objectAtIndex:(i-2)], [stack objectAtIndex:i], [stack objectAtIndex:(i-1)]];
                }
            }
            else
            {
                result = [NSString stringWithFormat:@"%@ %@ %@", [stack objectAtIndex:(i-2)], [stack objectAtIndex:i], [stack objectAtIndex:(i-1)]];
            }            
            [stack replaceObjectAtIndex:i withObject:result];
            [stack removeObjectAtIndex:i-1];
            [stack removeObjectAtIndex:i-2];
            result = [self descriptionOfProgram:stack];           
        }
        else if ([twoOperand  containsObject: [stack objectAtIndex: i]] && i < 2)
        {
            result = [NSString stringWithFormat:@"Error"];        }

        else
        {            
            if ([stack count])
            {
                result = [NSString stringWithFormat:@"%@", [stack componentsJoinedByString:@" "]];                
            }
        }
    }    
    return result;
}

+ (double) popOperandOffStack: (NSMutableArray *) stack
{
    double result = 0;
    id topOfStack = [stack lastObject];
    if (topOfStack)
    {
        [stack removeLastObject];
    }
    if ([topOfStack isKindOfClass:[NSNumber class]])
    {
        result = [topOfStack doubleValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]])
    {
        NSString *operation = topOfStack;
        if ([operation isEqualToString:@"+"])
        {            
            result = [self popOperandOffStack:stack]+[self popOperandOffStack:stack];
        }
        else if ([operation isEqualToString:@"*"])
        {
            result = [self popOperandOffStack:stack]*[self popOperandOffStack:stack];
        }
        else if ([operation isEqualToString:@"/"])
        {
            double divisor = [self popOperandOffStack:stack];
            if (divisor)
            {
                result = [self popOperandOffStack:stack]/divisor;
            }
        }
        else if ([operation isEqualToString:@"-"])
        {
            double subtrahend = [self popOperandOffStack:stack];
            if (subtrahend!=0)
            {
                result = [self popOperandOffStack:stack]-subtrahend;
            }     
        }
        else if ([operation isEqualToString:@"sin"])
        {
            result = (double) sin([self popOperandOffStack:stack]);
            
        }
        else if ([operation isEqualToString:@"cos"])
        {
            result = (double) cos([self popOperandOffStack:stack]);
        }
        else if ([operation isEqualToString:@"sqrt"])
        {
            double value = [self popOperandOffStack:stack];
            if (value >= 0)
            {
                result = (double) sqrt(value);
            }
            else
            {
                return 0;
            }
        }
        else if ([operation isEqualToString:@"log"])
        {
            result = (double) log([self popOperandOffStack:stack]);
        }
        else if ([operation isEqualToString:@"e"])
        {
            result = (double) M_E;
        }
        if ([operation isEqualToString:@"π"])
        {
            result = (double) M_PI;
        }
    }
    return result;
}

+ (double) runProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]])
    {
        stack = [program mutableCopy];
    }    
    return [self popOperandOffStack: stack];
}

+ (NSString *) runProgram2:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]])
    {
        stack = [program mutableCopy];
    }
    return [self descriptionOfProgram: stack];
}

 
+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues
{    
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]])
    {
        stack = [program mutableCopy];
    }
    for (int i=0; i<[stack count]; i++)
    {
        NSArray *keys = [NSArray arrayWithObjects:@"x", @"a", @"b", nil];
        NSSet *variables = [[NSSet alloc] initWithArray:keys];

        if ([variables  containsObject: [stack objectAtIndex: i]])
        {
            [stack replaceObjectAtIndex:i withObject:[variableValues objectForKey:[stack objectAtIndex: i]]];        
        }
    }
    
    return [self popOperandOffStack: stack];
   }

- (double) performFunction: (NSString*) function
{
    double result = 0;    
    [self pushOperand:result];
    return result;
}

- (NSString *) lastObject
{
    NSNumber *object = [self.programStack lastObject];
    NSString *result = [NSString stringWithFormat:@"%@", object];
    return result;
}

- (void) clearMemory
{
    [self.programStack removeAllObjects];
}


- (void) deleteLastObject
{
    [self.programStack removeLastObject];
}

@end
