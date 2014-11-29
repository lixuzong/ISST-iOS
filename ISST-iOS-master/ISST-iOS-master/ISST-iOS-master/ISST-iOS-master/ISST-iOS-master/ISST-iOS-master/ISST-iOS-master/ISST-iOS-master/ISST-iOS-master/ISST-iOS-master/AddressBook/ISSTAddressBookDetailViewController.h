//
//  ISSTAddressBookDetailViewController.h
//  ISST
//
//  Created by zhukang on 14-4-13.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTPushedViewController.h"
#import "ISSTUserModel.h"
#import "ISSTClassModel.h"
#import "ISSTMajorModel.h"
#import "ISSTAddressBookDetailTableViewCell.h"
@interface ISSTAddressBookDetailViewController : ISSTPushedViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)ISSTUserModel *userDetailInfo;
@end
