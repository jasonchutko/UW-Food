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
        //[self refresh];
    }
    
    return self;
}

- (int)getNumberOfDays {
    return [_dayArray count];
}

- (DayMenu*) getMenuAtIndex:(int)index {
    return (DayMenu*)[_dayArray objectAtIndex:index];
}

- (void) refresh {
    
    // change this to proper networking block, on success clear old array
    
    [_dayArray removeAllObjects];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL:
                        [NSURL URLWithString: @"http://csclub.uwaterloo.ca/~jrchutko/scrape.xml"]];
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:data waitUntilDone:YES];
    });
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
                
                NSLog(@"Value: %d, %@", item.mealType, item.itemName);
                
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


