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
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.0];
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
	return _reloading; // should return if data source model is reloading
    
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
	return [NSDate date]; // should return date data source was last changed
    
}



#pragma mark - Table view data source

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
        return [_transactionManager numberOfTransactions];
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
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
//                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TransactionCell" owner:self options:NULL];
//                cell = (TransactionCell *) [nib objectAtIndex:0];
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            Transaction *current = [_transactionManager getTransactionAtIndex:indexPath.row];
            
            cell.textLabel.text = current.locationString;
//            
//            [[cell locationText] setText:current.locationString];
//            [[cell dateText] setText:current.dateString];
//            [[cell amountText] setText:current.amountString];
            
            return cell;
        }
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - Networking

- (void) showNetworkingError {
    UIAlertView *alertNetworking = [[UIAlertView alloc] initWithTitle:@"Error" message:@"A networking error has occurred. Please try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertNetworking show];
}

#pragma mark - Transaction Manager Delegate

- (void)dataReloaded {
    [self.tableView reloadData];
}

@end
