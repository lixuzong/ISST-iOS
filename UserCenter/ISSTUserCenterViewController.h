//
//  ISSTUserCenterViewController.h
//  ISST
//
//  Created by XSZHAO on 14-4-5.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTWebApiDelegate.h"
#import "ISSTBaseViewController.h"

int pushbind;
@interface ISSTUserCenterViewController : ISSTBaseViewController<UITableViewDataSource,UITableViewDelegate,ISSTWebApiDelegate>

@end
