//
//  ISSTSameCityAcitvitiesViewController.m
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
#import "RESideMenu.h"
#import "MJRefresh.h"
#import "ISSTLoginApi.h"

@interface ISSTSameCityAcitvitiesViewController ()
@property (strong,nonatomic) ISSTUserModel *userModel;
@property (strong,nonatomic) ISSTLoginApi *userApi;

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
    self.title = @"同城活动";
    
    [super viewDidLoad];
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
    
    activitiesArrayTableView.rowHeight=98;
    UINib *nib=[UINib nibWithNibName:@"ISSTActivityCell" bundle:nil];
    [activitiesArrayTableView registerNib:nib forCellReuseIdentifier:CellTableIdentifier];
    
    [self setupRefresh];
}

- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    // dateKey用于存储刷新时间，可以保证不同界面拥有不同的刷新时间
    [self.activitiesArrayTableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    
    [self.activitiesArrayTableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.activitiesArrayTableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    // 1.添加数据
    [self.activityApi requestSameCityActivitiesLists:userInfo.cityId andpage:loadPage andPageSize:20 andKeywords:@"string"];
    
    // 刷新表格
    [self.activitiesArrayTableView reloadData];
    
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [self.activitiesArrayTableView headerEndRefreshing];
}


- (void)footerRereshing
{
    loadPage++;
    // 1.添加数据
    [self.activityApi requestSameCityActivitiesLists:userInfo.cityId andpage:loadPage andPageSize:20 andKeywords:@"string"];
    
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [self.activitiesArrayTableView footerEndRefreshing];
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
    loadPage = 1;
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
    return count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //int count = [activitiesArray count];
    
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


#pragma mark -
#pragma mark  ISSTWebApiDelegate Methods
- (void)requestDataOnSuccess:(id)backToControllerData
{
    
    if (loadPage == 1) {
        activitiesArray = [[NSMutableArray alloc]initWithArray:backToControllerData];
    }
    else
    {
        [activitiesArray addObjectsFromArray:backToControllerData];
    }
    
    [activitiesArrayTableView reloadData];
    

}

- (void)requestDataOnFail:(NSString *)error
{
    
    UIAlertView  *alertView = [[UIAlertView alloc]initWithTitle:@"错误" message:@"网络错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
    [alertView show];
    
    
}

-(void) updateUserLogin{
    self.userApi=[[ISSTLoginApi alloc] init];
    _userModel=[[ISSTUserModel alloc] init ];
    _userModel=[AppCache getCache];
    if (_userModel) {
        [self.userApi updateLoginUserId:[NSString stringWithFormat:@"%d",_userModel.userId] andPassword:_userModel.password];
        [activitiesArray removeAllObjects];
        loadPage=1;
        // 1.添加数据
        [self.activityApi requestSameCityActivitiesLists:userInfo.cityId andpage:loadPage andPageSize:20 andKeywords:@"string"];
        
        // 刷新表格
        [self.activitiesArrayTableView reloadData];
        
    }
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
