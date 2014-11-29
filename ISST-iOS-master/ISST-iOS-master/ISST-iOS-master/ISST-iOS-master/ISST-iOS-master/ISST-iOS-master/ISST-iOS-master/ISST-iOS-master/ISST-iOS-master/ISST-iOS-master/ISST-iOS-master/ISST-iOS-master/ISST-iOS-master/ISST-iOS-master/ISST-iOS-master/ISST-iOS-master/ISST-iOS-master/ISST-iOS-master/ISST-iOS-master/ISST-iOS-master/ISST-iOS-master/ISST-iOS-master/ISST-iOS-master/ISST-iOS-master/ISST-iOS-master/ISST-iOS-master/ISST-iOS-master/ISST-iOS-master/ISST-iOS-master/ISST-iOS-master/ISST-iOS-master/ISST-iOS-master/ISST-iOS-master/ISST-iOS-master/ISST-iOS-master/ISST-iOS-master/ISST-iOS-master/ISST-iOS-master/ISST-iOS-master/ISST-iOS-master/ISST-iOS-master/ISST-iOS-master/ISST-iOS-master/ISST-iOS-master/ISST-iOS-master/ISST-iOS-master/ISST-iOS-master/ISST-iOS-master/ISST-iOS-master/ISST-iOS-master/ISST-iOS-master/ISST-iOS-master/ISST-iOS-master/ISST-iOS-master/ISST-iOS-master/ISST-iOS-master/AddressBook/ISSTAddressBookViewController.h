//
//  ISSTAddressBookViewController.h
//  ISST
//
//  Created by zhukang on 14-4-9.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTRootViewController.h"
#import "ISSTWebApiDelegate.h"
#import "ISSTUserModel.h"
#import "ISSTContactsApi.h"
#import "ISSTAddressBookDelegate.h"
@interface ISSTAddressBookViewController : ISSTRootViewController<UITableViewDelegate,UITableViewDataSource,ISSTWebApiDelegate,ISSTAddressBookDelegate,UISearchBarDelegate,UISearchDisplayDelegate>

@property(strong,nonatomic)ISSTUserModel *addressBookModel;
@property(strong,nonatomic)ISSTUserModel *userInfo;
@property(strong,nonatomic)ISSTContactsApi *addressBookApi;
@property(assign,nonatomic)BOOL sameCitySwitch;
@end
