//
//  ISSTNewsViewController.h
//  ISST
//
//  Created by XSZHAO on 14-3-31.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISSTWebApiDelegate.h"
#import "ISSTBaseViewController.h"
#import "ISSTUserCenterViewController.h"

@interface ISSTNewsViewController : ISSTBaseViewController<UITableViewDataSource,UITableViewDelegate,ISSTWebApiDelegate>

@end

