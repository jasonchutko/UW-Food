//
//  TransactionCell.m
//  UW Food
//
//  Created by Jason Chutko on 2012-08-08.
//  Copyright (c) 2012 Jason Chutko. All rights reserved.
//

#import "TransactionCell.h"
#import "Utilities/Utilities.h"

@implementation TransactionCell

@synthesize transaction = _transaction;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGRect locationFrame;
        CGRect dateFrame;
        CGRect priceFrame;



        if(IS_IPAD) {
            locationFrame = CGRectMake(60, 2, 400, 21);
            dateFrame = CGRectMake(60, 20, 400, 21);
            priceFrame = CGRectMake(748-145, 11, 114, 21);
        } else {
            locationFrame = CGRectMake(21, 2, 224, 21);
            dateFrame = CGRectMake(21, 20, 178, 21);
            priceFrame = CGRectMake(self.frame.size.width-135, 11, 114, 21);
        }
        
        
               
        _locationLabel = [[UILabel alloc] initWithFrame:locationFrame];
        _dateLabel = [[UILabel alloc] initWithFrame:dateFrame];
        _priceLabel = [[UILabel alloc] initWithFrame:priceFrame];
        
        [self setupLabels];
    }

    return self;
}

- (void)setupLabels {
    [self setupDateLabel];
    [self setupPriceLabel];
    [self setupLocationLabel];

}

- (void)setupLocationLabel {
    [_locationLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
    [_locationLabel setBackgroundColor:[UIColor clearColor]];
    [_locationLabel setHighlightedTextColor:[UIColor whiteColor]];
    [self addSubview:_locationLabel];
}

- (void)setupDateLabel {
    [_dateLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [_dateLabel setBackgroundColor:[UIColor clearColor]];
    [_dateLabel setHighlightedTextColor:[UIColor whiteColor]];
    [self addSubview:_dateLabel];
}

- (void)setupPriceLabel {
    [_priceLabel setBackgroundColor:[UIColor clearColor]];
    [_priceLabel setHighlightedTextColor:[UIColor whiteColor]];
    [_priceLabel setTextAlignment:UITextAlignmentRight];
    [_priceLabel setFont:[UIFont systemFontOfSize:17.0f]];
    [_priceLabel setMinimumFontSize:10.0f];
    [_priceLabel setTextColor:[UIColor colorWithRed:69.0f/255.0f green:106.0f/255.0f blue:149.0f/255.0f alpha:1.0f]];
    [self addSubview:_priceLabel];
}


- (void) setTransaction:(Transaction *)transaction {
    _transaction = transaction;
    
    
    NSLog(@"%@", _transaction.locationString);
    _locationLabel.text = _transaction.locationString;
    _dateLabel.text = _transaction.dateString;
    _priceLabel.text = _transaction.amountString;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
