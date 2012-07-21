//
//  BalanceViewController.m
//  UW Food
//
//  Created by Jason Chutko on 2012-07-20.
//  Copyright (c) 2012 Jason Chutko. All rights reserved.
//

#import "BalanceViewController.h"

@interface BalanceViewController ()

@end

@implementation BalanceViewController

- (id) init {
    self = [super init];
    if (self) {
        self.navigationItem.title = @"Balance";
         _loginViewController = [[BalanceLoginViewController alloc] initWithStyle:UITableViewStyleGrouped];
        self = (BalanceViewController*)_loginViewController;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
