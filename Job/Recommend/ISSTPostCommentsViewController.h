//
//  ISSTPostCommentsViewController.h
//  ISST
//
//  Created by XSZHAO on 14-4-19.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTPushedViewController.h"
#import "ISSTWebApiDelegate.h"
@interface ISSTPostCommentsViewController : ISSTPushedViewController<ISSTWebApiDelegate>
@property (nonatomic, assign) int       jobId;
@end
