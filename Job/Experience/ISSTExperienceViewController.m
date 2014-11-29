//
//  ISSTExperenceViewController.m
//  ISST
//
//  Created by liuyang on 14-4-4.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTExperienceViewController.h"
#import "ISSTLifeApi.h"
#import "ISSTCampusNewsModel.h"
#import "ISSTPushedViewController.h"
#import "ISSTCommonCell.h"
#import "ISSTExperienceDetailViewController.h"
#import "MJRefresh.h"
@interface ISSTExperienceViewController ()
@property (weak, nonatomic) IBOutlet UITableView *experienceArrayTableView;
@property (nonatomic,strong)ISSTLifeApi  *experienceApi;
@property (nonatomic,strong)ISSTCampusNewsModel  *experenceModel;
@property (strong, nonatomic)NSMutableArray *experenceArray;
@property (nonatomic,strong) ISSTExperienceDetailViewController *detailView;
//- (void)pushViewController;
//- (void)revealSidebar;
@end

@implementation ISSTExperienceViewController

@synthesize experienceApi;
@synthesize experienceArrayTableView;
@synthesize experenceModel;
@synthesize experenceArray;

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
    self.experienceApi = [[ISSTLifeApi alloc]init];
    
    self.experienceApi.webApiDelegate=self;
    // self.newsArray =[[NSMutableArray alloc]init];
    UITableView *tableView=(id)[self.view viewWithTag:2];
    tableView.rowHeight=90;
    UINib *nib=[UINib nibWithNibName:@"ISSTCommonCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:CellTableIdentifier];
    
    
	self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    //[self.experienceApi requestExperienceLists:1 andPageSize:20 andKeywords:@"string"];

    if (_refreshHeaderView == nil ) {
        Class refreshHeaderViewClazz = NSClassFromString(@"EGORefreshTableHeaderView");
        _refreshHeaderView = [[refreshHeaderViewClazz alloc]initWithFrame:CGRectMake(0, -tableView.bounds.size.height, tableView.frame.size.width, tableView.bounds.size.height)];
        
    }
    _refreshHeaderView.delegate= self;
    [tableView addSubview:_refreshHeaderView];
    
    self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    [self    triggerRefresh];
}

- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.experienceArrayTableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // 自动刷新(一进入程序就下拉刷新)
    [self.experienceArrayTableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.experienceArrayTableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.experienceArrayTableView.headerPullToRefreshText = @"下拉可以刷新了";
    self.experienceArrayTableView.headerReleaseToRefreshText = @"松开马上刷新了";
    self.experienceArrayTableView.headerRefreshingText = @"正在努力刷新中";
    
    self.experienceArrayTableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    self.experienceArrayTableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    self.experienceArrayTableView.footerRefreshingText = @"正在努力加载中";
}

- (void)headerRereshing
{
    // 1.添加数据
    [self.experienceApi requestExperienceLists:loadPage andPageSize:20 andKeywords:@"string"];
    
    // 刷新表格
    [self.experienceArrayTableView reloadData];
    
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [self.experienceArrayTableView headerEndRefreshing];
}

- (void)footerRereshing
{
    loadPage++;
    // 1.添加数据
    [self.experienceApi requestExperienceLists:loadPage andPageSize:20 andKeywords:@"string"];
    
    
    // 刷新表格
    [self.experienceArrayTableView reloadData];
    
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [self.experienceArrayTableView footerEndRefreshing];
}


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
    experienceArrayTableView.contentOffset = contentOffset;
    NSLog(@"&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&=%f",experienceArrayTableView.contentOffset.y);
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:experienceArrayTableView];
    //[self requestRefresh];
    
    //设置分割线
    experienceArrayTableView.separatorColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    if([experienceArrayTableView respondsToSelector:@selector(separatorInset)])
    {
        experienceArrayTableView.separatorInset = UIEdgeInsetsZero;
    }
    experienceArrayTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
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
        [self.experienceApi requestExperienceLists:loadPage andPageSize:20 andKeywords:@"string"];
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
        [self.experienceApi requestExperienceLists:loadPage andPageSize:20 andKeywords:@"string"];
        [_getMoreCell setInfoText:@"正在加载更多..." forState:MoreCellState_Loading];
    }
}

-(BOOL)canGetMoreData
{
    return YES;
}

-(void)dealloc
{
    experienceArrayTableView.dataSource = nil;
    experienceArrayTableView.delegate = nil;
    experienceArrayTableView = nil;
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
    NSArray *listData = experenceArray;
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
    int count = [experenceArray count];
    NSLog(@"================%d",indexPath.row);
    if (count ==0)
    {
        if (!_refreshLoading)
        {
            _emptyCell.state = EmptyCellState_Tips;
            
        }
        return _emptyCell;
    }
    else if ([self canGetMoreData]&&indexPath.row == [experenceArray count])
    {
        [_getMoreCell setInfoText:@"查看更多" forState:MoreCellState_Information];
        return _getMoreCell;
    }
    
    experenceModel =[[ISSTCampusNewsModel alloc]init];
    experenceModel = [experenceArray objectAtIndex:indexPath.row];
    
    ISSTCommonCell *cell=(ISSTCommonCell *)[tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if (cell == nil) {
        cell = (ISSTCommonCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellTableIdentifier];
    }
    
    cell.title.text=experenceModel.title;
    cell.time.text=experenceModel.updatedAt;
    cell.content.text= experenceModel.description;
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
    
    self.detailView=[[ISSTExperienceDetailViewController alloc]initWithNibName:@"ISSTExperienceDetailViewController" bundle:nil];
    self.detailView.navigationItem.title =@"详细信息";
   // ISSTCampusNewsModel *tempNewsModel=[[ISSTCampusNewsModel alloc]init];
  ISSTCampusNewsModel *   tempNewsModel= [experenceArray objectAtIndex:indexPath.row];
   self.detailView.experienceId=tempNewsModel.newsId;
    // [self.navigationController setNavigationBarHidden:YES];    //set system navigationbar hidden
    [self.navigationController pushViewController:self.detailView animated: NO];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *listDatas = experenceArray;
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
    if ([self canGetMoreData]&&indexPath.row ==[experenceArray count]) {
        return 45;
    }
    return 100;
    
}

#pragma mark -
#pragma mark  ISSTWebApiDelegate Methods
- (void)requestDataOnSuccess:(id)backToControllerData
{
    
    _refreshHeaderView.lastRefreshDate = [NSDate date];
    
    if (loadPage == 1) {
        experenceArray = [[NSMutableArray alloc]initWithArray:backToControllerData];
        _refreshLoading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:experienceArrayTableView];
    }
    else
    {
        _refreshLoading = NO;
        [experenceArray addObjectsFromArray:backToControllerData];
        [_getMoreCell setInfoText:@"查看更多" forState:MoreCellState_Information];
    }
    
    [experienceArrayTableView reloadData];
    
    
//    if ([experenceArray count]) {
//        experenceArray = [[NSMutableArray alloc]init];
//    }
//    experenceArray = (NSMutableArray *)backToControllerData;
//  //  NSLog(@"count =%d ,newsArray = %@",[ExperenceArray count],ExperenceArray);
//    [experienceArrayTableView reloadData];
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

//- (void)revealSidebar {
//    _revealBlock();
//}

@end
