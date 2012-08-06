//
//  TransactionManager.h
//  UW Food
//
//  Created by Jason Chutko on 2012-07-23.
//  Copyright (c) 2012 Jason Chutko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Transaction.h"
#import "Utilities/MKNetworkKit/MKNetworkKit.h"

@interface TransactionManager : NSObject {
    NSMutableArray *_transactionArray;
    NSString *_mealBalance;
    NSString *_flexBalance;
}

@property NSString *watcardNumber;
@property NSString *pinNumber;
@property NSString *responseString;

- (void) loadRecentTransactions;
- (int) numberOfTransactions;
- (NSString *) getMealBalance;
- (NSString *) getFlexBalance;
- (void) loadBalance;

@end
