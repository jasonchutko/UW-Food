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

@protocol TransactionManagerDelegate <NSObject>

- (void)dataReloaded;

@end

@interface TransactionManager : NSObject {
    NSMutableArray *_transactionArray;
    NSString *_mealBalance;
    NSString *_flexBalance;
}

@property NSString *watcardNumber;
@property NSString *pinNumber;
@property NSString *responseString;

@property (nonatomic, unsafe_unretained) id<TransactionManagerDelegate> delegate;

- (void) loadRecentTransactions;
- (int) numberOfTransactions;
- (NSString *) getMealBalance;
- (NSString *) getFlexBalance;
- (void) loadBalance;
- (Transaction*) getTransactionAtIndex:(int)index;
- (void)deleteAllData;

@end
