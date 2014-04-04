//
//  ISSTExperenceViewController.h
//  ISST
//
//  Created by liuyang on 14-4-4.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "ISSTRootViewController.h"
#import "ISSTWebApiDelegate.h"
@interface ISSTExperienceViewController : ISSTRootViewController<UITableViewDataSource,UITableViewDelegate,ISSTWebApiDelegate>

@end
