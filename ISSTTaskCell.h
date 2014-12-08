//
//  ISSTTaskCell.h
//  ISST
//
//  Created by rth on 14/12/6.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISSTTaskCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *TaskType;
@property (strong, nonatomic) IBOutlet UILabel *TaskActivity;
@property (strong, nonatomic) IBOutlet UIImageView *TaskImage;

@property (strong, nonatomic) IBOutlet UILabel *finishLabel;

@end
