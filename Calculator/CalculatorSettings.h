//
//  CalculatorSettings.h
//  Calculator
//
//  Created by Oleksandr Kulakov on 5/21/13.
//  Copyright (c) 2013 Oleksandr Kulakov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorSettings : NSObject


+ (CalculatorSettings*) sharedSettings;

- (void) addFav:(id) object forKey: (NSString *)key;
- (id) getFavForKey: (NSString *)key;
- (void) deleteFavAtIndex: (int)index forKey: (NSString *)key;

@end


@interface CalculatorSettings(additions)

@end