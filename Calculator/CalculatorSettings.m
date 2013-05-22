//
//  CalculatorSettings.m
//  Calculator
//
//  Created by Oleksandr Kulakov on 5/21/13.
//  Copyright (c) 2013 Oleksandr Kulakov. All rights reserved.
//

#import "CalculatorSettings.h"

static CalculatorSettings* settings = nil;

@interface CalculatorSettings ()

@property (strong, nonatomic) NSUserDefaults *defaults;
@property (strong, nonatomic) NSDictionary* defaultSettings;

@end

@implementation CalculatorSettings

+ (CalculatorSettings*) sharedSettings
{
    if (settings == nil)
    {
        settings = [CalculatorSettings new];
        settings.defaults = [NSUserDefaults standardUserDefaults];
        [settings.defaults synchronize];
    }
    return settings;
}

- (void) addFav:(id) object forKey: (NSString *)key
{
    NSMutableArray *favorites = [[settings.defaults arrayForKey:key] mutableCopy];
        if (!favorites)
        {
            favorites = [NSMutableArray array];
        }
    [favorites addObject: object];
    [settings.defaults setObject:favorites forKey:key];
    [settings.defaults synchronize];
}

- (id) getFavForKey: (NSString *) key
{
    return [settings.defaults objectForKey:key];
}

- (void) deleteFavAtIndex: (int)index forKey: (NSString *)key
{
    NSMutableArray *favorites = [[settings.defaults objectForKey:key]mutableCopy];
    if (favorites)
    {
        if ([favorites count]==1)
        {
            [settings.defaults removeObjectForKey:key];
        }

        [favorites removeObjectAtIndex:index];
        [settings.defaults removeObjectForKey:key];
        [settings.defaults setObject:favorites forKey:key];
        NSLog(@"%@", [settings.defaults objectForKey:key]);        
    }
    [settings.defaults synchronize];
}



@end


