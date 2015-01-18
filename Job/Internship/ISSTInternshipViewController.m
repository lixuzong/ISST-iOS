//
//  ISSTInternshipViewController.m
//  ISST
//
//  Created by rth on 14-12-4.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//  

#import "ISSTInternshipViewController.h"
#import "ISSTCommonCell.h"
#import "ISSTPushedViewController.h"
#import "ISSTJobsApi.h"
#import "ISSTJobsModel.h"
#import "ISSTInternshipDetailViewController.h"
#import "RESideMenu.h"
#import "MJRefresh.h"
#import "ISSTLoginApi.h"
#import "ISSTUserModel.h"
#import "AppCache.h"


@interface ISSTInternshipViewController ()
@property (strong,nonatomic) ISSTUserModel *userModel;
@property (strong,nonatomic) ISSTLoginApi *userApi;

@property (weak, nonatomic) IBOutlet UITableView *internshipTableView;
@property (nonatomic,strong)ISSTJobsApi  *internshipApi;
@property (nonatomic,strong)ISSTJobsModel  *internshipModel;
@property (strong, nonatomic)NSMutableArray *internshipArray;
@property (nonatomic,strong) ISSTInternshipDetailViewController *detailView;
@end

@implementation ISSTInternshipViewController
@synthesize internshipTableView;
@synthesize internshipApi;
@synthesize internshipModel;
@synthesize internshipArray;
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
    self.title = @"实习";
    
    self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    self.internshipTableView.tableFooterView =[[UIView alloc]initWithFrame:CGRectZero]; //UITableView去除多余的横线
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [super viewDidLoad];
    self.internshipApi = [[ISSTJobsApi alloc]init];
    
    self.internshipApi.webApiDelegate=self;
    //UITableView *tableView=(id)[self.view viewWithTag:98];
    
    internshipTableView.rowHeight=75;
    UINib *nib=[UINib nibWithNibName:@"ISSTCommonCell" bundle:nil];
    [internshipTableView registerNib:nib forCellReuseIdentifier:CellTableIdentifier];
    
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
    [self.internshipTableView addHeaderWithTarget:self action:@selector(headerRereshing)];

    [self.internshipTableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.internshipTableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    // 1.添加数据
    [self.internshipApi requestInternshipLists:loadPage andPageSize:20 andKeywords:@"string"];
    
    // 刷新表格
    [self.internshipTableView reloadData];
    
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [self.internshipTableView headerEndRefreshing];
}


- (void)footerRereshing
{
    loadPage++;
    // 1.添加数据
    [self.internshipApi requestInternshipLists:loadPage andPageSize:20 andKeywords:@"string"];
    
    //[self.internshipTableView reloadData];}
    
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [self.internshipTableView footerEndRefreshing];
}



-(void)dealloc
{
    internshipTableView.dataSource = nil;
    internshipTableView.delegate = nil;
    internshipTableView = nil;
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
    return internshipArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{


    internshipModel =[[ISSTJobsModel alloc]init];

    internshipModel = [internshipArray objectAtIndex:indexPath.row];
    
    ISSTCommonCell *cell=(ISSTCommonCell *)[tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if (cell == nil) {
        cell = (ISSTCommonCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellTableIdentifier];
    }
    
    cell.title.text=internshipModel.title;
    cell.time.text=internshipModel.updatedAt;
    cell.content.text=internshipModel.description;
    cell.authorLabel.text=internshipModel.author;
//    cell.imageView.image =[UIImage imageNamed:@"book1208.jpg"];
    return cell;
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.detailView=[[ISSTInternshipDetailViewController alloc]initWithNibName:@"ISSTInternshipDetailViewController" bundle:nil];
    self.detailView.navigationItem.title =@"实习详细信息";
    ISSTJobsModel *  tempModel= [internshipArray objectAtIndex:indexPath.row];
    self.detailView.internshipId=tempModel.messageId;

    [self.navigationController pushViewController:detailView animated: NO];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark -
#pragma mark  ISSTWebApiDelegate Methods
- (void)requestDataOnSuccess:(id)backToControllerData
{
    
    if (loadPage == 1) {
        internshipArray = [[NSMutableArray alloc]initWithArray:backToControllerData];
    }
    else
    {
        [internshipArray addObjectsFromArray:backToControllerData];
    }

    
        [internshipTableView reloadData];
    
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
        
        [internshipArray removeAllObjects];
        loadPage=1;
        // 1.添加数据
        [self.internshipApi requestInternshipLists:loadPage andPageSize:20 andKeywords:@"string"];
        
        // 刷新表格
        [self.internshipTableView reloadData];

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
