//
//  ISSTRestaurantsViewController.h
//  ISST
//
//  Created by liuyang on 14-4-5.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTPushedViewController.h"
#import "ISSTWebApiDelegate.h"
@interface ISSTRestaurantsViewController : ISSTPushedViewController<UITableViewDataSource,UITableViewDelegate,ISSTWebApiDelegate>

@end
