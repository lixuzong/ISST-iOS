//
//  ISSTTaskViewController.m
//  ISST
//
//  Created by rth on 14/12/6.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTTaskViewController.h"
#import "ISSTTaskCell.h"
#import "ISSTTasksModel.h"
#import "ISSTUserCenterApi.h"
#import "MJRefresh.h"
#import "ISSTTaskDetailViewController.h"

@interface ISSTTaskViewController ()<ISSTWebApiDelegate>{
    NSMutableArray *_listData;
}

@property (strong, nonatomic) IBOutlet UITableView *TasktableView;
@property (nonatomic,strong)ISSTUserCenterApi         *taskApi;
@property (nonatomic,strong)ISSTTaskDetailViewController *taskDetailViewController;

@end

@implementation ISSTTaskViewController
static NSString *CellWithIdentifier=@"ISSTTaskCell";
//页面标记
static int  loadPage = 1;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"任务中心";
    
    self.taskApi = [[ISSTUserCenterApi alloc]init];
    self.taskApi.webApiDelegate = self;
    _listData = [[NSMutableArray alloc] init];
    
    self.TasktableView.rowHeight = 80;
    
    self.TasktableView.tableFooterView =[[UIView alloc]initWithFrame:CGRectZero]; //UITableView去除多余的横线
    
    [self setupRefresh];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    // dateKey用于存储刷新时间，可以保证不同界面拥有不同的刷新时间
    [self.TasktableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    
    [self.TasktableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.TasktableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    // 1.添加数据
    [self.taskApi requestTasksLists:loadPage pageSize:20 keywords:@"string"];
    
    // 刷新表格
    [self.TasktableView reloadData];
    
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [self.TasktableView headerEndRefreshing];
}


- (void)footerRereshing
{
    loadPage++;
    // 1.添加数据
    [self.taskApi requestTasksLists:loadPage pageSize:20 keywords:@"string"];
    
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [self.TasktableView footerEndRefreshing];
}



#pragma mark -UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_listData count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UINib *nib=[UINib nibWithNibName:@"ISSTTaskCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:CellWithIdentifier];
    
    ISSTTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    
    if (cell == nil) {
        cell = [[ISSTTaskCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellWithIdentifier];
    }
    
    ISSTTasksModel *model = [_listData objectAtIndex:indexPath.row];
    if(model.type == 0){
        cell.TaskType.text=@"去向调查";
        cell.imageView.image = [UIImage imageNamed:@"1262256.jpg"];
    }else{
        cell.TaskType.text=@"其他";
        cell.imageView.image = [UIImage imageNamed:@"user.png"];
    }
    if(model.finishId == 0){
        cell.finishLabel.text =@"未完成";
    }else{
        cell.finishLabel.text =@"已完成";
    }
    cell.TaskActivity.text=model.name;
    
    return  cell;
    
}

#pragma mark -UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    ISSTTasksModel *tempTaskModel =[_listData objectAtIndex:indexPath.row];
    self.taskDetailViewController=[[ISSTTaskDetailViewController alloc]initWithNibName:@"ISSTTaskDetailViewController" bundle:nil];
    self.taskDetailViewController.taskId = tempTaskModel.taskId;
    self.taskDetailViewController.detail = tempTaskModel.description;
    self.taskDetailViewController.startTime = tempTaskModel.startTime;
    self.taskDetailViewController.expireTime = tempTaskModel.expireTime;
    self.taskDetailViewController.TaskName = tempTaskModel.name;
    
    [self.navigationController pushViewController:self.taskDetailViewController  animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

#pragma mark - ISSTWebApiDelegate

- (void)requestDataOnSuccess:(id)backToControllerData
{
    if (loadPage == 1) {
        _listData = [[NSMutableArray alloc]initWithArray:backToControllerData];
    }
    else
    {
        [_listData addObjectsFromArray:backToControllerData];
    }
    
    [self.TasktableView reloadData];
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
