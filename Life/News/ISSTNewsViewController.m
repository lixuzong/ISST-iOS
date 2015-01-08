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
//int  loadPage = 1;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        self.newsArray = [[NSMutableArray alloc]init];
//        self.navigationItem.rightBarButtonItem.image=[UIImage imageNamed:@"user.png"];
//
//    }
//    return self;
//}
//
//-(id)init
//{
//    if (self = [super init]) {
//        
//    }
//    return self;
//}

- (void)viewDidLoad
{
    login=1;
    self.newsApi = [[ISSTLifeApi alloc]init];
    self.newsApi.webApiDelegate = self;
    self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    self.title = @"软院快讯";
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [super viewDidLoad];
    
    UITableView *tableView=(id)[self.view viewWithTag:1];
    tableView.rowHeight=126;
    UINib *nib=[UINib nibWithNibName:@"ISSTCommonCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:CellTableIdentifier];
    
    [self setupRefresh];
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
    {
        if(pushtag)
        {
            NSLog(@"push to newscontroller now");
            
            NSLog(@"push tag=%d",pushtag);
            
            [self.navigationController pushViewController:[[ISSTUserCenterViewController alloc]init] animated:NO];
            NSLog(@"push to center");
        }
    }

    
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
   [self.newsApi requestCampusNewsLists:loadPage andPageSize:20 andKeywords:@"string"];
    
    // 刷新表格
    [self.newsArrayTableView reloadData];
    
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [self.newsArrayTableView headerEndRefreshing];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        if(pushtag)
        {
            NSLog(@"push to newscontroller now");
            
            NSLog(@"push tag=%d",pushtag);
            
            [self.navigationController pushViewController:[[ISSTUserCenterViewController alloc]init] animated:NO];
            NSLog(@"push to center");
        }
    }

}


- (void)footerRereshing
{
    loadPage++;
    // 1.添加数据
   [self.newsApi requestCampusNewsLists:loadPage andPageSize:20 andKeywords:@"string"];
    
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [self.newsArrayTableView footerEndRefreshing];
}


-(void)dealloc
{
    newsArrayTableView.dataSource = nil;
    newsArrayTableView.delegate = nil;
    newsArrayTableView = nil;
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
    newsModel =[[ISSTCampusNewsModel alloc]init];
    newsModel = [newsArray objectAtIndex:indexPath.row];
    NSLog(@"666666");
    NSLog(@"%@",newsModel);
    NSLog(@"%lu",(unsigned long)newsArray.count);
    
    ISSTCommonCell *cell=(ISSTCommonCell *)[tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if (cell == nil) {
        cell = (ISSTCommonCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellTableIdentifier];
    }
    
    //[cell.image sd_setImageWithURL:[listdata objectAtIndex:row]];
    //cell.imageView
    //[cell.imageView sd_setImageWithURL:@"http://www.fzlol.com/upimg/allimg/120819/2021144O91.jpg"];
    cell.imageView.image =[UIImage imageNamed:@"12091.jpg"];
    cell.title.text     =   newsModel.title;
    cell.time.text      =   newsModel.updatedAt;
    cell.content.text   =   newsModel.description;
    
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
    UIAlertView  *alertView = [[UIAlertView alloc]initWithTitle:@"错误" message:@"查看网络连接" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
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
        [self.newsApi requestCampusNewsLists:loadPage andPageSize:20 andKeywords:@"string"];
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
