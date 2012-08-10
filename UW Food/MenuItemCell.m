//
//  MenuItemTableViewCell.m
//  UW Food
//
//  Created by Jason Chutko on 2012-07-21.
//  Copyright (c) 2012 Jason Chutko. All rights reserved.
//

#import "MenuItemCell.h"
#import "Utilities/Utilities.h"

@implementation MenuItemCell

@synthesize menuItem = _menuItem;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    
        CGRect imageFrame;
        
        if(IS_IPAD) {
            imageFrame = CGRectMake(60, 14, 17, 17);
            self.frame = CGRectMake(0, 0, 708, 44);
        } else  {
            imageFrame = CGRectMake(20, 14, 17, 17);
        }
                
        
        _mealTypeImageView = [[UIImageView alloc] initWithFrame:imageFrame];
        _mealTypeImageView.contentMode = UIViewContentModeScaleAspectFit;
        _mealTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageFrame.origin.x + 25, 10, self.frame.size.width - 75, self.frame.size.height - 20)];
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
            [_mealTypeImageView setImage:[UIImage imageNamed:@"circle"]];
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
            [_mealTypeImageView setImage:[UIImage imageNamed:@"circle"]];
            break;
    }
}

- (void) setMenuItem:(MenuItem *)menuItem {
    _menuItem = menuItem;
    _mealTitleLabel.text = _menuItem.itemName;
    [self setLeftImage];
}

@end
