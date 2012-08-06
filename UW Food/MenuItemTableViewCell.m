//
//  MenuItemTableViewCell.m
//  UW Food
//
//  Created by Jason Chutko on 2012-07-21.
//  Copyright (c) 2012 Jason Chutko. All rights reserved.
//

#import "MenuItemTableViewCell.h"

@implementation MenuItemTableViewCell

@synthesize menuItem = _menuItem;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _mealTypeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 13, 17, 17)];
        _mealTypeImageView.contentMode = UIViewContentModeScaleAspectFit;
        _mealTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 10, self.frame.size.width - 75, self.frame.size.height - 20)];
        [_mealTitleLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_mealTitleLabel];
        [self addSubview:_mealTypeImageView];
    }
    return self;
}

- (void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if(highlighted) {
        _mealTitleLabel.textColor = [UIColor whiteColor];
    } else {
        _mealTitleLabel.textColor = [UIColor blackColor];
    }
}

- (void) setLeftImage {
    switch (_menuItem.mealType) {
        case 0:
            [_mealTypeImageView setImage:[UIImage imageNamed:@"default"]];
            break;
        case 1:
            [_mealTypeImageView setImage:[UIImage imageNamed:@"halal"]];
            break;
        case 2:
            [_mealTypeImageView setImage:[UIImage imageNamed:@"vegan"]];
            break;
        case 3:
            [_mealTypeImageView setImage:[UIImage imageNamed:@"vegetarian"]];
            break;
        case 4:
            [_mealTypeImageView setImage:[UIImage imageNamed:@"star"]];
            break;
        default:
            [_mealTypeImageView setImage:[UIImage imageNamed:@"default"]];
            break;
    }
}

- (void) setMenuItem:(MenuItem *)menuItem {
    _menuItem = menuItem;
    _mealTitleLabel.text = _menuItem.itemName;
    [self setLeftImage];
}

@end
