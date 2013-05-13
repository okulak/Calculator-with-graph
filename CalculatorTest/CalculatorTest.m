//
//  CalculatorTest.m
//  CalculatorTest
//
//  Created by Oleksandr Kulakov on 4/22/13.
//  Copyright (c) 2013 Oleksandr Kulakov. All rights reserved.
//

#import "CalculatorTest.h"
#import "CalculatorBrain.h"
#import "ViewController.h"

@interface CalculatorTest ()
@property (strong, nonatomic) CalculatorBrain *brain;
@end

@implementation CalculatorTest

- (void)setUp
{
    [super setUp];
    self.brain = [[CalculatorBrain alloc] init];
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    self.brain = nil;
    [super tearDown];
}

//- (void)testMultiplicationResult
//{
//    [self.brain pushOperand:3.0];
//    [self.brain pushOperand:5.0];
//    [self.brain performOperetion:@"+"];
//    NSString *result = [CalculatorBrain descriptionOf:self.brain.secondProgramStack program: self.brain.program];
//    STAssertTrue([result  isEqualToString:@"(3+5)"], @"Must be (3+5)");
//}

- (void)testMultiplicationResult2
{
    [self.brain pushOperand:3.0];
    [self.brain pushOperand:5.0];
    [self.brain performOperetion:@"+"];
    [self.brain pushOperand:5.0];
    [self.brain performOperetion:@"+"];
    NSString *result = [self.brain secondPerformOperetion];
    STAssertTrue([result isEqualToString:@"3 + 5 + 5"], @"Must be 3 + 5 + 5");
    
}

- (void)testMultiplicationResult3
{
    [self.brain setTestVariableValue:[NSArray arrayWithObjects:[NSNumber numberWithDouble: 0], nil]];
    [self.brain pushOperand:3.0];
    [self.brain performOperetion:@"sin"];
    [self.brain performOperetion:@"sqrt"];
    NSString *result = [self.brain secondPerformOperetion];
    STAssertTrue([result isEqualToString:@"sqrt(sin(3))"], @"Must be sqrt(sin(3))");
}

- (void)testMultiplicationResult4
{
    [self.brain setTestVariableValue:[NSArray arrayWithObjects:[NSNumber numberWithDouble: 0], nil]];
    [self.brain pushOperand:2.0];
    [self.brain pushOperand:3.0];
    [self.brain pushOperand:4.0];
    [self.brain pushOperand:5.0];
    [self.brain performOperetion:@"+"];
    [self.brain performOperetion:@"+"];
    NSString *result = [self.brain secondPerformOperetion];
    STAssertTrue([result isEqualToString:@"2 3 + 4 + 5"], @"Must be 2 3 + 4 + 5");
}

- (void)testMultiplicationResult5
{
    [self.brain setTestVariableValue:[NSArray arrayWithObjects:[NSNumber numberWithDouble: 0], nil]];
    [self.brain pushOperand:2.0];
    [self.brain pushOperand:3.0];
    [self.brain performOperetion:@"+"];
    [self.brain pushOperand:5.0];
    [self.brain pushOperand:1.0];
    [self.brain performOperetion:@"+"];
    [self.brain performOperetion:@"*"];
    NSString *result = [self.brain secondPerformOperetion];
    STAssertTrue([result isEqualToString:@"(2 + 3) * (5 + 1)"], @"Must be (2 + 3) * (5 +1 )");
}

- (void)testMultiplicationResult6
{
    [self.brain setTestVariableValue:[NSArray arrayWithObjects:[NSNumber numberWithDouble: 0], nil]];
    [self.brain pushOperand:2.0];
    [self.brain pushOperand:3.0];
    [self.brain performOperetion:@"sqrt"];
    [self.brain performOperetion:@"+"];
    NSString *result = [self.brain secondPerformOperetion];
    STAssertTrue([result isEqualToString:@"2 + sqrt(3)"], @"Must be 2 + sqrt(3)");
}


- (void)testMultiplicationResult7
{
    [self.brain setTestVariableValue:[NSArray arrayWithObjects:[NSNumber numberWithDouble: 0], nil]];
    [self.brain pushOperand:2.0];
    [self.brain pushOperand:3.0];
    [self.brain performOperetion:@"sqrt"];
    [self.brain performOperetion:@"+"];
    [self.brain pushOperand:5.0];
    [self.brain pushOperand:7.0];
    [self.brain performOperetion:@"-"];
    [self.brain performOperetion:@"*"];
    NSString *result = [self.brain secondPerformOperetion];
    STAssertTrue([result isEqualToString:@"(2 + sqrt(3)) * (5 - 7)"], @"Must be 2 + sqrt(3) * (5 + 7)");
}

- (void)testMultiplicationResult8
{
    [self.brain setTestVariableValue:[NSArray arrayWithObjects:[NSNumber numberWithDouble: 0], nil]];
    [self.brain pushOperand:2.0];
    [self.brain pushOperand:3.0];
    [self.brain pushOperand:5.0];
    [self.brain performOperetion:@"+"];
    [self.brain performOperetion:@"*"];
     NSString *result = [self.brain secondPerformOperetion];
    STAssertTrue([result isEqualToString:@"2 * (3 + 5)"], @"Must be cos(2 * (3 + 5))");
}

- (void)testMultiplicationResult9
{
    [self.brain setTestVariableValue:[NSArray arrayWithObjects:[NSNumber numberWithDouble: 0], nil]];
    [self.brain pushOperand:2.0];
    [self.brain pushOperand:3.0];
    [self.brain pushOperand:5.0];    
    [self.brain performOperetion:@"+"];;
    [self.brain performOperetion:@"*"];
    [self.brain performOperetion:@"cos"];
    NSString *result = [self.brain secondPerformOperetion];
    STAssertTrue([result isEqualToString:@"cos(2 * (3 + 5))"], @"Must be cos(2 * (3 + 5))");
}

- (void)testMultiplicationResult10
{
    [self.brain setTestVariableValue:[NSArray arrayWithObjects:[NSNumber numberWithDouble: 0], nil]];
    [self.brain pushOperand:2.0];
    [self.brain pushOperand:3.0];
    [self.brain pushOperand:5.0];
    [self.brain performOperetion:@"+"];
    [self.brain performOperetion:@"*"];
    [self.brain performOperetion:@"cos"];
    [self.brain pushOperand:1.0];
    [self.brain pushOperand:9.0];
    [self.brain performOperetion:@"-"];
    [self.brain performOperetion:@"/"];
    NSString *result = [self.brain secondPerformOperetion];
    STAssertTrue([result isEqualToString:@"(cos(2 * (3 + 5))) / (1 - 9)"], @"Must be cos(2 * (3 + 5)) / (1 - 9)");
}

- (void)testMultiplicationResult11
{
    [self.brain setTestVariableValue:[NSArray arrayWithObjects:[NSNumber numberWithDouble: 0], nil]];
    [self.brain pushOperand:2.0];
    [self.brain pushOperand:3.0];
    [self.brain pushOperand:5.0];
    [self.brain performOperetion:@"+"];
    [self.brain performOperetion:@"*"];
    [self.brain performOperetion:@"cos"];
    [self.brain pushOperand:1.0];
    [self.brain pushOperand:9.0];
    [self.brain performOperetion:@"-"];
    [self.brain pushOperand:4.0];
    [self.brain performOperetion:@"*"];
    [self.brain performOperetion:@"/"];
    NSString *result = [self.brain secondPerformOperetion];
    STAssertTrue([result isEqualToString:@"(cos(2 * (3 + 5))) / ((1 - 9) * 4)"], @"Must be cos(2 * (3 + 5)) / (1 - 9)");
}

@end
