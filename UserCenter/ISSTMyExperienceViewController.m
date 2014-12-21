//
//  ISSTMyExperienceViewController.m
//  ISST
//
//  Created by rth on 14-12-20.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTMyExperienceViewController.h"
#import "ISSTUserCenterApi.h"
#import "ISSTExperienceModel.h"
#import "ISSTExperienceCell.h"
#import "ISSTPostExperienceViewController.h"
#import "MJRefresh.h"

@interface ISSTMyExperienceViewController ()<UITableViewDataSource,UITableViewDelegate,ISSTWebApiDelegate>
{
    NSMutableArray *_listData;
    ISSTUserCenterApi *_userCenterApi;
    UITableView *_tableView;
    
}
@end

@implementation ISSTMyExperienceViewController
//页面标记
static int  loadPage = 1;
static NSString *CellTableIdentifier=@"ISSTExperienceCell";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initializatio
        self.title =@"我的经验";
        _userCenterApi = [[ISSTUserCenterApi alloc]init];
        _userCenterApi.webApiDelegate = self;
        _listData = [[NSMutableArray alloc] init];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStyleBordered target:self action:@selector(sendExperience)];
    UITableView *tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    tableView.dataSource = self ;
    tableView.delegate = self;
    
    [self.view addSubview:tableView];
    _tableView = tableView;
    _tableView.rowHeight = 80;
    
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero]; //去除多余横线
    
    [self setupRefresh];
    
}

- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    // dateKey用于存储刷新时间，可以保证不同界面拥有不同的刷新时间
    [_tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    
    [_tableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [_tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    // 1.添加数据
    [_userCenterApi requestExperienceLists:loadPage pageSize:20 keywords:@"string"];
    
    // 刷新表格
    [_tableView reloadData];
    
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [_tableView headerEndRefreshing];
}


- (void)footerRereshing
{
    loadPage++;
    // 1.添加数据
    [_userCenterApi requestExperienceLists:loadPage pageSize:20 keywords:@"string"];
    
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [_tableView footerEndRefreshing];
}


-(void)sendExperience
{
    ISSTPostExperienceViewController *controller = [[ISSTPostExperienceViewController alloc] init];
    [self.navigationController pushViewController:controller animated:NO];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"*******************");
    NSLog(@"%lu",(unsigned long)[_listData count]);
    return [_listData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UINib *nib=[UINib nibWithNibName:@"ISSTExperienceCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:CellTableIdentifier];
    
    ISSTExperienceCell *cell=(ISSTExperienceCell *)[tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if (cell == nil) {
        cell = (ISSTExperienceCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellTableIdentifier];
    }
    
    ISSTExperienceModel *model = [_listData objectAtIndex:indexPath.row];

    cell.title.text = model.title;
    
    if (model.status == 0){
        cell.status.text= @"未审核";
    }else{
        cell.status.text =@"已审核";
    }
    
    return cell;
}

#pragma mark -UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"123");
       
}

#pragma mark - ISSTWebApiDelegate

- (void)requestDataOnSuccess:(id)backToControllerData
{
//    _listData = backToControllerData;
//    if ([_listData count]>0) {
//             [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
//          [_tableView reloadData];
//    }
//    else
//    {
//        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"您未发送过经验" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
//        [alert show];
//    }
    if (loadPage == 1) {
        _listData = [[NSMutableArray alloc]initWithArray:backToControllerData];
        if([_listData count]==0){
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"您未发送过经验" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
            [alert show];
        }
    }
    else
    {
        [_listData addObjectsFromArray:backToControllerData];
    }
    
    [_tableView reloadData];
  
}

- (void)requestDataOnFail:(NSString *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"异常" message:error delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
    [alert show];
}

-(void)dealloc{
    loadPage=1;
}

@end


