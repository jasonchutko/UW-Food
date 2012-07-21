//
//  BalanceLoginViewController.h
//  UW Food
//
//  Created by Jason Chutko on 2012-07-21.
//  Copyright (c) 2012 Jason Chutko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSKeyboardControls/BSKeyboardControls.h"


@interface BalanceLoginViewController : UITableViewController <BSKeyboardControlsDelegate, UITextFieldDelegate> {
    BSKeyboardControls *_keyboardControls;
    
    UITextField *_watcardNumberField;
    UITextField *_pinField;
}

@end
