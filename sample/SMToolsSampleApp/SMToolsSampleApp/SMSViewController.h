//
//  SMSViewController.h
//  SMToolsSampleApp
//
//  Created by Suleyman Melikoglu on 5/18/12.
//  Copyright (c) 2012 suleymanmelikoglu@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SMSViewController : UIViewController {
    UILabel* factorialResult;
    UILabel* uuid;
}

@property (nonatomic, strong) IBOutlet UILabel* factorialResult;
@property (nonatomic, strong) IBOutlet UILabel* uuid;

@end
