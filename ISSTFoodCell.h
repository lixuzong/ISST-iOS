//
//  ISSTFoodCell.h
//  ISST
//
//  Created by lixu on 15/1/16.
//  Copyright (c) 2015年 MSE.ZJU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISSTFoodCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
