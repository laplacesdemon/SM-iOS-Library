//
//  SMMathFunctionsTests.m
//  SMTools
//
//  Created by Suleyman Melikoglu on 5/18/12.
//  Copyright (c) 2012 suleymanmelikoglu@gmail.com. All rights reserved.
//

#import "SMMathFunctionsTests.h"
#import "SMMathFunctions.h"

@implementation SMMathFunctionsTests

- (void) testFactorial
{
    SMMathFunctions* math = [[SMMathFunctions alloc] init];
    
    NSInteger expected = 4 * 3 * 2;
    NSLog(@"the factorial is %d", [math factorial:4]);
    STAssertEquals(expected, [math factorial:4], @"factorial calculation");
    
}

@end
