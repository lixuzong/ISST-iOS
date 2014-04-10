//
//  ISSTRestaurantsTableViewCell.m
//  ISST
//
//  Created by zhukang on 14-4-5.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTRestaurantsTableViewCell.h"
@implementation ISSTRestaurantsTableViewCell
@synthesize restaurantName,restaurantTel,picture;

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickTel:(id)sender {
    NSString *telNumber=[NSString stringWithFormat:@"tel://%@",restaurantTel.text];
    NSLog(@"telNumber=%@",telNumber);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telNumber]];
}
@end
