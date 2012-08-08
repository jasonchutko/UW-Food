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
@synthesize delegate = _delegate;

- (id) init {
    self = [super init];
    if (self) {
        _dayArray = [NSMutableArray array];
    }
    
    return self;
}

- (int)getNumberOfDays {
    return [_dayArray count];
}

- (NSDate*)getLastRefreshed {
    return _lastRefreshed;
}

- (DayMenu*) getMenuAtIndex:(int)index {
    return (DayMenu*)[_dayArray objectAtIndex:index];
}

-(NSDate *)dateWithOutTime:(NSDate *)datDate {
    NSDateComponents* comps = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:datDate];
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
}


- (void)cleanseData {
    NSDate* timeNow = [NSDate date];
    
    NSMutableArray *itemsToDelete = [NSMutableArray array];
    
    for(DayMenu *day in _dayArray) {
        if([[self dateWithOutTime:[day date]] compare:[self dateWithOutTime:timeNow]] == NSOrderedAscending) {
            [itemsToDelete addObject:day];
        }
    }
    
    [_dayArray removeObjectsInArray:itemsToDelete];
}

- (void) showNetworkingError {
    NSLog(@"Network error");
}

- (void) refresh {
    
    //init the http engine, supply the web host
    //and also a dictionary with http headers you want to send
    MKNetworkEngine* engine = [[MKNetworkEngine alloc]
                               initWithHostName:@"csclub.uwaterloo.ca/~jrchutko" customHeaderFields:nil];
    
    //create operation with the host relative path, the params
    //also method (GET,POST,HEAD,etc) and whether you want SSL or not
    MKNetworkOperation* op = [engine
                              operationWithPath:@"scrape.xml" params:nil
                              httpMethod:@"GET" ssl:NO];
    
    //set completion and error blocks
    [op onCompletion:^(MKNetworkOperation *completedOperation) {
        
        NSLog(@"Downloaded successfully");

        // clear the previous array
        [_dayArray removeAllObjects];
        
        // load the new array
        [self fetchedData:[op responseData]];
        
    } onError:^(NSError *error) {
        [self showNetworkingError];
    }];
    
    //add to the http queue and the request is sent
    [engine enqueueOperation: op];
}

- (void) fetchedData:(NSData*)data {
    NSError *error;
	SMXMLDocument *document = [SMXMLDocument documentWithData:data error:&error];
    
    // check for errors
    if (error) {
        NSLog(@"Error while parsing the document: %@", error);
        return;
    }
    
	for (SMXMLElement *date in [document.root children]) {
        
        DayMenu *dayMenu = [[DayMenu alloc] init];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd"];
        dayMenu.date = [df dateFromString: [date valueWithPath:@"day"]];
        
        for(SMXMLElement *meal in [date childrenNamed:@"meal"]) {
            
            NSMutableArray *menuItems = [NSMutableArray array];            
            
            for(SMXMLElement *menuItem in [[meal childNamed:@"items"] childrenNamed:@"item"]) {
                MenuItem *item = [[MenuItem alloc] init];
                
                item.mealType = [[menuItem attributeNamed:@"type"] intValue];
                item.itemName = [menuItem value];
                
                //NSLog(@"Value: %d, %@", item.mealType, item.itemName);
                
                [menuItems addObject:item];
            }
            
            if([[meal valueWithPath:@"type"] isEqualToString:@"lunch"]) {
                dayMenu.lunchMenu = menuItems;
                
            } else if ([[meal valueWithPath:@"type"] isEqualToString:@"dinner"]) {
                dayMenu.dinnerMenu = menuItems;
            } else {}
            
        }
        [_dayArray addObject:dayMenu];
	}
    [self cleanseData];
    _lastRefreshed = [NSDate date];
    [self updateTableView];
}

- (void)updateTableView {
    if (_delegate) {
        [_delegate dataReloaded];
    }
}


- (void)initDummyData {
    for(int x = 0; x < 1; x++) {
        
        DayMenu *menu = [[DayMenu alloc] init];
        
        for(int x = 0; x < arc4random() % 3; x++) {
            MenuItem *lunchItem = [[MenuItem alloc] init];
            lunchItem.itemName = [NSString stringWithFormat:@"Lunch Item %d", arc4random() % 4];
            lunchItem.mealType = arc4random() % 5;

            [menu.lunchMenu addObject:lunchItem];

        }
        for(int x = 0; x < arc4random() % 3; x++) {
            MenuItem *dinnerItem = [[MenuItem alloc] init];
            dinnerItem.itemName = [NSString stringWithFormat:@"Dinner Item %d", arc4random() % 4];
            dinnerItem.mealType = arc4random() % 5;
            [menu.dinnerMenu addObject:dinnerItem];
        }
        
        [_dayArray addObject:menu];
    }
}

@end


