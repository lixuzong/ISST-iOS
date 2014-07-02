//
//  GoViewController.m
//  ISST
//
//  Created by XSZHAO on 14-3-20.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//
#import "ISSTSameCityAcitvitiesViewController.h"
#import "ISSTNewsViewController.h"
#import "ISSTSameCitiesApi.h"
#import "ISSTActivityCell.h"
#import "ISSTJobsModel.h"
#import "AppCache.h"
#import "ISSTUserModel.h"
#import "ISSTSameCityActivityDetailViewController.h"
@interface ISSTSameCityAcitvitiesViewController ()
@property (copy, nonatomic) UITableView *activitiesArrayTableView;
@property (nonatomic,strong)ISSTSameCitiesApi  *activityApi;

@property (nonatomic,strong) ISSTJobsModel  *activityModel;

//@property(nonatomic,strong)ISSTNewsDetailViewController *newsDetailView;

@property (strong, nonatomic) NSMutableArray *activitiesArray;
@property (strong,nonatomic)ISSTUserModel *userInfo;
//- (void)pushViewController;
//- (void)revealSidebar;
@end

@implementation ISSTSameCityAcitvitiesViewController

@synthesize activityModel;
@synthesize activitiesArray;
@synthesize activityApi;
@synthesize activitiesArrayTableView;
@synthesize userInfo;

static NSString *CellTableIdentifier=@"ISSTActivityCell";

//页面标记
static int  loadPage = 1;


-(BOOL)isList
{
    return YES;
}


- (void)viewDidLoad
{
    userInfo = [AppCache getCache];
    activitiesArrayTableView = (UITableView *)([self.view viewWithTag:50]);
    activitiesArrayTableView.delegate = self;
    activitiesArrayTableView.dataSource = self;
    
    self.activityApi = [[ISSTSameCitiesApi alloc]init];
    self.activityApi.webApiDelegate = self;
     self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	self.view.backgroundColor = [UIColor lightGrayColor];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [super viewDidLoad];
    
   
    
    activitiesArrayTableView.rowHeight=128;
    UINib *nib=[UINib nibWithNibName:@"ISSTActivityCell" bundle:nil];
    [activitiesArrayTableView registerNib:nib forCellReuseIdentifier:CellTableIdentifier];
    
    
    
    if (_refreshHeaderView == nil ) {
        Class refreshHeaderViewClazz = NSClassFromString(@"EGORefreshTableHeaderView");
        _refreshHeaderView = [[refreshHeaderViewClazz alloc]initWithFrame:CGRectMake(0, -activitiesArrayTableView.bounds.size.height, activitiesArrayTableView.frame.size.width, activitiesArrayTableView.bounds.size.height)];
        
    }
    _refreshHeaderView.delegate= self;
    [activitiesArrayTableView addSubview:_refreshHeaderView];
    
	self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
  
//   [self.activityApi requestSameCityActivitiesLists:2 andpage:loadPage andPageSize:20 andKeywords:@"string"];
    [self    triggerRefresh];
}

-(void)triggerRefresh
{
    if (_refreshLoading) {
        return;
    }
    
    CGPoint contentOffset = CGPointMake(0, -55-10-_refreshHeaderView.scrollViewInset.top);
    activitiesArrayTableView.contentOffset = contentOffset;
    NSLog(@"&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&=%f",activitiesArrayTableView.contentOffset.y);
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:activitiesArrayTableView];
    //[self requestRefresh];
    
    //设置分割线
    activitiesArrayTableView.separatorColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    if([activitiesArrayTableView respondsToSelector:@selector(separatorInset)])
    {
        activitiesArrayTableView.separatorInset = UIEdgeInsetsZero;
    }
    activitiesArrayTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}


-(void)requestRefresh
{
    if (NO)  //self.newsApi.isLoadingData;
    {
        
    }
    else
    {
        NSLog(@"111111111111111111111111111111111111111111111111111111111");
        _refreshLoading = YES;
        loadPage = 1;
        [self.activityApi requestSameCityActivitiesLists:userInfo.cityId andpage:loadPage andPageSize:20 andKeywords:@"string"];
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
        [self.activityApi requestSameCityActivitiesLists:userInfo.cityId andpage:loadPage andPageSize:20 andKeywords:@"string"];

        [_getMoreCell setInfoText:@"正在加载更多..." forState:MoreCellState_Loading];
    }
}

-(BOOL)canGetMoreData
{
    return NO;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)dealloc
{
    activitiesArrayTableView.dataSource = nil;
    activitiesArrayTableView.delegate = nil;
    activitiesArrayTableView = nil;
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
   // return newsArray.count;
    
    NSArray *listData = activitiesArray;
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
    int count = [activitiesArray count];
    NSLog(@"================%d",indexPath.row);
    if (count ==0)
    {
        if (!_refreshLoading)
        {
            _emptyCell.state = EmptyCellState_Tips;
            
        }
        return _emptyCell;
    }
    else if ([self canGetMoreData]&&indexPath.row == [activitiesArray count])
    {
        [_getMoreCell setInfoText:@"查看更多" forState:MoreCellState_Information];
        return _getMoreCell;
    }
    
    
    if(activityModel == nil)
    {
        activityModel =[[ISSTJobsModel alloc] init];
    }
    activityModel = [activitiesArray objectAtIndex:indexPath.row];
    
    ISSTActivityCell *cell=(ISSTActivityCell *)[tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if (cell == nil) {
        cell = (ISSTActivityCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellTableIdentifier];
    }

    cell.title.text     =   activityModel.title;
    cell.time.text      =   activityModel.updatedAt;
    cell.content.text   =   activityModel.description;
    cell.startTime.text =   activityModel.startTime;
    cell.endTime.text   =   activityModel.expireTime;
    cell.owner.text     =   activityModel.userModel.userName;
    return cell;
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    ISSTSameCityActivityDetailViewController *activityDitailView = [[ISSTSameCityActivityDetailViewController alloc]initWithNibName:@"ISSTSameCityActivityDetailViewController" bundle:nil];
    activityDitailView.navigationItem.title =@"活动详情";
    if(activityModel == nil)
    {
        activityModel =[[ISSTJobsModel alloc] init];
    }
   activityModel= [activitiesArray objectAtIndex:indexPath.row];
    activityDitailView.cityId = activityModel.cityId;
    activityDitailView.activityId = activityModel.messageId;
   // [self.navigationController setNavigationBarHidden:YES];    //set system navigationbar hidden
    [self.navigationController pushViewController:activityDitailView animated: NO];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *listDatas = activitiesArray;
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
    if ([self canGetMoreData]&&indexPath.row ==[activitiesArray count]) {
        return 45;
    }
    return 128;
    
}


#pragma mark -
#pragma mark  ISSTWebApiDelegate Methods
- (void)requestDataOnSuccess:(id)backToControllerData
{
    _refreshHeaderView.lastRefreshDate = [NSDate date];
    
    if (loadPage == 1) {
        activitiesArray = [[NSMutableArray alloc]initWithArray:backToControllerData];
        _refreshLoading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:activitiesArrayTableView];
    }
    else
    {
        _refreshLoading = NO;
        [activitiesArray addObjectsFromArray:backToControllerData];
        [_getMoreCell setInfoText:@"查看更多" forState:MoreCellState_Information];
    }
    
    [activitiesArrayTableView reloadData];
    
    
    
//    if ([newsArray count]) {
//        newsArray = [[NSMutableArray alloc]init];
//    }
//    newsArray = (NSMutableArray *)backToControllerData;
//    NSLog(@"count =%d ,newsArray = %@",[newsArray count],newsArray);
//     [newsArrayTableView reloadData];
}

- (void)requestDataOnFail:(NSString *)error
{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您好:" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//    [alert show];
    
    
    _refreshHeaderView.lastRefreshDate = [NSDate date];
    
    if (loadPage == 1) {
        _refreshLoading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:activitiesArrayTableView];
    }
    else
    {
        [_getMoreCell setInfoText:@"加载更多失败，点击查看更多" forState:MoreCellState_Information];
    }
    
    UIAlertView  *alertView = [[UIAlertView alloc]initWithTitle:@"错误" message:@"查看网络连接" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
    [alertView show];
    
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}




//#pragma mark Private Methods
//- (void)pushViewController {
//    NSString *vcTitle = [self.title stringByAppendingString:@""];
//    UIViewController *vc = [[ISSTPushedViewController alloc] initWithTitle:vcTitle];
//    
//    [self.navigationController pushViewController:vc animated:YES];
//}





@end
