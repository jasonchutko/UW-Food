//
//  RevTableViewController.m
//  UW Food
//
//  Created by Jason Chutko on 2012-07-20.
//  Copyright (c) 2012 Jason Chutko. All rights reserved.
//

#import "LocationTableViewController.h"
#import "MenuItemCell.h"
#import "Utilities/Utilities.h"

@interface LocationTableViewController ()

@end

@implementation LocationTableViewController

@synthesize menuManager = _menuManager;

- (void) setupManagerWithLocation:(NSString*)location {
    _menuManager = [[MenuManager alloc] init];
    _menuManager.delegate = self;
    _menuManager.location = location;
    [_menuManager loadDataIfNeccessary];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSignificantTimeChange:) name:UIApplicationSignificantTimeChangeNotification object:nil];
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

- (void)onSignificantTimeChange:(NSNotification *)notification {
    [_menuManager loadDataIfNeccessary];
    // remove the outdated entries
    [_menuManager cleanseData];
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [_menuManager refreshAndShowError:YES];
}

- (void)doneLoadingTableViewData{
    
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    [self.tableView reloadData];
}

- (void) showNetworkingError {
    UIAlertView *alertNetworking = [[UIAlertView alloc] initWithTitle:@"Error" message:@"A networking error has occurred. Please try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertNetworking show];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
   // NSLog(@"%@", NSStringFromCGRect(self.view.frame));

	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
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
    
	return [_menuManager getLastRefreshed]; // should return date data source was last changed
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return MAX(1,[_menuManager getNumberOfDays]);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if([_menuManager getNumberOfDays] == 0) {
        return 1;
    }
    
    
    // Return the number of rows in the section.
    int numberOfRowsinSection = 2;
    
    if([[_menuManager getMenuAtIndex:section].lunchMenu count] > 0) {
        numberOfRowsinSection += [[_menuManager getMenuAtIndex:section].lunchMenu count];
    }
    
    if([[_menuManager getMenuAtIndex:section].dinnerMenu count] > 0) {
        numberOfRowsinSection += [[_menuManager getMenuAtIndex:section].dinnerMenu count];
    }

    return numberOfRowsinSection;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if([_menuManager getNumberOfDays] == 0) {
        return @"Error";
    }
    
    
    NSDate *today = [Utilities dateWithoutTime:[NSDate date]];
    NSDate *tomorrow = [Utilities dateWithoutTime:[today dateByAddingTimeInterval:60*60*24]];
    NSDate *sectionDate = [Utilities dateWithoutTime:[[_menuManager getMenuAtIndex:section] date]];
    
    
    if([sectionDate compare:today] == NSOrderedSame) {
        return @"Today";
    }
    
    if([sectionDate compare:tomorrow] == NSOrderedSame) {
        return @"Tomorrow";
    }
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM d, YYYY"];
    
    return [formatter stringFromDate:[[_menuManager getMenuAtIndex:section] date]];
}

- (NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if(section == [_menuManager getNumberOfDays] - 1) {
        NSDate *date = [_menuManager getLastRefreshed];
        
		
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setAMSymbol:@"AM"];
		[formatter setPMSymbol:@"PM"];
		[formatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
		return [NSString stringWithFormat:@"Last Updated: %@", [formatter stringFromDate:date]];
    }
    return nil;
}

- (UITableViewCell *)setupMealCellAtIndexPath:(NSIndexPath*) indexPath{
    static NSString * CellIdentifier = @"MealCell";
    UITableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Lunch";
    } else {
        cell.textLabel.text = @"Dinner";
    }
    
    return cell;
}

- (MenuItemCell *)setupMenuItemCellAtIndexPath:(NSIndexPath*) indexPath {
    
    static NSString * CellIdentifier = @"MenuItemCell";
    MenuItemCell * cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MenuItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    int numberOfLunchItems = [[_menuManager getMenuAtIndex:indexPath.section].lunchMenu count];
    
    if(indexPath.row < numberOfLunchItems + 1) {
        //lunch cell at indexPath.row - 1
        
        cell.menuItem = ((MenuItem*)[[_menuManager getMenuAtIndex:indexPath.section].lunchMenu objectAtIndex:indexPath.row - 1]);
        
        } else {
             
            //dinner cell at indexPath.row - numberOfLunchItems - 2

        cell.menuItem = ((MenuItem*)[[_menuManager getMenuAtIndex:indexPath.section].dinnerMenu objectAtIndex:indexPath.row - (2 + numberOfLunchItems)]);
            
    }
    
    return cell;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell;
    
    if([_menuManager getNumberOfDays] == 0) {
        
        static NSString * CellIdentifier = @"ErrorCell";
        cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.textLabel.text = @"Sorry, there is no data available.";
    } else {
        
        int numberOfLunchItems = [[_menuManager getMenuAtIndex:indexPath.section].lunchMenu count];

        if(indexPath.row == 0 || indexPath.row == numberOfLunchItems + 1) {
            cell = [self setupMealCellAtIndexPath:indexPath];
        } else {
            cell = [self setupMenuItemCellAtIndexPath:indexPath];
        }
    }

    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([_menuManager getNumberOfDays] > 0 && [[self.tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[MenuItemCell class]]){
        
        UIAlertView *fullItem = [[UIAlertView alloc] initWithTitle:@"UW Food" message:((MenuItemCell*)[self.tableView cellForRowAtIndexPath:indexPath]).menuItem.itemName  delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [fullItem show];
    }
    
    // TODO: implement full details page
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Menu manager delegate

- (void) dataReloaded {
    [self doneLoadingTableViewData];
    [self flashScreen];
}

- (void) updateFailed {
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    [self showNetworkingError];
}

#pragma mark - Dealloc

-(void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
