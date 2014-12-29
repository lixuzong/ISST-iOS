//
//  ISSTWikisViewController.m
//  ISST
//
//  Created by zhukang on 14-4-2.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTWikisViewController.h"
#import "ISSTCommonCell.h"
#import "ISSTLifeApi.h"
#import "ISSTCampusNewsModel.h"
#import "ISSTWikisDetailViewController.h"
#import "RESideMenu.h"
#import "ISSTLoginApi.h"
#import "ISSTUserModel.h"
#import "AppCache.h"
#import "MJRefresh.h"


@interface ISSTWikisViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic) ISSTUserModel *userModel;
@property (strong,nonatomic) ISSTLoginApi *userApi;
@property (nonatomic,strong)ISSTLifeApi  *newsApi;
@property (nonatomic,strong) ISSTCampusNewsModel  *WikisModel;
@property(nonatomic,strong)ISSTWikisDetailViewController *WikisDetailView;
@property (strong, nonatomic) NSMutableArray *newsArray;
@end

@implementation ISSTWikisViewController
{
@private
    //RevealBlock _revealBlock;
}
@synthesize newsApi;
@synthesize WikisModel;
@synthesize newsArray;
static NSString *CellIdentifier=@"ISSTCommonCell";
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
    self.title = @"软院百科";
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    [super viewDidLoad];
    self.newsApi = [[ISSTLifeApi alloc]init];
    
    
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.tableView.rowHeight=126;
    self.newsApi.webApiDelegate = self;
    self.newsArray =[[NSMutableArray alloc]init];
    UINib *nib=[UINib nibWithNibName:@"ISSTCommonCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];

    [self setupRefresh];
}
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    // dateKey用于存储刷新时间，可以保证不同界面拥有不同的刷新时间
    [self.self.tableView addHeaderWithTarget:self action:@selector(headerRereshing) ];
    
    [self.self.tableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    // 1.添加数据
    [self.newsApi requestWikisLists:loadPage andPageSize:20 andKeywords:@"string"];
    
    // 刷新表格
    [self.self.tableView reloadData];
    
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [self.self.tableView headerEndRefreshing];
}


- (void)footerRereshing
{
    loadPage++;
    // 1.添加数据
    [self.newsApi requestWikisLists:loadPage andPageSize:20 andKeywords:@"string"];
    
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [self.self.tableView footerEndRefreshing];
}

#pragma mark tableViewDataSouceDelegate

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [newsArray count];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ISSTCommonCell* cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell=[[ISSTCommonCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    WikisModel=[newsArray objectAtIndex:indexPath.row];
    cell.imageView.image =[UIImage imageNamed:@"12091.jpg"];
    cell.title.text=WikisModel.title;
    cell.content.text=WikisModel.description;
    cell.time.text=WikisModel.updatedAt;
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.WikisDetailView=[[ISSTWikisDetailViewController alloc]initWithNibName:@"ISSTWikisDetailViewController" bundle:nil];
    self.WikisDetailView.navigationItem.title =@"详细信息";
    ISSTCampusNewsModel *   tempWikisModel=[newsArray objectAtIndex:indexPath.row];
    self.WikisDetailView.WikisId=tempWikisModel.newsId;
    [self.navigationController pushViewController:self.WikisDetailView animated: YES];
    
}

#pragma mark -
#pragma mark  ISSTWebApiDelegate Methods
- (void)requestDataOnSuccess:(id)backToControllerData
{
    if ([newsArray count]) {
        newsArray = [[NSMutableArray alloc]init];
    }
    newsArray = (NSMutableArray *)backToControllerData;
    //NSLog(@"count =%d ,newsArray = %@",[newsArray count],[newsArray objectAtIndex:0]);
    [self.tableView reloadData];
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
        
        [self viewDidLoad];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
