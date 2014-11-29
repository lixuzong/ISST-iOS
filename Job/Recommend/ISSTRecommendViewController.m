//
//  ISSTEmploymentViewController.m
//  ISST
//
//  Created by liuyang on 14-4-15.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTRecommendViewController.h"
#import "ISSTCommonCell.h"
#import "ISSTPushedViewController.h"
#import "ISSTJobsApi.h"
#import "ISSTJobsModel.h"
#import "ISSTRecommendDetailViewController.h"
#import "MJRefresh.h"
@interface ISSTRecommendViewController ()
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
    self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	self.view.backgroundColor = [UIColor lightGrayColor];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [super viewDidLoad];
    self.recommendApi = [[ISSTJobsApi alloc]init];
    
    self.recommendApi.webApiDelegate=self;
    // self.newsArray =[[NSMutableArray alloc]init];
    UITableView *tableView=(id)[self.view viewWithTag:97];
    recommendTableView.rowHeight=90;
    UINib *nib=[UINib nibWithNibName:@"ISSTCommonCell" bundle:nil];
    [recommendTableView registerNib:nib forCellReuseIdentifier:CellTableIdentifier];
    
    
	self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    //[self.recommendApi requestRecommendLists:1 andPageSize:20 andKeywords:@"string"];
    
    if (_refreshHeaderView == nil ) {
        Class refreshHeaderViewClazz = NSClassFromString(@"EGORefreshTableHeaderView");
        _refreshHeaderView = [[refreshHeaderViewClazz alloc]initWithFrame:CGRectMake(0, -tableView.bounds.size.height, tableView.frame.size.width, tableView.bounds.size.height)];
        
    }
    _refreshHeaderView.delegate= self;
    [tableView addSubview:_refreshHeaderView];
    
    self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    [self    triggerRefresh];
   
}

-(BOOL)isList
{
    return YES;
}

-(void)triggerRefresh
{
    if (_refreshLoading) {
        return;
    }
    
    CGPoint contentOffset = CGPointMake(0, -55-10-_refreshHeaderView.scrollViewInset.top);
    recommendTableView.contentOffset = contentOffset;
    NSLog(@"&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&=%f",recommendTableView.contentOffset.y);
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:recommendTableView];
    //[self requestRefresh];
    
    //设置分割线
    recommendTableView.separatorColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    if([recommendTableView respondsToSelector:@selector(separatorInset)])
    {
        recommendTableView.separatorInset = UIEdgeInsetsZero;
    }
    recommendTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}


-(void)requestRefresh
{
    if (NO)  //self.newsApi.isLoadingData;
    {
        
    }
    else
    {
        _refreshLoading = YES;
        loadPage =1;
        [self.recommendApi requestRecommendLists:loadPage andPageSize:20 andKeywords:@"string"];
    }
    
    
}

-(void)requestGetMore
{
    if (NO)
    {
        
    }
    else  if (!_refreshLoading)
    {
        ++loadPage;
        _refreshLoading = YES;
        NSLog(@"requestGetMore ===================================loadPage=%d  " ,loadPage);
        [self.recommendApi requestRecommendLists:loadPage andPageSize:20 andKeywords:@"string"];
        [_getMoreCell setInfoText:@"正在加载更多..." forState:MoreCellState_Loading];
    }
}

-(BOOL)canGetMoreData
{
    return YES;
}

-(void)dealloc
{
    recommendTableView.dataSource = nil;
    recommendTableView.delegate = nil;
    recommendTableView = nil;
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
    if (count == 0)
    {
        if (_refreshLoading)
        {
            
        }
        else if (!_refreshLoading)
        {
            count ++;
        }
    }
    else if([self canGetMoreData])
    {
        count ++;
    }
    NSLog(@"===========================================%d",count);
    return count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int count = [recommendArray count];
    NSLog(@"================%d",indexPath.row);
    if (count ==0)
    {
        if (!_refreshLoading)
        {
            _emptyCell.state = EmptyCellState_Tips;
            
        }
        return _emptyCell;
    }
    else if ([self canGetMoreData]&&indexPath.row == [recommendArray count])
    {
        [_getMoreCell setInfoText:@"查看更多" forState:MoreCellState_Information];
        return _getMoreCell;
    }
    
    recommendModel =[[ISSTJobsModel alloc]init];
    recommendModel = [recommendArray objectAtIndex:indexPath.row];
    
    ISSTCommonCell *cell=(ISSTCommonCell *)[tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if (cell == nil) {
        cell = (ISSTCommonCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellTableIdentifier];
    }
    
    cell.title.text=recommendModel.title;
    cell.time.text=recommendModel.updatedAt;
    cell.content.text=recommendModel.description;
    return cell;
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell ==_getMoreCell) {
        [self requestGetMore];
        return;
    }
    else if  (cell == _emptyCell)
    {
        [self triggerRefresh];
        return;
    }
    self.detailView=[[ISSTRecommendDetailViewController alloc]initWithNibName:@"ISSTRecommendDetailViewController" bundle:nil];
    self.detailView.navigationItem.title =@"详细信息";
   
   ISSTJobsModel *  tempNewsModel= [recommendArray objectAtIndex:indexPath.row];
   self.detailView.jobId=tempNewsModel.messageId;

    [self.navigationController pushViewController:self.detailView animated: YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *listDatas = recommendArray;
    int count = [listDatas count];
    
    if (count==0)
    {
        if (_refreshLoading)
        {
        }
        else if (!_refreshLoading)
        {
            int height = tableView.bounds.size.height;
            height -= tableView.tableHeaderView.bounds.size.height;
            height -= [self.topLayoutGuide length];
            return height;
        }
    }
    if ([self canGetMoreData]&&indexPath.row ==[recommendArray count]) {
        return 45;
    }
    return 100;
    
}

#pragma mark -
#pragma mark  ISSTWebApiDelegate Methods
- (void)requestDataOnSuccess:(id)backToControllerData
{
    _refreshHeaderView.lastRefreshDate = [NSDate date];
    
    if (loadPage == 1) {
        recommendArray = [[NSMutableArray alloc]initWithArray:backToControllerData];
        _refreshLoading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:recommendTableView];
    }
    else
    {
        _refreshLoading = NO;
        [recommendArray addObjectsFromArray:backToControllerData];
        [_getMoreCell setInfoText:@"查看更多" forState:MoreCellState_Information];
    }
    
    [recommendTableView reloadData];
}

- (void)requestDataOnFail:(NSString *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您好:" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



@end
