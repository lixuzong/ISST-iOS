//
//  ISSTEmploymentTableViewCell.m
//  ISST
//
//  Created by liuyang on 14-4-15.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTCommonCell.h"

@implementation ISSTCommonCell
@synthesize time,title,content,imageView;
- (void)awakeFromNib
{
    self.imageView.image=[UIImage imageNamed:@"moren240.png"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
