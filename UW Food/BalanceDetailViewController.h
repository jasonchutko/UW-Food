//
//  BalanceDetailViewController.h
//  UW Food
//
//  Created by Jason Chutko on 2012-07-22.
//  Copyright (c) 2012 Jason Chutko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOTableViewPullRefresh/EGORefreshTableHeaderView.h"
#import "Utilities/MKNetworkKit/MKNetworkKit.h"
#import "TransactionManager.h"

@interface BalanceDetailViewController : UITableViewController <EGORefreshTableHeaderDelegate>{
    signed char _reloading;
    EGORefreshTableHeaderView *_refreshHeaderView;
}

@property (nonatomic, retain) TransactionManager *transactionManager;

@end
