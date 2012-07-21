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

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
