//
//  ISSTCLMoreTableViewCell.m
//  ISST
//
//  Created by XSZHAO on 14-4-19.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTCLMoreTableViewCell.h"

@implementation ISSTCLMoreTableViewCell
@synthesize moreButtonDelegate;
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)go2MoreTableViewController:(id)sender {

    if([self.moreButtonDelegate respondsToSelector:@selector(go2CommentsMoreTableViewController)])
    {
        [self.moreButtonDelegate go2CommentsMoreTableViewController];
    }
}
@end
