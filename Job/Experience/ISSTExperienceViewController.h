//
//  ISSTExperenceViewController.h
//  ISST
//
//  Created by liuyang on 14-4-4.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//  经验交流板块

#import <UIKit/UIKit.h>
#import "ISSTWebApiDelegate.h"
#import "ISSTBaseViewController.h"
@interface ISSTExperienceViewController : ISSTBaseViewController<UITableViewDataSource,UITableViewDelegate,ISSTWebApiDelegate>

@end
