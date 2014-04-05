//
//  ISSTRestaurantsTableViewCell.h
//  ISST
//
//  Created by liuyang on 14-4-5.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISSTRestaurantsTableViewCell : UITableViewCell
@property IBOutlet UILabel *restaurantName;
@property IBOutlet UILabel *restaurantTel;
@property (weak, nonatomic) IBOutlet UIButton *clickTel;
@end
