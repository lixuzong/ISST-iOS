//
//  ISSTActivityDetailViewController.h
//  ISST
//
//  Created by XSZHAO on 14-4-7.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTPushedViewController.h"
#import "ISSTWebApiDelegate.h"
@interface ISSTActivityDetailViewController : ISSTPushedViewController<ISSTWebApiDelegate>
@property(nonatomic,assign)int activityId;
@end
