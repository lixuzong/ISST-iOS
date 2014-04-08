//
//  ISSTUserCenterUserInfoTableViewCell.h
//  ISST
//
//  Created by XSZHAO on 14-4-7.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISSTUserCenterUserInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userPictureImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userDescriptionLabel;

@end
