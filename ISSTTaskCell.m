//
//  ISSTTaskCell.m
//  ISST
//
//  Created by rth on 14/12/6.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTTaskCell.h"

@implementation ISSTTaskCell
@synthesize TaskType,TaskActivity,TaskImage,finishLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
