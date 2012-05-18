//
//  MathFunctions.m
//  SMTools
//
//  Created by Suleyman Melikoglu on 5/18/12.
//  Copyright (c) 2012 suleymanmelikoglu@gmail.com. All rights reserved.
//

#import "SMMathFunctions.h"

@implementation SMMathFunctions

- (NSArray *) fibonacci:(NSInteger) n {
    
	NSMutableArray *fib = [NSMutableArray array];
    
	int a = 0;
	int b = 1;
	int sum;
	int i;
    
	for (i=0; i < n; i++)
	{
		[fib addObject:[NSNumber numberWithInt:a]];
		sum = a + b;
		a = b;
		b = sum;
	}
    
	return (NSArray *) fib;
}

- (NSInteger) factorial:(NSInteger) n {
	if ( n <= 1 )
		return 1;
	else
		return n * [self factorial:( n-1 )];
}

@end
