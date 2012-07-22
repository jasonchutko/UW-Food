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
        _xmlParser = [[TBXML alloc] init];
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
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL:
                        [NSURL URLWithString: @"http://csclub.uwaterloo.ca/~jrchutko/scrape.xml"]];
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:data waitUntilDone:YES];
    });
}

- (void) fetchedData:(NSData*)data {
    NSError *error;
    
    _xmlParser = [TBXML newTBXMLWithXMLData:data error:&error];
        
    if (error) {
        NSLog(@"%@ %@", [error localizedDescription], [error userInfo]);
    } else {
        NSLog(@"%@", [TBXML elementName:_xmlParser.rootXMLElement]);
    }
    
    [self traverseElement:_xmlParser.rootXMLElement];
}

- (void) traverseElement:(TBXMLElement *)element {
    do {
        // Display the name of the element
        NSLog(@"%@",[TBXML elementName:element]);
        
        // Obtain first attribute from element
        TBXMLAttribute * attribute = element->firstAttribute;
        
        // if attribute is valid
        while (attribute) {
            // Display name and value of attribute to the log window
            NSLog(@"%@->%@ = %@",  [TBXML elementName:element],
                  [TBXML attributeName:attribute],
                  [TBXML attributeValue:attribute]);
            
            // Obtain the next attribute
            attribute = attribute->next;
        }
        
        // if the element has child elements, process them
        if (element->firstChild)
            [self traverseElement:element->firstChild];
        
        // Obtain next sibling element
    } while ((element = element->nextSibling));  
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


