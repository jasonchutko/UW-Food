//
//  Utilities.m
//  UW Food
//
//  Created by Jason Chutko on 2012-08-08.
//  Copyright (c) 2012 Jason Chutko. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

+ (NSDate*)dateWithoutTime:(NSDate*)date {
    NSDateComponents* comps = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
}

@end
