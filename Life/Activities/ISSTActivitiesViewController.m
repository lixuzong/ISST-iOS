//
//  ISSTActivitiesViewController.m
//  ISST
//
//  Created by XSZHAO on 14-4-7.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTActivitiesViewController.h"
#import "ISSTActivityApi.h"
#import "ISSTActivityModel.h"
#import "ISSTActivityTableViewCell.h"
#import "ISSTActivityDetailViewController.h"
#import "CycleScrollView.h"
#import "RESideMenu.h"
#import "MJRefresh.h"
#import "ISSTLoginApi.h"
#import "ISSTUserModel.h"
#import "AppCache.h"

@interface ISSTActivitiesViewController ()
@property (strong,nonatomic) ISSTUserModel *userModel;
@property (strong,nonatomic) ISSTLoginApi *userApi;

@property (weak, nonatomic) IBOutlet UITableView    *activitiesTableView;
@property (nonatomic,strong)ISSTActivityApi         *activitiesApi;
@property (nonatomic,strong)NSMutableArray          *activitiesArray;
@property (nonatomic,strong)ISSTActivityModel       *activityModel;
@property (nonatomic,strong)ISSTActivityDetailViewController    *activityDetailViewController;

@property (nonatomic , retain) CycleScrollView *mainScorllView;

@end

@implementation ISSTActivitiesViewController
static NSString *CellTableIdentifier =@"ISSTActivityTableViewCell";
@synthesize activitiesArray;
@synthesize activitiesTableView;
@synthesize activityModel;
@synthesize activitiesApi;

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
    self.title = @"在校活动";
    
    self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [super viewDidLoad];
    
    self.activitiesApi = [[ISSTActivityApi alloc]init];
    self.activitiesApi.webApiDelegate = self;
    
    activitiesTableView.rowHeight=70;
    UINib *nib=[UINib nibWithNibName:CellTableIdentifier bundle:nil];
    [activitiesTableView registerNib:nib forCellReuseIdentifier:CellTableIdentifier];
    
    self.activitiesTableView.tableFooterView =[[UIView alloc]initWithFrame:CGRectZero]; //UITableView去除多余的横线
    
    [self setupRefresh];
    
    //scrollview需要的代码
    NSMutableArray *viewsArray = [@[] mutableCopy];
    
    for (int i = 0; i < 5; ++i) {
        UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 214)];
        if(i==0){
            tempLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"活动.png"]];}
        if(i==1){
            tempLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"就业.png"]];}
        if(i==2){
            tempLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"就业1.png"]];}
        if(i==3){
            tempLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"就业3.png"]];}
        if(i==4){
            tempLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"就业4.png"]];}
        
        [viewsArray addObject:tempLabel];
    }
    
    self.mainScorllView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 214) animationDuration:2];
    //self.mainScorllView.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.1];
    
    self.mainScorllView.fetchContentViewAtIndex = ^UIScrollView *(NSInteger pageIndex){
        return viewsArray[pageIndex];
    };
    
    self.mainScorllView.totalPagesCount = ^NSInteger(void){
        return 5;
    };
    self.mainScorllView.TapActionBlock = ^(NSInteger pageIndex){
        NSLog(@"点击了第%d个",pageIndex);
    };
    [self.view addSubview:self.mainScorllView];
    

    
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
    [self.activitiesTableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    
    [self.activitiesTableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.activitiesTableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    // 1.添加数据
    [self.activitiesApi requestActivitiesLists:loadPage andPageSize:20 andKeywords:@"string"];
    
    // 刷新表格
    [self.activitiesTableView reloadData];
    
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [self.activitiesTableView headerEndRefreshing];
}


- (void)footerRereshing
{
    loadPage++;
    // 1.添加数据
    [self.activitiesApi requestActivitiesLists:loadPage andPageSize:20 andKeywords:@"string"];
    
    //[self.internshipTableView reloadData];}
    
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [self.activitiesTableView footerEndRefreshing];
}


-(void)dealloc
{
    activitiesTableView.dataSource = nil;
    activitiesTableView.delegate = nil;
    activitiesTableView = nil;
    self.activitiesApi.webApiDelegate = nil;
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
    NSArray *listData = activitiesArray;
    int count = [listData count];
    return count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    activityModel =[[ISSTActivityModel alloc]init];
    activityModel = [activitiesArray objectAtIndex:indexPath.row];
    
    ISSTActivityTableViewCell *cell = (ISSTActivityTableViewCell *)[tableView  dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if (cell == nil) {
         cell = [[ISSTActivityTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellTableIdentifier];
    }
    
    cell.titleLabel.text=activityModel.title;
    cell.descriptionLabel.text = activityModel.description;
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    self.activityDetailViewController=[[ISSTActivityDetailViewController alloc]initWithNibName:@"ISSTActivityDetailViewController" bundle:nil];
    self.activityDetailViewController.navigationItem.title=@"详细信息";
    ISSTActivityModel *tmpModel = activitiesArray[indexPath.row];
    self.activityDetailViewController.activityId = tmpModel.activityId;
    [self.navigationController pushViewController:self.activityDetailViewController   animated: YES];
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
    
    [activitiesTableView reloadData];
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
        
        [activitiesArray removeAllObjects];
        loadPage=1;
         // 1.添加数据
         [self.activitiesApi requestActivitiesLists:loadPage andPageSize:20 andKeywords:@"string"];
         
         // 刷新表格
         [self.activitiesTableView reloadData];
    }
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
