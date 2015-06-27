//
//  GoViewController.m
//  ISST
//
//  Created by XSZHAO on 14-3-20.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//
#import "ISSTNewsDetailViewController.h"
#import "ISSTNewsViewController.h"
#import "ISSTLifeApi.h"
#import "ISSTCommonCell.h"
#import "ISSTCampusNewsModel.h"
#import "RESideMenu.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "ISSTLoginApi.h"
#import "ISSTUserModel.h"
#import "ISSTUserCenterViewController.h"
#import "AppDelegate.h"
#import "AppCache.h"
#import "ISSTUserCenterViewController.h"
#import "AFNetworking.h"
#import "ISSTCampusNewsParse.h"

@interface ISSTNewsViewController ()

@property (strong,nonatomic) ISSTUserModel *userModel;
@property (strong,nonatomic) ISSTLoginApi *userApi;

@property (weak, nonatomic) IBOutlet UITableView *newsArrayTableView;
@property (nonatomic,strong)ISSTLifeApi  *newsApi;

@property (nonatomic,strong) ISSTCampusNewsModel  *newsModel;

@property(nonatomic,strong)ISSTNewsDetailViewController *newsDetailView;

@property (strong, nonatomic) NSMutableArray *newsArray;



//- (void)pushViewController;
//- (void)revealSidebar;
@end

@implementation ISSTNewsViewController

@synthesize newsModel;
@synthesize newsApi;
@synthesize newsArray;
@synthesize newsArrayTableView;
@synthesize newsDetailView;
static NSString *CellTableIdentifier=@"ISSTCommonCell";

//页面标记
static int  loadPage = 1;
static int  numofclick = 0;
//int  loadPage = 1;


-(id)init
{
    NSLog(@"init news");
    if (self = [super init]) {
        self.navigationItem.rightBarButtonItem.image=[UIImage imageNamed:@"user.png"];
    }
    return self;
}

- (void)viewDidLoad
{
    loadPage=1;
    login=1;
    numofclick++;
  
    self.newsApi = [[ISSTLifeApi alloc]init];
    self.newsApi.webApiDelegate = self;
    self.userApi=[[ISSTLoginApi alloc] init];
    self.userApi.webApiDelegate=self;
//    self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    self.title = @"正在加载...";
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [super viewDidLoad];
    
    UITableView *tableView=(id)[self.view viewWithTag:1];
    tableView.rowHeight=75;
    UINib *nib=[UINib nibWithNibName:@"ISSTCommonCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:CellTableIdentifier];
    
    _userModel=[[ISSTUserModel alloc] init ];
    _userModel=[AppCache getCache];
    
    
    NSLog(@"numofloadpage=%d",numofclick);
//    NSLog(@"student=%@", _userModel.userName);
    NSLog(@"bpushidandchannelid=%@%@",bpuserid,bpchannelid);
    
    NSLog(@"pushbind=%d",pushbind);
    if ((bpuserid&&(numofclick<=1))||pushbind==1) {
        pushbind=0;
        NSLog(@"numofclick=%d",numofclick);
        NSLog(@"post push id by newsview");
        [self.userApi postPushWithStudentid: _userModel.userName andUserid:bpuserid andChannelid:bpchannelid];
    }
    
    if (!netok) {
        [self setupRefresh];
//        [self getCampusList];
    }
    
    
  
    
}

-(void)getCampusList
{
    NSString *url=[NSString stringWithFormat:@"http://www.cst.zju.edu.cn/isst/api/archives/categories/campus?page=%d&pageSize=10",loadPage];
    AFHTTPRequestOperationManager *httpRequestOperationManager=[AFHTTPRequestOperationManager manager];
    httpRequestOperationManager.requestSerializer=[AFHTTPRequestSerializer serializer];
    httpRequestOperationManager.responseSerializer = [AFJSONResponseSerializer serializer];
    [httpRequestOperationManager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         ISSTCampusNewsParse *news  = [[ISSTCampusNewsParse alloc]init];
         NSLog(@"yes success");
         NSLog(@"response=%@",responseObject);
         NSArray *array=[news campusNewsInfoParseWith:responseObject];
         [self requestDataOnSuccess:array];
     }failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"yes no");
     }];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    // dateKey用于存储刷新时间，可以保证不同界面拥有不同的刷新时间
    [self.newsArrayTableView addHeaderWithTarget:self action:@selector(headerRereshing) ];
    
    [self.newsArrayTableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.newsArrayTableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    // 1.添加数据
    loadPage=1;
//   [self.newsApi requestCampusNewsLists:loadPage andPageSize:10 andKeywords:@"string"];
    
    [self getCampusList];
    // 刷新表格
    [self.newsArrayTableView reloadData];
    
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [self.newsArrayTableView headerEndRefreshing];
    if(pushtag)
    {
        NSLog(@"push to newscontroller now");
        
        NSLog(@"push tag=%d",pushtag);
        
        [self.navigationController pushViewController:[[ISSTUserCenterViewController alloc]init] animated:NO];
        NSLog(@"push to center");
    }

}


- (void)footerRereshing
{
    loadPage++;
    // 1.添加数据
   [self.newsApi requestCampusNewsLists:loadPage andPageSize:10 andKeywords:@"string"];
    
//    [self getCampusList];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [self.newsArrayTableView footerEndRefreshing];
}


-(void)dealloc
{
    newsArrayTableView.dataSource = nil;
    newsArrayTableView.delegate = nil;
    newsArrayTableView = nil;
    self.newsApi.webApiDelegate=nil;
    self.userApi.webApiDelegate=nil;
    
    
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
    
    NSArray *listData = newsArray;
    int count = [listData count];
    return count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.title=@"软院快讯";
    newsModel =[[ISSTCampusNewsModel alloc]init];
    newsModel = [newsArray objectAtIndex:indexPath.row];
    
//    NSLog(@"%@",newsModel);
    NSLog(@"cellForRowAtIndexPath: num of news=%lu",(unsigned long)newsArray.count);
    
    ISSTCommonCell *cell=(ISSTCommonCell *)[tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if (cell == nil) {
     }
    
    //[cell.image sd_setImageWithURL:[listdata objectAtIndex:row]];
    //cell.imageView
    //[cell.imageView sd_setImageWithURL:@"http://www.fzlol.com/upimg/allimg/120819/2021144O91.jpg"];
   // cell.imageView.image =[UIImage imageNamed:@"12091.jpg"];
    cell.title.text     =   newsModel.title;
    cell.time.text      =   newsModel.updatedAt;
    cell.content.text   =   newsModel.description;
    cell.authorLabel.text=newsModel.userName;
    
    //隐藏tableview中没有数据的cell的分隔线
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    

    return cell;
    
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    self.newsDetailView=[[ISSTNewsDetailViewController alloc]initWithNibName:@"ISSTNewsDetailViewController" bundle:nil];
    self.newsDetailView.navigationItem.title =@"详细信息";
  //  ISSTCampusNewsModel *tempNewsModel=[[ISSTCampusNewsModel alloc]init];
    
    ISSTCampusNewsModel * tempNewsModel= [newsArray objectAtIndex:indexPath.row];
    self.newsDetailView.newsId=tempNewsModel.newsId;
   
    // [self.navigationController setNavigationBarHidden:YES];    //set system navigationbar hidden
    [self.navigationController pushViewController:self.newsDetailView animated: NO];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSArray *listDatas = newsArray;
//    int count = [listDatas count];
//    
//    if (count==0)
//    {
//        if (_refreshLoading)
//        {
//        }
//        else if (!_refreshLoading)
//        {
//            int height = tableView.bounds.size.height;
//            height -= tableView.tableHeaderView.bounds.size.height;
//            height -= [self.topLayoutGuide length];
//            return height;
//        }
//    }
//    if ([self canGetMoreData]&&indexPath.row ==[newsArray count]) {
//        return 45;
//    }
//    return 77;
//    //return 150;
//    
//}


#pragma mark -
#pragma mark  ISSTWebApiDelegate Methods
- (void)requestDataOnSuccess:(id)backToControllerData
{
    
    NSLog(@"7758258111111");
    NSLog(@"%d",loadPage);
    if (loadPage == 1) {
        newsArray = [[NSMutableArray alloc]initWithArray:backToControllerData];
    }
    else
    {
        [newsArray addObjectsFromArray:backToControllerData];
    }
    
    [newsArrayTableView reloadData];
    
}

- (void)requestDataOnFail:(NSString *)error
{
    UIAlertView  *alertView = [[UIAlertView alloc]initWithTitle:@"错误" message:error delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
    [alertView show];
    
    
}

-(void) updateUserLogin{
    self.userApi=[[ISSTLoginApi alloc] init];
    _userModel=[[ISSTUserModel alloc] init ];
    _userModel=[AppCache getCache];
    if (_userModel) {
        [self.userApi updateLoginUserId:[NSString stringWithFormat:@"%d",_userModel.userId] andPassword:_userModel.password];
        [newsArray removeAllObjects];
        loadPage=1;
        [self.newsApi requestCampusNewsLists:loadPage andPageSize:10 andKeywords:@"string"];
        [newsArrayTableView reloadData];
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
