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
#import "RESideMenu.h"
#import "MJRefresh.h"
#import "ISSTLoginApi.h"
#import "ISSTUserModel.h"
#import "AppCache.h"

@interface ISSTExperienceViewController ()
@property (strong,nonatomic) ISSTUserModel *userModel;
@property (strong,nonatomic) ISSTLoginApi *userApi;

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
    self.title = @"经验交流";
    
    self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [super viewDidLoad];
    self.experienceApi = [[ISSTLifeApi alloc]init];
    
    self.experienceApi.webApiDelegate=self;
    
    UITableView *tableView=(id)[self.view viewWithTag:2];
    tableView.rowHeight=75;
    UINib *nib=[UINib nibWithNibName:@"ISSTCommonCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:CellTableIdentifier];
    
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
    [self.experienceArrayTableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    
    [self.experienceArrayTableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.experienceArrayTableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
}

#pragma mark 开始进入刷新状态
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

    
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [self.experienceArrayTableView footerEndRefreshing];
}


-(void)dealloc
{
    experienceArrayTableView.dataSource = nil;
    experienceArrayTableView.delegate = nil;
    experienceArrayTableView = nil;
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
    NSArray *listData = experenceArray;
    int count = [listData count];
    return count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    experenceModel =[[ISSTCampusNewsModel alloc]init];
    experenceModel = [experenceArray objectAtIndex:indexPath.row];
    
    ISSTCommonCell *cell=(ISSTCommonCell *)[tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if (cell == nil) {
        cell = (ISSTCommonCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellTableIdentifier];
    }
    
//    cell.imageView.image =[UIImage imageNamed:@"12092.jpg"];
    cell.title.text=experenceModel.title;
    cell.time.text=experenceModel.updatedAt;
    cell.content.text= experenceModel.description;
    cell.authorLabel.text=experenceModel.userName;
    return cell;
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    self.detailView=[[ISSTExperienceDetailViewController alloc]initWithNibName:@"ISSTExperienceDetailViewController" bundle:nil];
    self.detailView.navigationItem.title =@"详细信息";
   // ISSTCampusNewsModel *tempNewsModel=[[ISSTCampusNewsModel alloc]init];
  ISSTCampusNewsModel *   tempNewsModel= [experenceArray objectAtIndex:indexPath.row];
   self.detailView.experienceId=tempNewsModel.newsId;
    // [self.navigationController setNavigationBarHidden:YES];    //set system navigationbar hidden
    [self.navigationController pushViewController:self.detailView animated: NO];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark -
#pragma mark  ISSTWebApiDelegate Methods
- (void)requestDataOnSuccess:(id)backToControllerData
{
    
    if (loadPage == 1) {
        experenceArray = [[NSMutableArray alloc]initWithArray:backToControllerData];
    }
    else
    {
        [experenceArray addObjectsFromArray:backToControllerData];
    }
    
    [experienceArrayTableView reloadData];
    
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
        [experenceArray removeAllObjects];
        loadPage=1;
        // 1.添加数据
        [self.experienceApi requestExperienceLists:loadPage andPageSize:20 andKeywords:@"string"];
        
        // 刷新表格
        [self.experienceArrayTableView reloadData];

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

//- (void)revealSidebar {
//    _revealBlock();
//}

@end
