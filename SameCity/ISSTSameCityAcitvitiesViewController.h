//
//  ISSTNewsViewController.h
//  ISST
//
//  Created by XSZHAO on 14-3-31.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISSTRootViewController.h"
#import "ISSTWebApiDelegate.h"

@interface ISSTSameCityAcitvitiesViewController : ISSTRootViewController<UITableViewDataSource,UITableViewDelegate,ISSTWebApiDelegate>

@end

