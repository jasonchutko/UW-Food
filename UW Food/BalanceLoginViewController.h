//
//  BalanceLoginViewController.h
//  UW Food
//
//  Created by Jason Chutko on 2012-07-21.
//  Copyright (c) 2012 Jason Chutko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSKeyboardControls/BSKeyboardControls.h"
#import "Utilities/MKNetworkKit/MKNetworkKit.h"
#import "BalanceDetailViewController.h"
#import "TransactionManager.h"
#import "Utilities/UIGlossyButton/UIGlossyButton.h"

@interface BalanceLoginViewController : UITableViewController <BSKeyboardControlsDelegate, UITextFieldDelegate> {
    BSKeyboardControls *_keyboardControls;
    UIActivityIndicatorView *_activityIndicator;
    
    UITextField *_watcardNumberField;
    UITextField *_pinField;
    
    UIView *_footerView;
    UIGlossyButton *_loginButton;
    
    NSString *_responseString;
}

@end
