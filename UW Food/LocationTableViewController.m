//
//  RevTableViewController.m
//  UW Food
//
//  Created by Jason Chutko on 2012-07-20.
//  Copyright (c) 2012 Jason Chutko. All rights reserved.
//

#import "LocationTableViewController.h"

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
    
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
    
}

- (void)doneLoadingTableViewData{
    
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    
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
    int numberOfRowsinSection = 0;
    
    if([[_menuManager getMenuAtIndex:section].dinnerMenu count] > 0) {
        numberOfRowsinSection += [[_menuManager getMenuAtIndex:section].dinnerMenu count] + 1;
    }
    
    if([[_menuManager getMenuAtIndex:section].lunchMenu count] > 0) {
        numberOfRowsinSection += [[_menuManager getMenuAtIndex:section].lunchMenu count] + 1;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * CellIdentifier = @"MealCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }    
    
    // Configure the cell...
    
    int numberOfLunchItems = [[_menuManager getMenuAtIndex:indexPath.section].lunchMenu count];
    int numberOfDinnerItems = [[_menuManager getMenuAtIndex:indexPath.section].dinnerMenu count];

    if(numberOfLunchItems > 0) {
        if(indexPath.row == 0) {
            cell.textLabel.text = @"Lunch";
        } else if (indexPath.row <= numberOfLunchItems) {
            cell.textLabel.text = [NSString stringWithFormat:@"   %@", ((MenuItem*)[[_menuManager getMenuAtIndex:indexPath.section].lunchMenu objectAtIndex:indexPath.row - 1]).itemName];
        }
    }
        
    if(numberOfDinnerItems > 0) {
        if(indexPath.row == numberOfLunchItems + 1) {
            cell.textLabel.text = @"Dinner";
        } else if (indexPath.row > numberOfLunchItems + 1) {
            cell.textLabel.text = [NSString stringWithFormat:@"   %@", ((MenuItem*)[[_menuManager getMenuAtIndex:indexPath.section].dinnerMenu objectAtIndex:indexPath.row - (2 + numberOfLunchItems)]).itemName];
        }
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: implement full details page
}

@end
