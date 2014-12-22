//
//  ISSTRecommendViewController.m
//  ISST
//
//  Created by rth on 14-12-4.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTRecommendViewController.h"
#import "ISSTCommonCell.h"
#import "ISSTPushedViewController.h"
#import "ISSTJobsApi.h"
#import "ISSTJobsModel.h"
#import "ISSTRecommendDetailViewController.h"
#import "RESideMenu.h"
#import "MJRefresh.h"
#import "ISSTLoginApi.h"
#import "ISSTUserModel.h"
#import "AppCache.h"

@interface ISSTRecommendViewController ()
@property (strong,nonatomic) ISSTUserModel *userModel;
@property (strong,nonatomic) ISSTLoginApi *userApi;

@property (weak, nonatomic) IBOutlet UITableView *recommendTableView;
@property (nonatomic,strong)ISSTJobsApi  *recommendApi;
@property (nonatomic,strong)ISSTJobsModel  *recommendModel;
@property (strong, nonatomic)NSMutableArray *recommendArray;
@property (nonatomic,strong) ISSTRecommendDetailViewController *detailView;
@end

@implementation ISSTRecommendViewController
@synthesize recommendApi;
@synthesize recommendArray;
@synthesize recommendModel;
@synthesize recommendTableView;
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
    self.title = @"内推";
    
    self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [super viewDidLoad];
    self.recommendApi = [[ISSTJobsApi alloc]init];
    
    self.recommendApi.webApiDelegate=self;
    
    //UITableView *tableView=(id)[self.view viewWithTag:97];
    recommendTableView.rowHeight=126;
    
    UINib *nib=[UINib nibWithNibName:@"ISSTCommonCell" bundle:nil];
    [recommendTableView registerNib:nib forCellReuseIdentifier:CellTableIdentifier];
    
    [self setupRefresh];
    
    
    
}

- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    // dateKey用于存储刷新时间，可以保证不同界面拥有不同的刷新时间
    [self.recommendTableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    
    [self.recommendTableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.recommendTableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    // 1.添加数据
    [self.recommendApi requestRecommendLists:loadPage andPageSize:20 andKeywords:@"string"];
    
    // 刷新表格
    [self.recommendTableView reloadData];
    
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [self.recommendTableView headerEndRefreshing];
}


- (void)footerRereshing
{
    loadPage++;
    // 1.添加数据
    [self.recommendApi requestRecommendLists:loadPage andPageSize:20 andKeywords:@"string"];
    
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [self.recommendTableView footerEndRefreshing];
}


-(void)dealloc
{
    recommendTableView.dataSource = nil;
    recommendTableView.delegate = nil;
    recommendTableView = nil;
    loadPage = 1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSArray *listData = recommendArray;
    int count = [listData count];
    return count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    recommendModel =[[ISSTJobsModel alloc]init];
    recommendModel = [recommendArray objectAtIndex:indexPath.row];
    
    ISSTCommonCell *cell=(ISSTCommonCell *)[tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if (cell == nil) {
        cell = (ISSTCommonCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellTableIdentifier];
    }
    
    cell.title.text=recommendModel.title;
    cell.time.text=recommendModel.updatedAt;
    cell.content.text=recommendModel.description;
    cell.imageView.image =[UIImage imageNamed:@"12094.jpg"];
    return cell;
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.detailView=[[ISSTRecommendDetailViewController alloc]initWithNibName:@"ISSTRecommendDetailViewController" bundle:nil];
    self.detailView.navigationItem.title =@"详细信息";
   
   ISSTJobsModel *  tempNewsModel= [recommendArray objectAtIndex:indexPath.row];
   self.detailView.jobId=tempNewsModel.messageId;

    [self.navigationController pushViewController:self.detailView animated: YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark -
#pragma mark  ISSTWebApiDelegate Methods
- (void)requestDataOnSuccess:(id)backToControllerData
{
    
    if (loadPage == 1) {
        recommendArray = [[NSMutableArray alloc]initWithArray:backToControllerData];
    }
    else
    {
        [recommendArray addObjectsFromArray:backToControllerData];
    }
    
    [recommendTableView reloadData];
}

- (void)requestDataOnFail:(NSString *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您好:" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    
}

-(void) updateUserLogin{
    self.userApi=[[ISSTLoginApi alloc] init];
    _userModel=[[ISSTUserModel alloc] init ];
    _userModel=[AppCache getCache];
    if (_userModel) {
        [self.userApi updateLoginUserId:[NSString stringWithFormat:@"%d",_userModel.userId] andPassword:_userModel.password];
        
        [recommendArray removeAllObjects];
        loadPage=1;
        // 1.添加数据
        [self.recommendApi requestRecommendLists:loadPage andPageSize:20 andKeywords:@"string"];
        
        // 刷新表格
        [self.recommendTableView reloadData];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



@end
