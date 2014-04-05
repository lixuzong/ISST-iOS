//
//  ISSTRestaurantsTableViewCell.m
//  ISST
//
//  Created by liuyang on 14-4-5.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTRestaurantsTableViewCell.h"

@implementation ISSTRestaurantsTableViewCell
@synthesize clickTel,restaurantName,restaurantTel;

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
