//
//  SMSViewController.m
//  SMToolsSampleApp
//
//  Created by Suleyman Melikoglu on 5/18/12.
//  Copyright (c) 2012 suleymanmelikoglu@gmail.com. All rights reserved.
//

#import "SMSViewController.h"
#import "SMMathFunctions.h"
#import "SMTools.h"

@interface SMSViewController ()

@end

@implementation SMSViewController
@synthesize factorialResult, uuid;

- (void)viewDidLoad
{
    [super viewDidLoad];
    SMMathFunctions* mathFunctions = [[SMMathFunctions alloc] init];
    [factorialResult setText:[NSString stringWithFormat:@"%d", [mathFunctions factorial:4]]];
    
    NSString* theUuid = [SMDevice uuid];
    [uuid setText:theUuid];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
