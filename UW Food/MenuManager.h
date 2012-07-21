//
//  MenuManager.h
//  UW Food
//
//  Created by Jason Chutko on 2012-07-21.
//  Copyright (c) 2012 Jason Chutko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DayMenu.h"
#import "MenuItem.h"

@interface MenuManager : NSObject

@property (nonatomic, retain) NSMutableArray *dayArray;

- (int) getNumberOfDays;
- (DayMenu*) getMenuAtIndex:(int)index;

// TODO: remove this:
- (void)initDummyData;

@end