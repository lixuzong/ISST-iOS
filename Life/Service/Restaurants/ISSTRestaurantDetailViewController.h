//
//  ISSTRestaurantDetailViewController.h
//  ISST
//
//  Created by zhukang on 14-4-6.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTPushedViewController.h"
#import "ISSTWebApiDelegate.h"
@interface ISSTRestaurantDetailViewController : ISSTPushedViewController
<UITableViewDataSource,UITableViewDelegate,ISSTWebApiDelegate>
@property(nonatomic,assign)int restaurantsId;
@end
