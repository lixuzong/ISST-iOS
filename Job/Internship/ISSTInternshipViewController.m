//
//  ISSTEmploymentViewController.m
//  ISST
//
//  Created by liuyang on 14-4-15.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//  

#import "ISSTInternshipViewController.h"
#import "ISSTCommonCell.h"
#import "ISSTPushedViewController.h"
#import "ISSTJobsApi.h"
#import "ISSTJobsModel.h"
#import "ISSTInternshipDetailViewController.h"
#import "MJRefresh.h"


@interface ISSTInternshipViewController ()
@property (weak, nonatomic) IBOutlet UITableView *internshipTableView;
@property (nonatomic,strong)ISSTJobsApi  *internshipApi;
@property (nonatomic,strong)ISSTJobsModel  *internshipModel;
@property (strong, nonatomic)NSMutableArray *internshipArray;
@property (nonatomic,strong) ISSTInternshipDetailViewController *detailView;
@end

@implementation ISSTInternshipViewController
@synthesize internshipTableView;
@synthesize internshipApi;
@synthesize internshipModel;
@synthesize internshipArray;
@synthesize detailView;
static NSString *CellTableIdentifier=@"ISSTCommonCell";

//页面标记
static int  loadPage = 1;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	self.view.backgroundColor = [UIColor lightGrayColor];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [super viewDidLoad];
    self.internshipApi = [[ISSTJobsApi alloc]init];
    
    self.internshipApi.webApiDelegate=self;
    // self.newsArray =[[NSMutableArray alloc]init];
    UITableView *tableView=(id)[self.view viewWithTag:98];
    
    
    //internshipTableView.rowHeight=90;   //原始版本
    internshipTableView.rowHeight=80;    //2014.11.15 rth 修改
    UINib *nib=[UINib nibWithNibName:@"ISSTCommonCell" bundle:nil];
    [internshipTableView registerNib:nib forCellReuseIdentifier:CellTableIdentifier];
    
    
	self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    //[self.internshipApi requestInternshipLists:0 andPageSize:20 andKeywords:@"string"];
    
   
    //调用刷新的方法 MJ
    //[self setupRefresh];
    
    if (_refreshHeaderView == nil ) {
        Class refreshHeaderViewClazz = NSClassFromString(@"EGORefreshTableHeaderView");
        _refreshHeaderView = [[refreshHeaderViewClazz alloc]initWithFrame:CGRectMake(0, -tableView.bounds.size.height, tableView.frame.size.width, tableView.bounds.size.height)];
        
    }
    _refreshHeaderView.delegate= self;
    [tableView addSubview:_refreshHeaderView];
    
    self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    [self    triggerRefresh];
    
}
     
//- (void)setupRefresh
//{
//        // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
//    [self.internshipTableView addHeaderWithTarget:self action:@selector(headerRereshing)];
//    // 自动刷新(一进入程序就下拉刷新)
//    [self.internshipTableView headerBeginRefreshing];
//        
//        // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
//    [self.internshipTableView addFooterWithTarget:self action:@selector(footerRereshing)];
//        
//        // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
//    self.internshipTableView.headerPullToRefreshText = @"下拉可以刷新了";
//    self.internshipTableView.headerReleaseToRefreshText = @"松开马上刷新了";
//    self.internshipTableView.headerRefreshingText = @"正在努力刷新中";
//        
//    self.internshipTableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
//    self.internshipTableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
//    self.internshipTableView.footerRefreshingText = @"正在努力加载中";
//}
//
//- (void)headerRereshing
//{
//    // 1.添加数据
//    [self.internshipApi requestInternshipLists:loadPage andPageSize:20 andKeywords:@"string"];
//    
//    // 刷新表格
//    [self.internshipTableView reloadData];
//    
//    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
//    [self.internshipTableView headerEndRefreshing];
//}
//
//- (void)footerRereshing
//{
//    loadPage++;
//    // 1.添加数据
//    NSLog(@"**************************=%d",loadPage);
//    [self.internshipApi requestInternshipLists:loadPage andPageSize:20 andKeywords:@"string"];
//    
//    
//    // 刷新表格
//    [self.internshipTableView reloadData];
//    
//    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
//    [self.internshipTableView footerEndRefreshing];
//}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)isList
{
    return YES;
}

-(void)triggerRefresh
{
    if (_refreshLoading) {
        return;
    }
    
    CGPoint contentOffset = CGPointMake(0, -55-10-_refreshHeaderView.scrollViewInset.top);
    internshipTableView.contentOffset = contentOffset;
    NSLog(@"&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&=%f",internshipTableView.contentOffset.y);
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:internshipTableView];
    //[self requestRefresh];
    
    //设置分割线
    internshipTableView.separatorColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    if([internshipTableView respondsToSelector:@selector(separatorInset)])
    {
        internshipTableView.separatorInset = UIEdgeInsetsZero;
    }
    internshipTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}


-(void)requestRefresh
{
    if (NO)  //self.newsApi.isLoadingData;
    {
        
    }
    else
    {
        _refreshLoading = YES;
        loadPage =1;
        [self.internshipApi requestInternshipLists:loadPage andPageSize:20 andKeywords:@"string"];
    }
    
    
}

-(void)requestGetMore
{
    if (NO)
    {
        
    }
    else  if (!_refreshLoading)
    {
        ++loadPage;
        _refreshLoading = YES;
        NSLog(@"requestGetMore ===================================loadPage=%d  " ,loadPage);
        [self.internshipApi requestInternshipLists:loadPage andPageSize:20 andKeywords:@"string"];
        [_getMoreCell setInfoText:@"正在加载更多..." forState:MoreCellState_Loading];
    }
}

-(BOOL)canGetMoreData
{
    return YES;
}

-(void)dealloc
{
    internshipTableView.dataSource = nil;
    internshipTableView.delegate = nil;
    internshipTableView = nil;
}



#pragma mark
#pragma mark Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return internshipArray.count;
    NSArray *listData = internshipArray;
    int count = [listData count];
    if (count == 0)
    {
        if (_refreshLoading)
        {
            
        }
        else if (!_refreshLoading)
        {
            count ++;
        }
    }
    else if([self canGetMoreData])
    {
        count ++;
    }
    NSLog(@"===========================================%d",count);
    return count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int count = [internshipArray count];
    NSLog(@"================%d",indexPath.row);
    if (count ==0)
    {
        if (!_refreshLoading)
        {
            _emptyCell.state = EmptyCellState_Tips;
            
        }
        return _emptyCell;
    }
    else if ([self canGetMoreData]&&indexPath.row == [internshipArray count])
    {
        [_getMoreCell setInfoText:@"查看更多" forState:MoreCellState_Information];
        return _getMoreCell;
    }
   
    //111111
    internshipModel =[[ISSTJobsModel alloc]init];
    internshipModel = [internshipArray objectAtIndex:indexPath.row];
    
    ISSTCommonCell *cell=(ISSTCommonCell *)[tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if (cell == nil) {
        cell = (ISSTCommonCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellTableIdentifier];
    }
    
    cell.title.text=internshipModel.title;
    cell.time.text=internshipModel.updatedAt;
    cell.content.text=internshipModel.description;
    return cell;
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell ==_getMoreCell) {
        [self requestGetMore];
        return;
    }
    else if  (cell == _emptyCell)
    {
        [self triggerRefresh];
        return;
    }
    
    ////11111
    self.detailView=[[ISSTInternshipDetailViewController alloc]initWithNibName:@"ISSTInternshipDetailViewController" bundle:nil];
    self.detailView.navigationItem.title =@"实习详细信息";
    ISSTJobsModel *  tempModel= [internshipArray objectAtIndex:indexPath.row];
    self.detailView.internshipId=tempModel.messageId;
    // [self.navigationController setNavigationBarHidden:YES];    //set system navigationbar hidden
    [self.navigationController pushViewController:detailView animated: NO];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *listDatas = internshipArray;
    int count = [listDatas count];
    
    if (count==0)
    {
        if (_refreshLoading)
        {
        }
        else if (!_refreshLoading)
        {
            int height = tableView.bounds.size.height;
            height -= tableView.tableHeaderView.bounds.size.height;
            height -= [self.topLayoutGuide length];
            return height;
        }
    }
    if ([self canGetMoreData]&&indexPath.row ==[internshipArray count]) {
        return 45;
    }
    return 100;
    
}

#pragma mark -
#pragma mark  ISSTWebApiDelegate Methods
- (void)requestDataOnSuccess:(id)backToControllerData
{
//    if ([internshipArray count]) {
//        internshipArray = [[NSMutableArray alloc]init];
//    }
//    internshipArray = (NSMutableArray *)backToControllerData;
//    //  NSLog(@"count =%d ,newsArray = %@",[ExperenceArray count],ExperenceArray);
//    [internshipTableView reloadData];
    
    _refreshHeaderView.lastRefreshDate = [NSDate date];
    
    if (loadPage == 1) {
        internshipArray = [[NSMutableArray alloc]initWithArray:backToControllerData];
        _refreshLoading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:internshipTableView];
    }
    else
    {
        _refreshLoading = NO;
        [internshipArray addObjectsFromArray:backToControllerData];
        [_getMoreCell setInfoText:@"查看更多" forState:MoreCellState_Information];
    }
    
    [internshipTableView reloadData];
}

- (void)requestDataOnFail:(NSString *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您好:" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Private Methods
- (void)pushViewController {
    NSString *vcTitle = [self.title stringByAppendingString:@" - Pushed"];
    UIViewController *vc = [[ISSTPushedViewController alloc] initWithTitle:vcTitle];
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
