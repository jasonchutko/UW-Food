//
//  BalanceLoginViewController.m
//  UW Food
//
//  Created by Jason Chutko on 2012-07-21.
//  Copyright (c) 2012 Jason Chutko. All rights reserved.
//

#import "BalanceLoginViewController.h"

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
    NSLog(@"Buton pressed");
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 60;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [loginButton setTitle:@"Login" forState:UIControlStateNormal];
    [loginButton setFrame:CGRectMake(10, 5, 300, 44)];
    [loginButton addTarget:self action:@selector(loginPressed) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *containerView = [[UIView alloc] init];
    [containerView addSubview:loginButton];
    return containerView;
}

- (void)setTextFieldStyle:(UITextField *)textField {
    [textField setFrame:CGRectMake(200, 10, 100, 30)];
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

@end
