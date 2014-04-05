//
//  ISSTNewsTableViewCell.h
//  ISST
//
//  Created by XSZHAO on 14-3-31.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISSTNewsTableViewCell : UITableViewCell
@property(nonatomic,weak)IBOutlet UILabel *title;
@property(nonatomic,weak)IBOutlet UILabel *time;
@property(nonatomic,weak)IBOutlet UILabel *content;
@end
