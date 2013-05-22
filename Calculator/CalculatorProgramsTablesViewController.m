//
//  CalculatorProgramsTablesViewController.m
//  Calculator
//
//  Created by Oleksandr Kulakov on 5/21/13.
//  Copyright (c) 2013 Oleksandr Kulakov. All rights reserved.
//

#import "CalculatorProgramsTablesViewController.h"
#import "CalculatorBrain.h"
#import "CalculatorSettings.h"
#import "Keys.h"
#import "GraphViewController.h"

@interface CalculatorProgramsTablesViewController ()

@end

@implementation CalculatorProgramsTablesViewController

@synthesize programs = _programs;
@synthesize delegate = _delegate;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.programs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Calculator Program Description";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    id program = [self.programs objectAtIndex:indexPath.row];
    cell.textLabel.text = [@"y = " stringByAppendingString:[CalculatorBrain descriptionOfProgram:program]];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [[CalculatorSettings sharedSettings] deleteFavAtIndex: indexPath.row forKey: FAVORITES_KEY];
//        [self.programs delete:self.programs[indexPath.row]];
        [self.programs removeObjectAtIndex:indexPath.row];
        NSMutableArray *array = [[NSMutableArray alloc]init];
        [array addObject:indexPath];
        [self.tableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationLeft];
//        [self.tableView reloadData];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id program = [self.programs objectAtIndex:indexPath.row];
    [self.delegate calculatorProgramsTablesViewController:self choseProgram:program];
    
}

@end
