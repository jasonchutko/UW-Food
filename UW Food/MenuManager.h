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
#import "Utilities/SMXMLDocument/SMXMLDocument.h"
#import "Utilities/MKNetworkKit/MKNetworkKit.h"


@protocol MenuManagerDelegate <NSObject>

- (void)dataReloaded;

@end

@interface MenuManager : NSObject {
    NSDate *_lastRefreshed;
}

@property (nonatomic, retain) NSMutableArray *dayArray;
@property (nonatomic, unsafe_unretained) id<MenuManagerDelegate> delegate;


- (int) getNumberOfDays;
- (NSDate*)getLastRefreshed;
- (DayMenu*) getMenuAtIndex:(int)index;
- (void)refresh;
- (void)cleanseData;

// TODO: remove this:
- (void)initDummyData;


@end