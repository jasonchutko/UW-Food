//
//  Transaction.h
//  UW Food
//
//  Created by Jason Chutko on 2012-07-23.
//  Copyright (c) 2012 Jason Chutko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Transaction : NSObject

@property (nonatomic, retain) NSString *locationString;
@property (nonatomic, retain) NSString *dateString;
@property (nonatomic, retain )NSString *amountString;

@end
