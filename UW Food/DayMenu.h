//
//  DayMenu.h
//  UW Food
//
//  Created by Jason Chutko on 2012-07-21.
//  Copyright (c) 2012 Jason Chutko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DayMenu : NSObject

@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSMutableArray *lunchMenu;
@property (nonatomic, retain) NSMutableArray *dinnerMenu;

@end
