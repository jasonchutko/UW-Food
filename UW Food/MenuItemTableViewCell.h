//
//  MenuItemTableViewCell.h
//  UW Food
//
//  Created by Jason Chutko on 2012-07-21.
//  Copyright (c) 2012 Jason Chutko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuItem.h"

@interface MenuItemTableViewCell : UITableViewCell {
    UIImageView *_mealTypeImageView;
    UILabel *_mealTitleLabel;
}

@property (nonatomic, retain) MenuItem *menuItem;

@end
