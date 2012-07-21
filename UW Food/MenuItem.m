//
//  MenuItem.m
//  UW Food
//
//  Created by Jason Chutko on 2012-07-21.
//  Copyright (c) 2012 Jason Chutko. All rights reserved.
//

#import "MenuItem.h"

@implementation MenuItem

@synthesize itemName = _itemName;
@synthesize mealType;

- (id)init {
    self = [super init];
    if(self) {
        _itemName = [NSString string];
    }
    return self;
}


@end
