//
//  ISSTEmploymentTableViewCell.h
//  ISST
//
//  Created by liuyang on 14-4-15.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISSTActivityCell : UITableViewCell
@property(nonatomic,weak)IBOutlet UILabel *title;
@property(nonatomic,weak)IBOutlet UILabel *time;
@property(nonatomic,weak)IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *endTime;
@property (weak, nonatomic) IBOutlet UILabel *startTime;
@property (weak, nonatomic) IBOutlet UILabel *owner;
@end
