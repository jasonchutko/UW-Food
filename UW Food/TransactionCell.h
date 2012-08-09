//
//  TransactionCell.h
//  UW Food
//
//  Created by Jason Chutko on 2012-08-08.
//  Copyright (c) 2012 Jason Chutko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Transaction.h"

@interface TransactionCell : UITableViewCell {
    UILabel *_locationLabel;
    UILabel *_dateLabel;
    UILabel *_priceLabel;
}

@property (nonatomic, retain) Transaction *transaction;

@end
