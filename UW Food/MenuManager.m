//
//  MenuManager.m
//  UW Food
//
//  Created by Jason Chutko on 2012-07-21.
//  Copyright (c) 2012 Jason Chutko. All rights reserved.
//

#import "MenuManager.h"

@implementation MenuManager

@synthesize dayArray = _dayArray;

- (id) init {
    self = [super init];
    if (self) {
        _dayArray = [NSMutableArray array];
        
        [self initDummyData];
    }
    
    return self;
}


- (int)getNumberOfDays {
    return [_dayArray count];
}

- (DayMenu*) getMenuAtIndex:(int)index {
    return (DayMenu*)[_dayArray objectAtIndex:index];
}

- (void)initDummyData {
    for(int x = 0; x < 5; x++) {
        
        DayMenu *menu = [[DayMenu alloc] init];
        
        for(int x = 0; x < arc4random() % 3; x++) {
            MenuItem *lunchItem = [[MenuItem alloc] init];
            lunchItem.itemName = [NSString stringWithFormat:@"Lunch Item %d", arc4random() % 4];
            [menu.lunchMenu addObject:lunchItem];

        }
        for(int x = 0; x < arc4random() % 3; x++) {
            MenuItem *dinnerItem = [[MenuItem alloc] init];
            dinnerItem.itemName = [NSString stringWithFormat:@"Dinner Item %d", arc4random() % 4];
            [menu.dinnerMenu addObject:dinnerItem];
        }
        
        [_dayArray addObject:menu];
    }
}

@end


