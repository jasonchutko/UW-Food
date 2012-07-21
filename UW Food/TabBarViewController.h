//
//  TabBarControllerViewController.h
//  UW Food
//
//  Created by Jason Chutko on 2012-07-20.
//  Copyright (c) 2012 Jason Chutko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationTableViewController.h"
#import "BalanceViewController.h"

@interface TabBarViewController : UITabBarController {
    NSMutableArray *_tabBarItems;
    
    UINavigationController *_revNavigationController;
    UINavigationController *_v1NavigationController;
    UINavigationController *_balanceNavigationController;
    
    LocationTableViewController *_revTableViewController;
    LocationTableViewController *_v1TableViewController;
    BalanceViewController *_balanceViewController;
}

@end
