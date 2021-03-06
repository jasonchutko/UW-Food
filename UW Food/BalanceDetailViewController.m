//
//  BalanceDetailViewController.m
//  UW Food
//
//  Created by Jason Chutko on 2012-07-22.
//  Copyright (c) 2012 Jason Chutko. All rights reserved.
//

#import "BalanceDetailViewController.h"

@interface BalanceDetailViewController ()

@end

@implementation BalanceDetailViewController

@synthesize transactionManager = _transactionManager;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
       // _transactionManager = [[TransactionManager alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleDone target:self action:@selector(pushRootViewController)];
    
    self.navigationItem.rightBarButtonItem = barButton;
    


    if (_refreshHeaderView == nil) {
        
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		_refreshHeaderView = view;
        
	}
    
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushRootViewController {
    [_transactionManager deleteAllData];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)flashScreen {
    UIView *whiteView = [[UIView alloc] initWithFrame:self.view.frame];
    [whiteView setBackgroundColor:[UIColor whiteColor]];
    [whiteView setAlpha:0.3f];
    [self.view addSubview:whiteView];
    [UIView animateWithDuration:0.5f animations:^{
        [whiteView setAlpha:0.0f];
    } completion:^(BOOL finished) {
        if(finished) {
            [whiteView removeFromSuperview];
        }
    }];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
    
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
    [_transactionManager loadRecentTransactions];
}

- (void)doneLoadingTableViewData{
    
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    [self.tableView reloadData];
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    
	[self reloadTableViewDataSource];    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
	return _reloading; // should return if data source model is reloading
    
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
	return [_transactionManager getLastRefreshed]; // should return date data source was last changed
    
}


#pragma mark - Table view data source

- (NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if(section == 1) {
        NSDate *date = [_transactionManager getLastRefreshed];
        
		
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setAMSymbol:@"AM"];
		[formatter setPMSymbol:@"PM"];
		[formatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
		return [NSString stringWithFormat:@"Last Updated: %@", [formatter stringFromDate:date]];
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0) {
        return 2;
    } else {
        return MAX(1,[_transactionManager numberOfTransactions]);
    }
}


- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        return @"Balance";
    } else {
        return @"Recent Transactions";
    }
}


- (UITableViewCell *) setupBalanceCellWithIndexPath:(NSIndexPath*)indexPath {
    static NSString *CellIdentifier = @"BalanceCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    if(indexPath.row == 0) {
        [cell.textLabel setText:@"Meal Plan Balance: "];
        [cell.detailTextLabel setText:[_transactionManager getMealBalance]];
    } else {
        [cell.textLabel setText:@"Flex Dollar Balance: "];
        [cell.detailTextLabel setText:[_transactionManager getFlexBalance]];
    }
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) {
        return [self setupBalanceCellWithIndexPath:indexPath];
    } else {
        if([_transactionManager numberOfTransactions] == 0) {
            static NSString *CellIdentifier = @"NoTransactionCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            [cell.textLabel setText:@"No transactions in the last 30 days."];
            [cell.textLabel setFont:[UIFont systemFontOfSize:14.0f]];
            
            return cell;
            
        } else {
            static NSString *CellIdentifier = @"TransactionCell";
            TransactionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                cell = [[TransactionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            Transaction *current = [_transactionManager getTransactionAtIndex:indexPath.row];
            cell.transaction = current;
            
            return cell;
        }
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Networking

- (void) showNetworkingError {
    UIAlertView *alertNetworking = [[UIAlertView alloc] initWithTitle:@"Error" message:@"A networking error has occurred. Please try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertNetworking show];
}

#pragma mark - Transaction Manager Delegate

- (void)dataReloaded {
    [self doneLoadingTableViewData];
    [self flashScreen];
}

- (void)updateFailed {
    [self showNetworkingError];
}

@end
