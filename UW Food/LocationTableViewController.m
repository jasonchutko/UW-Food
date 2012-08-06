//
//  RevTableViewController.m
//  UW Food
//
//  Created by Jason Chutko on 2012-07-20.
//  Copyright (c) 2012 Jason Chutko. All rights reserved.
//

#import "LocationTableViewController.h"
#import "MenuItemTableViewCell.h"

@interface LocationTableViewController ()

@end

@implementation LocationTableViewController

@synthesize menuManager = _menuManager;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _menuManager = [[MenuManager alloc] init];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSignificantTimeChange:) name:UIApplicationSignificantTimeChangeNotification object:nil];    
}

- (void)onSignificantTimeChange:(NSNotification *)notification {
    // remove the outdated entries
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
    [_menuManager refresh];
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
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
    
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
    return [_menuManager getNumberOfDays];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
    if(section == 0) {
        return @"Today";
    } else {
        return @"Tomorrow";
    }
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

- (MenuItemTableViewCell *)setupMenuItemCellAtIndexPath:(NSIndexPath*) indexPath {
    
    static NSString * CellIdentifier = @"MenuItemCell";
    MenuItemTableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MenuItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
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
    int numberOfLunchItems = [[_menuManager getMenuAtIndex:indexPath.section].lunchMenu count];
    
    UITableViewCell * cell;

    if(indexPath.row == 0 || indexPath.row == numberOfLunchItems + 1) {
        cell = [self setupMealCellAtIndexPath:indexPath];
    } else {
        cell = [self setupMenuItemCellAtIndexPath:indexPath];
    }

    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: implement full details page
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Dealloc

-(void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
