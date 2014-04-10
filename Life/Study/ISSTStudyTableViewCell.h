//
//  ISSTStudyTableViewCell.h
//  ISST
//
//  Created by zhukang on 14-4-4.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISSTStudyTableViewCell : UITableViewCell
@property(nonatomic,weak)IBOutlet UILabel *title;
@property(nonatomic,weak)IBOutlet UILabel *time;
@property(nonatomic,weak)IBOutlet UILabel *content;
@end
