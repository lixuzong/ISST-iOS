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

#import "ISSTSelectFactorsViewController.h"
#import "ISSTAddressBookDetailViewController.h"
#import "AppCache.h"
#import "RESideMenu.h"

@interface ISSTAddressBookViewController : ISSTRootViewController<UITableViewDelegate,UITableViewDataSource,ISSTWebApiDelegate,ISSTAddressBookDelegate,UISearchBarDelegate,UISearchDisplayDelegate>

@property(strong,nonatomic)ISSTUserModel *addressBookModel;
@property(strong,nonatomic)ISSTUserModel *userInfo;
@property(strong,nonatomic)ISSTContactsApi *addressBookApi;
@property(assign,nonatomic)BOOL sameCitySwitch;
@property (copy, nonatomic) UITableView *addressBookTableView;
@property(strong,nonatomic)NSMutableArray *addressBookArray;
@property (strong,nonatomic) NSArray *filteredArray;
@property(strong,nonatomic)ISSTSelectFactorsViewController *selectFactorsViewController;
@property(strong,nonatomic)ISSTAddressBookDetailViewController* addressBookDetailView;
@property(strong,nonatomic)NSMutableArray *namesArray;
@property(strong,nonatomic)NSMutableArray *searchArray;
-(void)selectedReloadData;


@property(retain, nonatomic) UISearchBar *searchBar;


@property (weak, nonatomic) IBOutlet UILabel *selectedFactorsLabel;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;
- (IBAction)clearSelectedFactors:(id)sender;

-(void)labelShow;
@end
