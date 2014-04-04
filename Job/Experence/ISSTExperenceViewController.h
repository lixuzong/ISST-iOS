//
//  ISSTExperenceViewController.h
//  ISST
//
//  Created by liuyang on 14-4-4.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "ISSTRootViewController.h"

@interface ISSTExperenceViewController : ISSTRootViewController<UITableViewDataSource,UITableViewDelegate>

- (id)initWithTitle:(NSString *)title withRevealBlock:(RevealBlock)revealBlock;

@end
