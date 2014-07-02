//
//  ISSTRestaurantsTableViewCell.h
//  ISST
//
//  Created by zhukang on 14-4-5.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISSTRestaurantsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *restaurantName;

@property (weak, nonatomic) IBOutlet UILabel *restaurantTel;
@property (weak, nonatomic) IBOutlet UIImageView *picture;

@property (weak, nonatomic) IBOutlet UIButton *clickTel;

@end
