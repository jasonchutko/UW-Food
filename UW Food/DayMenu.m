//
//  DayMenu.m
//  UW Food
//
//  Created by Jason Chutko on 2012-07-21.
//  Copyright (c) 2012 Jason Chutko. All rights reserved.
//

#import "DayMenu.h"

@implementation DayMenu

@synthesize date = _date;
@synthesize lunchMenu = _lunchMenu;
@synthesize dinnerMenu = _dinnerMenu;

- (id)init {
    self = [super init];
    if(self) {
        _lunchMenu = [NSMutableArray array];
        _dinnerMenu = [NSMutableArray array];
    }
    return self;
}

@end
