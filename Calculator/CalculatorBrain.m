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
    if (self)
    {
        [self setTestVariableValue:[NSArray arrayWithObjects:@0, nil]];
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
    NSArray *keys = [NSArray arrayWithObjects:@"x", nil];
    NSDictionary *variableValues = [NSDictionary dictionaryWithObjects:self.testVariableValue forKeys:keys];
    if (![operation isEqualToString:@"nothing"])
    {
        [self.programStack addObject:operation];
    }    
    return [CalculatorBrain runProgram: self.program usingVariableValues:variableValues];
}

- (NSString *) secondPerformOperetion
{
    return [CalculatorBrain runSecondProgram:self.program];
}

- (id) program;
{
    return [self.programStack mutableCopy];
}


+ (NSString *) descriptionOfProgram:(id) program
{
    NSSet *twoOperand = [NSSet setWithObjects:@"+", @"-", @"*", @"/",nil];
    NSSet *oneOperand = [NSSet setWithObjects:@"sqrt", @"sin", @"cos",nil];
    NSString *result = @"Error";
    NSMutableArray *stack = program;
    for (int i=0; i<[stack count]; i++)
    {
#define LAST_OBJECT [stack objectAtIndex: i]
#define PREVIOUS_OBJECT [stack objectAtIndex: i-1]
#define PREPREVIOUS_OBJECT [stack objectAtIndex: i-2]
                
        if ([oneOperand  containsObject: LAST_OBJECT] && i >= 1)
        {                      
        result = [NSString stringWithFormat:@"%@(%@)", LAST_OBJECT, PREVIOUS_OBJECT];
        [stack replaceObjectAtIndex:i withObject:result];
        [stack removeObjectAtIndex: (i-1)];
        result = [self descriptionOfProgram:stack];
        }
        else if ([oneOperand  containsObject: LAST_OBJECT] && i < 1)
        {
            result = [NSString stringWithFormat:@"Error"];
        }
        else if ([twoOperand  containsObject: LAST_OBJECT] && i >= 2)
        {
            if ([LAST_OBJECT isEqualToString:@"*"] || [LAST_OBJECT isEqualToString:@"/"])
            {
                if ([PREVIOUS_OBJECT isKindOfClass:[NSString class]] && [PREVIOUS_OBJECT length] > 1 && ([PREVIOUS_OBJECT rangeOfString:@"+"].location != NSNotFound || [PREVIOUS_OBJECT rangeOfString:@"-"].location != NSNotFound))
                {
                    NSString *firstOperand = @"Error";
                    if ([PREPREVIOUS_OBJECT isKindOfClass:[NSString class]] && ([PREPREVIOUS_OBJECT rangeOfString:@"+"].location != NSNotFound || [PREPREVIOUS_OBJECT rangeOfString:@"-"].location != NSNotFound))
                    {
                        firstOperand = [NSString stringWithFormat:@"(%@)", PREPREVIOUS_OBJECT];
                    }
                    else
                    {
                        firstOperand = [NSString stringWithFormat:@"%@", PREPREVIOUS_OBJECT];
                    }
                    result = [NSString stringWithFormat:@"%@ %@ (%@)", firstOperand, LAST_OBJECT, PREVIOUS_OBJECT];
                }
                else if ([PREPREVIOUS_OBJECT isKindOfClass:[NSString class]] && [PREPREVIOUS_OBJECT length] > 1)
                {
                    result = [NSString stringWithFormat:@"(%@) %@ %@", PREPREVIOUS_OBJECT, LAST_OBJECT, PREVIOUS_OBJECT];
                }
                else
                {
                    result = [NSString stringWithFormat:@"%@ %@ %@", PREPREVIOUS_OBJECT, LAST_OBJECT, PREVIOUS_OBJECT];
                }
            }
            else
            {
                result = [NSString stringWithFormat:@"%@ %@ %@", PREPREVIOUS_OBJECT, LAST_OBJECT, PREVIOUS_OBJECT];
            }            
            [stack replaceObjectAtIndex:i withObject:result];
            [stack removeObjectAtIndex:i-1];
            [stack removeObjectAtIndex:i-2];
            result = [self descriptionOfProgram:stack];           
        }
        else if ([twoOperand  containsObject: LAST_OBJECT] && i < 2)
        {
            result = [NSString stringWithFormat:@"Error"];
        }
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

+ (NSString *) runSecondProgram:(id)program
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
        NSArray *keys = [NSArray arrayWithObjects:@"x", nil];
        NSSet *variables = [[NSSet alloc] initWithArray:keys];

        if ([variables  containsObject: LAST_OBJECT])
        {
            [stack replaceObjectAtIndex:i withObject:[variableValues objectForKey:LAST_OBJECT]];
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
