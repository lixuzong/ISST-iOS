//
//  ISSTEmploymentViewController.m
//  ISST
//
//  Created by liuyang on 14-4-15.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTEmploymentViewController.h"
#import "ISSTCommonCell.h"
#import "ISSTEmploymentDetailViewController.h"
#import "ISSTPushedViewController.h"
#import "ISSTJobsApi.h"
#import "ISSTJobsModel.h"
#import "RESideMenu.h"
#import "MJRefresh.h"
#import "ISSTLoginApi.h"
#import "ISSTUserModel.h"
#import "AppCache.h"

@interface ISSTEmploymentViewController ()
@property (strong,nonatomic) ISSTUserModel *userModel;
@property (strong,nonatomic) ISSTLoginApi *userApi;

@property (weak, nonatomic) IBOutlet UITableView *employTableView;
@property (nonatomic,strong)ISSTJobsApi  *employmentApi;
@property (nonatomic,strong)ISSTJobsModel  *employmentModel;
@property (strong, nonatomic)NSMutableArray *employmentArray;
@property (nonatomic,strong) ISSTEmploymentDetailViewController *detailView;
@end

@implementation ISSTEmploymentViewController
@synthesize employmentModel;
@synthesize employmentApi;
@synthesize employmentArray;
@synthesize employTableView;
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
    self.title = @"就业";
    
    self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [super viewDidLoad];
    self.employmentApi = [[ISSTJobsApi alloc]init];
    
    self.employmentApi.webApiDelegate=self;
    //UITableView *tableView=(id)[self.view viewWithTag:99];
    employTableView.rowHeight=75;
    UINib *nib=[UINib nibWithNibName:@"ISSTCommonCell" bundle:nil];
    [employTableView registerNib:nib forCellReuseIdentifier:CellTableIdentifier];
    
    [self setupRefresh];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    // dateKey用于存储刷新时间，可以保证不同界面拥有不同的刷新时间
    [self.employTableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    
    [self.employTableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.employTableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    // 1.添加数据
    [self.employmentApi requestEmploymentLists:loadPage andPageSize:20 andKeywords:@"string"];
    
    // 刷新表格
    [self.employTableView reloadData];
    
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [self.employTableView headerEndRefreshing];
}


- (void)footerRereshing
{
    loadPage++;
    // 1.添加数据
    [self.employmentApi requestEmploymentLists:loadPage andPageSize:20 andKeywords:@"string"];
    
    //[self.internshipTableView reloadData];}
    
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [self.employTableView footerEndRefreshing];
}


-(void)dealloc
{
    employTableView.dataSource = nil;
    employTableView.delegate = nil;
    employTableView = nil;
    self.employmentApi.webApiDelegate=nil;
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
    NSArray *listData = employmentArray;
    int count = [listData count];
    return count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //int count = [employmentArray count];

    
    employmentModel =[[ISSTJobsModel alloc]init];
    employmentModel = [employmentArray objectAtIndex:indexPath.row];
    
    ISSTCommonCell *cell=(ISSTCommonCell *)[tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if (cell == nil) {
        cell = (ISSTCommonCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellTableIdentifier];
    }
    
//    cell.imageView.image=[UIImage imageNamed:@"12093.jpg"];
    cell.title.text=employmentModel.title;
    cell.time.text=employmentModel.updatedAt;
    cell.content.text=employmentModel.description;
    cell.authorLabel.text=employmentModel.author;
    return cell;
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    self.detailView=[[ISSTEmploymentDetailViewController alloc]initWithNibName:@"ISSTEmploymentDetailViewController" bundle:nil];
    self.detailView.navigationItem.title =@"就业信息详情";
 //  ISSTJobsModel *tempEmploymentModel=[[ISSTJobsModel alloc]init];
    ISSTJobsModel  *tempEmploymentModel= [employmentArray objectAtIndex:indexPath.row];
    self.detailView.employmentId=tempEmploymentModel.messageId;
    // [self.navigationController setNavigationBarHidden:YES];    //set system navigationbar hidden
    [self.navigationController pushViewController:self.detailView animated: NO];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark -
#pragma mark  ISSTWebApiDelegate Methods
- (void)requestDataOnSuccess:(id)backToControllerData
{

    if (loadPage == 1) {
        employmentArray = [[NSMutableArray alloc]initWithArray:backToControllerData];
    }
    else
    {
        [employmentArray addObjectsFromArray:backToControllerData];
    }
    
    [employTableView reloadData];
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
        
        [employmentArray removeAllObjects];
        loadPage=1;
        [self.employmentApi requestEmploymentLists:loadPage andPageSize:20 andKeywords:@"string"];
        
        // 刷新表格
        [self.employTableView reloadData];

    }
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
