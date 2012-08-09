//
//  BalanceLoginViewController.m
//  UW Food
//
//  Created by Jason Chutko on 2012-07-21.
//  Copyright (c) 2012 Jason Chutko. All rights reserved.
//

#import "BalanceLoginViewController.h"
#import "Utilities/Utilities.h"

@interface BalanceLoginViewController ()

@end

@implementation BalanceLoginViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"Login";
        _keyboardControls = [[BSKeyboardControls alloc] init];
        _keyboardControls.delegate = self;
        [self setupKeyboardControls];
        
        _watcardNumberField = [[UITextField alloc] init];
        _pinField = [[UITextField alloc] init];
        _keyboardControls.textFields = [NSArray arrayWithObjects:_watcardNumberField, _pinField, nil];
        
        _footerView = [[UIView alloc] init];
        
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
    }
    return self;
}

- (void) setupKeyboardControls {
    // Set the style of the bar. Default is UIBarStyleBlackTranslucent.
    _keyboardControls.barStyle = UIBarStyleBlackTranslucent;
    
    // Set the tint color of the "Previous" and "Next" button. Default is black.
    _keyboardControls.previousNextTintColor = [UIColor blackColor];
    
    // Set the tint color of the done button. Default is a color which looks a lot like the original blue color for a "Done" butotn
    _keyboardControls.doneTintColor = [UIColor colorWithRed:34.0/255.0 green:164.0/255.0 blue:255.0/255.0 alpha:1.0];
    
    // Set title for the "Previous" button. Default is "Previous".
    _keyboardControls.previousTitle = @"Previous";
    
    // Set title for the "Next button". Default is "Next".
    _keyboardControls.nextTitle = @"Next";
}


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}

- (void)loginPressed {
    
    if([[_watcardNumberField text] length] <= 0) {
        UIAlertView *alertWatCard = [[UIAlertView alloc] initWithTitle:@"WatCard" message:@"Please enter a WatCard number." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertWatCard show];
    } else if([[_pinField text] length] <= 0) {
        UIAlertView *alertPin = [[UIAlertView alloc] initWithTitle:@"WatCard" message:@"Please enter a pin." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertPin show];
    } else {

        [_loginButton setEnabled:NO];
        [_activityIndicator startAnimating];
        [_keyboardControls.activeTextField resignFirstResponder];
        
        [self performLoginRequest];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 80;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    _loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_loginButton setTitle:@"Login" forState:UIControlStateNormal];
    [_loginButton setFrame:CGRectMake((self.view.frame.size.width-300)/2, 5, 300, 44)];
    [_loginButton addTarget:self action:@selector(loginPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [_activityIndicator setCenter:CGPointMake(self.view.frame.size.width/2, 65)];
    
    
    UIView *containerView = [[UIView alloc] init];
    [containerView addSubview:_loginButton];
    [containerView addSubview:_activityIndicator];
    return containerView;
}

- (void)setTextFieldStyle:(UITextField *)textField {
    
    if(IS_IPAD) {
        [textField setFrame:CGRectMake(self.view.frame.size.width-150, 10, 100, 30)];
    } else {
        [textField setFrame:CGRectMake(200, 10, 100, 30)];
    }
    
    textField.inputAccessoryView = _keyboardControls;
    textField.adjustsFontSizeToFitWidth = NO;
    textField.textColor = [UIColor blackColor];
    textField.backgroundColor = [UIColor clearColor];
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.textAlignment = UITextAlignmentLeft;
    textField.delegate = self;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"LoginCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:@"LoginCell"];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        if ([indexPath section] == 0) {
            
            if ([indexPath row] == 0) {
                [self setTextFieldStyle:_watcardNumberField];
                _watcardNumberField.placeholder = @"12345678";
                [cell addSubview:_watcardNumberField];
            }
            else {
                [self setTextFieldStyle:_pinField];
                _pinField.placeholder = @"Required";
                _pinField.secureTextEntry = YES;
                [cell addSubview:_pinField];
            }
                        
        }
    }
    if ([indexPath section] == 0) { // Email & Password Section
        if ([indexPath row] == 0) { // Email
            cell.textLabel.text = @"WatCard Number";
        }
        else {
            cell.textLabel.text = @"Pin";
        }
    }
    else { // Login button section
        cell.textLabel.text = @"Log in";
    }
    return cell;    
}

#pragma mark - Table view delegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - BSKeyboardControls delegate

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)controls
{
    [controls.activeTextField resignFirstResponder];
}

- (void)keyboardControlsPreviousNextPressed:(BSKeyboardControls *)controls withDirection:(KeyboardControlsDirection)direction andActiveTextField:(id)textField
{
    [textField becomeFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([_keyboardControls.textFields containsObject:textField])
        _keyboardControls.activeTextField = textField;
}

#pragma mark - Networking

- (void) showNetworkingError {
    UIAlertView *alertNetworking = [[UIAlertView alloc] initWithTitle:@"Error" message:@"A networking error has occurred. Please try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [_activityIndicator stopAnimating];
    [_loginButton setEnabled:YES];
    [alertNetworking show];
}

- (void) performLoginRequest {

    //init the http engine, supply the web host
    //and also a dictionary with http headers you want to send
    MKNetworkEngine* engine = [[MKNetworkEngine alloc]
                               initWithHostName:@"account.watcard.uwaterloo.ca" customHeaderFields:nil];
    
    //request parameters
    //these would be your GET or POST variables
    NSMutableDictionary* params = [NSMutableDictionary
                                   dictionaryWithObjectsAndKeys: _watcardNumberField.text,@"acnt_1",
                                    _pinField.text,@"acnt_2",
                                    @"ON",@"FINDATAREP",
                                    @"STATUS", @"STATUS", nil];
    
    //create operation with the host relative path, the params
    //also method (GET,POST,HEAD,etc) and whether you want SSL or not
    MKNetworkOperation* op = [engine
                              operationWithPath:@"watgopher661.asp" params: params
                              httpMethod:@"POST" ssl:YES];
    
    //set completion and error blocks
    [op onCompletion:^(MKNetworkOperation *completedOperation) {
       // NSLog(@"response: %@", [op responseString]);
        _responseString = [op responseString];
        [self parseLogin:_responseString];
        
    } onError:^(NSError *error) {
        [self showNetworkingError];
    }];
    
    //add to the http queue and the request is sent
    [engine enqueueOperation: op];
}

- (void) pushDetailViewController {
    BalanceDetailViewController *tableViewController = [[BalanceDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    tableViewController.navigationItem.title = @"Balance";
    
    TransactionManager *transactionManager = [[TransactionManager alloc] init];
    
    transactionManager.delegate = tableViewController;
    
    transactionManager.watcardNumber = _watcardNumberField.text;

    transactionManager.pinNumber = _pinField.text;
    transactionManager.responseString = _responseString;
    
    [_watcardNumberField setText:@""];
    [_pinField setText:@""];
    _responseString = nil;
    
    [transactionManager loadBalance];
    [transactionManager loadRecentTransactions];
    tableViewController.transactionManager = transactionManager;
    
    [UIView  beginAnimations: @"ShowDetailView"context: nil];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
    [self.navigationController pushViewController: tableViewController animated:NO];
    [UIView commitAnimations];
}


- (void) parseLogin:(NSString*)responseString {
    [_activityIndicator stopAnimating];
    [_loginButton setEnabled:YES];
    
    if([responseString rangeOfString:@"Financial Status Report"].location != NSNotFound) {
        [_watcardNumberField becomeFirstResponder];
        [self pushDetailViewController];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"WatCard" message:@"Incorrect WatCard number or pin." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        [self parentViewController];
    }
}

@end
