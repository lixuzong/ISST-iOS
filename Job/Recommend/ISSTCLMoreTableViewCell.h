//
//  ISSTCLMoreTableViewCell.h
//  ISST
//
//  Created by XSZHAO on 14-4-19.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISSTMoreButtonDelegate.h"
@interface ISSTCLMoreTableViewCell : UITableViewCell
- (IBAction)go2MoreTableViewController:(id)sender;
@property (nonatomic, assign)id<ISSTMoreButtonDelegate> moreButtonDelegate;
@end
