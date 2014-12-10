//
//  ISSTSameCityFriendViewController.h
//  ISST
//
//  Created by rth on 14/12/5.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTAddressBookViewController.h"
#import "ISSTBaseViewController.h"

@interface ISSTSameCityFriendViewController : ISSTBaseViewController<UITableViewDelegate,UITableViewDataSource,ISSTWebApiDelegate,ISSTAddressBookDelegate,UISearchBarDelegate,UISearchDisplayDelegate>
@property (weak, nonatomic) IBOutlet UILabel *conditionLabel;
@property (weak, nonatomic) IBOutlet UIButton *clearAllButton;
@property (strong, nonatomic)  UISearchBar *friendSearchBar;
@property (strong,nonatomic) UITableView *friendTableView;

@end

