//
//  AppDelegate.h
//  UW Food
//
//  Created by Jason Chutko on 2012-07-20.
//  Copyright (c) 2012 Jason Chutko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    TabBarViewController *_tabBarController;
}

@property (strong, nonatomic) UIWindow *window;

@end
