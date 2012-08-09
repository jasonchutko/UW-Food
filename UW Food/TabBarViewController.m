//
//  TabBarControllerViewController.m
//  UW Food
//
//  Created by Jason Chutko on 2012-07-20.
//  Copyright (c) 2012 Jason Chutko. All rights reserved.
//

#import "TabBarViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController


- (id)init {
    self = [super init];
    if(self) {
        _tabBarItems = [[NSMutableArray alloc] init];
        
        [self initRev];
        [self initV1];
        [self initBalance];
        
        self.viewControllers = _tabBarItems;
    }
    return self;
}

- (void)initRev {
    _revTableViewController = [[LocationTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    _revTableViewController.navigationItem.title = @"Ron Eydt Village";
    [_revTableViewController setupManagerWithLocation:@"REV"];
    _revNavigationController = [[UINavigationController alloc] init];
    _revNavigationController.title = @"REV";
    _revNavigationController.tabBarItem.image = [UIImage imageNamed:@"group"];
    _revNavigationController.viewControllers = [NSArray arrayWithObject:_revTableViewController];
    
    [_tabBarItems addObject:_revNavigationController];
}

- (void)initV1 {
    _v1TableViewController = [[LocationTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    _v1TableViewController.navigationItem.title = @"Village 1";
     [_v1TableViewController setupManagerWithLocation:@"V1"];
    _v1NavigationController = [[UINavigationController alloc] init];
    _v1NavigationController.title = @"V1";
    _v1NavigationController.tabBarItem.image = [UIImage imageNamed:@"single"];
    _v1NavigationController.viewControllers = [NSArray arrayWithObject:_v1TableViewController];
    
    [_tabBarItems addObject:_v1NavigationController];
}

- (void)initBalance {
    _balanceViewController = [[BalanceViewController alloc] init];
    _balanceNavigationController = [[UINavigationController alloc] init];
    [_balanceNavigationController setTitle:@"Balance"];
    _balanceNavigationController.tabBarItem.image = [UIImage imageNamed:@"piggy-bank"];
    _balanceNavigationController.viewControllers = [NSArray arrayWithObject:_balanceViewController];
    
    [_tabBarItems addObject:_balanceNavigationController];
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
