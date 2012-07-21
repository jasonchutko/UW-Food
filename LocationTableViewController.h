//
//  RevTableViewController.h
//  UW Food
//
//  Created by Jason Chutko on 2012-07-20.
//  Copyright (c) 2012 Jason Chutko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuManager.h"

@interface LocationTableViewController : UITableViewController

@property (nonatomic, retain) MenuManager *menuManager;

@end
