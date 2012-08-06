//
//  TransactionManager.m
//  UW Food
//
//  Created by Jason Chutko on 2012-07-23.
//  Copyright (c) 2012 Jason Chutko. All rights reserved.
//

#import "TransactionManager.h"

@implementation TransactionManager

@synthesize watcardNumber = _watcardNumber;
@synthesize pinNumber = _pinNumber;
@synthesize responseString = _responseString;

- (id) init {
    self = [super init];
    if(self) {
        _transactionArray = [NSMutableArray array];
    }
    return self;
}

- (void) showNetworkingError {
    NSLog(@"Network error");
}

- (void) parseTransactionResponse:(NSString *) response {
    
    int startIndex = 0;
    int endIndex = 0;
    int index = 0;
    
    while((index = [response rangeOfString:@"oneweb_financial_history_td_date" options:NSCaseInsensitiveSearch range:NSMakeRange(index, [response length] - index)].location) != NSNotFound) {
        
        Transaction *transaction = [[Transaction alloc] init];
        
        startIndex = index + @"oneweb_financial_history_td_date\">".length;
        endIndex = [response rangeOfString:@"<" options:NSCaseInsensitiveSearch range:NSMakeRange(index, [response length] - index)].location;
        
        [transaction setDateString:[response substringWithRange:NSMakeRange(startIndex, endIndex-startIndex)]];
        
        index = [response rangeOfString:@"oneweb_financial_history_td_amount" options:NSCaseInsensitiveSearch range:NSMakeRange(index, [response length] - index)].location;
        startIndex = index + @"oneweb_financial_history_td_amount\" align='right'>".length;
        endIndex = [response rangeOfString:@"<" options:NSCaseInsensitiveSearch range:NSMakeRange(startIndex, [response length] - startIndex)].location;
        
        [transaction setAmountString:[response substringWithRange:NSMakeRange(startIndex, endIndex-startIndex)]];
        
        index = [response rangeOfString:@"oneweb_financial_history_td_terminal" options:NSCaseInsensitiveSearch range:NSMakeRange(index, [response length] - index)].location;
        startIndex = index + @"oneweb_financial_history_td_terminal\">".length;
        endIndex = [response rangeOfString:@"<" options:NSCaseInsensitiveSearch range:NSMakeRange(startIndex, [response length] - startIndex)].location;
        
        [transaction setLocationString:[response substringWithRange:NSMakeRange(startIndex, endIndex-startIndex)]];
        
        NSLog(@"%@", transaction.locationString);
        
        
        [_transactionArray addObject:transaction];
        
        index++;
    }
}

- (void) loadBalance {
    int index = 0;
    index = [_responseString rangeOfString:@"VILLAGE MEAL"].location;
    index = [_responseString rangeOfString:@"amount" options:NSCaseInsensitiveSearch range:NSMakeRange(index, [_responseString length] - index)].location;
    index = [_responseString rangeOfString:@">" options:NSCaseInsensitiveSearch range:NSMakeRange(index, [_responseString length] - index)].location;
    
    int endIndex = 0;
    endIndex = [_responseString rangeOfString:@"<" options:NSCaseInsensitiveSearch range:NSMakeRange(index, [_responseString length] - index)].location;
    
    _mealBalance = [_responseString substringWithRange:NSMakeRange(index + 1, endIndex - index - 1)];
    
    index = [_responseString rangeOfString:@"FLEXIBLE"].location;
    index = [_responseString rangeOfString:@"amount" options:NSCaseInsensitiveSearch range:NSMakeRange(index, [_responseString length] - index)].location;
    index = [_responseString rangeOfString:@">" options:NSCaseInsensitiveSearch range:NSMakeRange(index, [_responseString length] - index)].location;
    
    endIndex = 0;
    endIndex = [_responseString rangeOfString:@"<" options:NSCaseInsensitiveSearch range:NSMakeRange(index, [_responseString length] - index)].location;
    
    _flexBalance = [_responseString substringWithRange:NSMakeRange(index + 1, endIndex - index - 1)];
}


- (void) loadRecentTransactions {
    NSDate *today = [[NSDate alloc] init];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setMonth:-1]; // note that I'm setting it to -1
    NSDate *startDate = [gregorian dateByAddingComponents:offsetComponents toDate:today options:0];
    
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"MM/dd/yyyy"];
    NSString *todayString = [dateFormatter stringFromDate:today];
    
    NSString *startString = [dateFormatter stringFromDate:startDate];
    
    //init the http engine, supply the web host
    //and also a dictionary with http headers you want to send
    MKNetworkEngine* engine = [[MKNetworkEngine alloc]
                               initWithHostName:@"account.watcard.uwaterloo.ca" customHeaderFields:nil];
    
    //request parameters
    //these would be your GET or POST variables
    NSMutableDictionary* params = [NSMutableDictionary
                                   dictionaryWithObjectsAndKeys: _watcardNumber,@"acnt_1",
                                   _pinNumber,@"acnt_2",
                                   startString,@"DBDATE",
                                   todayString,@"DEDATE",
                                   @"PASS",@"PASS",
                                   @"HIST", @"STATUS", nil];
    
    
    //create operation with the host relative path, the params
    //also method (GET,POST,HEAD,etc) and whether you want SSL or not
    MKNetworkOperation* op = [engine
                              operationWithPath:@"watgopher661.asp" params: params
                              httpMethod:@"POST" ssl:YES];
    
    //set completion and error blocks
    [op onCompletion:^(MKNetworkOperation *completedOperation) {
        
        // clear the previous array
        [_transactionArray removeAllObjects];
        
        // load the new array
        [self parseTransactionResponse:[op responseString]];
        
    } onError:^(NSError *error) {
        [self showNetworkingError];
    }];
    
    //add to the http queue and the request is sent
    [engine enqueueOperation: op];
}

- (int) numberOfTransactions {
    return [_transactionArray count];
}

- (NSString *) getMealBalance {
    return _mealBalance;
}

- (NSString *) getFlexBalance {
    return _flexBalance;
}

@end
