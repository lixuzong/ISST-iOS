//
//  ISSTCommentsMoreViewController.m
//  ISST
//
//  Created by XSZHAO on 14-4-19.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTCommentsMoreViewController.h"
#import "ISSTCLTableViewCell.h"
#import "ISSTUserModel.h"
#import "ISSTCommentsModel.h"
#import "ISSTJobsApi.h"
#import "ISSTPostCommentsViewController.h"
#import "MJRefresh.h"

@interface ISSTCommentsMoreViewController ()
@property (weak, nonatomic) IBOutlet UITableView *commentsMoreTableView;
@property (nonatomic,strong)NSMutableArray *commentsArray;
@property (nonatomic,strong)ISSTJobsApi  *recommendApi;
@property (nonatomic,strong)ISSTCommentsModel *commentsModel;

@end

@implementation ISSTCommentsMoreViewController
@synthesize jobId;
static NSString *CellTableIdentifier=@"ISSTCLTableViewCell";
@synthesize recommendApi;
@synthesize commentsMoreTableView;
@synthesize commentsArray;
@synthesize commentsModel;

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
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                  target:self
                                                  action:@selector(postComments)];
    recommendApi = [[ISSTJobsApi alloc]init];
    recommendApi.webApiDelegate = self;
    UINib *nib=[UINib nibWithNibName:CellTableIdentifier bundle:nil];
    [commentsMoreTableView registerNib:nib forCellReuseIdentifier:CellTableIdentifier];
    
    commentsMoreTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero]; //去除多余横线
    [self setupRefresh];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [self setupRefresh];
}

- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    // dateKey用于存储刷新时间，可以保证不同界面拥有不同的刷新时间
    [commentsMoreTableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    
    [commentsMoreTableView headerBeginRefreshing];
    
    //2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [commentsMoreTableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    // 1.添加数据
    [recommendApi requestRCLists:loadPage andPageSize:20 andJobId:self.jobId];
    
    // 刷新表格
    [commentsMoreTableView reloadData];
    
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [commentsMoreTableView headerEndRefreshing];
}


- (void)footerRereshing
{
    loadPage++;
    // 1.添加数据
    [recommendApi requestRCLists:loadPage andPageSize:20 andJobId:self.jobId];
    
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [commentsMoreTableView footerEndRefreshing];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) postComments
{
    ISSTPostCommentsViewController *postCommentsVC = [[ISSTPostCommentsViewController alloc]initWithNibName:@"ISSTPostCommentsViewController" bundle:nil];
    postCommentsVC.navigationItem.title = @"发表评论";
    postCommentsVC.jobId= self.jobId;
    [self.navigationController pushViewController:postCommentsVC animated:YES];
}


#pragma mark -
#pragma mark - UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [commentsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ISSTCLTableViewCell *cell=(ISSTCLTableViewCell  *)[tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if (cell == nil) {
        cell = (ISSTCLTableViewCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellTableIdentifier];
    }
    if (commentsArray) {
        ISSTCommentsModel*   cModel =  [commentsArray objectAtIndex:indexPath.row];
        cell.nameLabel.text = cModel.userModel.name;
        cell.contentLabel.text=cModel.content;
        cell.timeLabel.text = cModel.createdAt;
    }
    
    return cell;
}

#pragma mark -
#pragma mark - UITableViewDelegate Method
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

#pragma mark -
#pragma mark  ISSTWebApiDelegate Methods
- (void)requestDataOnSuccess:(id)backToControllerData
{

    if (loadPage == 1) {
        commentsArray = [[NSMutableArray alloc]initWithArray:backToControllerData];
    }
    else
    {
        [commentsArray addObjectsFromArray:backToControllerData];
    }
    
    [commentsMoreTableView reloadData];
    
}

- (void)requestDataOnFail:(NSString *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您好:" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

-(void)dealloc{
    loadPage =1;
}

@end
