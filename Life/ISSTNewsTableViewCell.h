//
//  ISSTNewsTableViewCell.h
//  ISST
//
//  Created by XSZHAO on 14-3-31.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISSTNewsTableViewCell : UITableViewCell
@property(nonatomic,weak)IBOutlet UILabel *Title;
@property(nonatomic,weak)IBOutlet UILabel *Time;
@property(nonatomic,weak)IBOutlet UILabel *Content;
@end
