//
//  ISSTCommentsMoreViewController.h
//  ISST
//
//  Created by XSZHAO on 14-4-19.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTRootViewController.h"
#import "ISSTWebApiDelegate.h"
@interface ISSTCommentsMoreViewController : ISSTRootViewController<UITableViewDataSource,UITableViewDelegate,ISSTWebApiDelegate>
@property (nonatomic, assign) int       jobId;
@end
