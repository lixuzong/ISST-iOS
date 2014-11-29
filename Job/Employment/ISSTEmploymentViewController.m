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
#import "MJRefresh.h"

@interface ISSTEmploymentViewController ()
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
    self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	self.view.backgroundColor = [UIColor lightGrayColor];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [super viewDidLoad];
    self.employmentApi = [[ISSTJobsApi alloc]init];
    
    self.employmentApi.webApiDelegate=self;
    // self.newsArray =[[NSMutableArray alloc]init];
    UITableView *tableView=(id)[self.view viewWithTag:99];
    employTableView.rowHeight=90;
    UINib *nib=[UINib nibWithNibName:@"ISSTCommonCell" bundle:nil];
    [employTableView registerNib:nib forCellReuseIdentifier:CellTableIdentifier];
    
    
	self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    //[self.employmentApi requestEmploymentLists:1 andPageSize:20 andKeywords:@"string"];
    
    if (_refreshHeaderView == nil ) {
        Class refreshHeaderViewClazz = NSClassFromString(@"EGORefreshTableHeaderView");
        _refreshHeaderView = [[refreshHeaderViewClazz alloc]initWithFrame:CGRectMake(0, -tableView.bounds.size.height, tableView.frame.size.width, tableView.bounds.size.height)];
        
    }
    _refreshHeaderView.delegate= self;
    [tableView addSubview:_refreshHeaderView];
    
    self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    [self    triggerRefresh];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    employTableView.contentOffset = contentOffset;
    NSLog(@"&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&=%f",employTableView.contentOffset.y);
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:employTableView];
    //[self requestRefresh];
    
    //设置分割线
    employTableView.separatorColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    if([employTableView respondsToSelector:@selector(separatorInset)])
    {
        employTableView.separatorInset = UIEdgeInsetsZero;
    }
    employTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
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
        [self.employmentApi requestEmploymentLists:loadPage andPageSize:20 andKeywords:@"string"];
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
        [self.employmentApi requestEmploymentLists:loadPage andPageSize:20 andKeywords:@"string"];
        [_getMoreCell setInfoText:@"正在加载更多..." forState:MoreCellState_Loading];
    }
}

-(BOOL)canGetMoreData
{
    return YES;
}

-(void)dealloc
{
    employTableView.dataSource = nil;
    employTableView.delegate = nil;
    employTableView = nil;
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
    int count = [employmentArray count];
    NSLog(@"================%d",indexPath.row);
    if (count ==0)
    {
        if (!_refreshLoading)
        {
            _emptyCell.state = EmptyCellState_Tips;
            
        }
        return _emptyCell;
    }
    else if ([self canGetMoreData]&&indexPath.row == [employmentArray count])
    {
        [_getMoreCell setInfoText:@"查看更多" forState:MoreCellState_Information];
        return _getMoreCell;
    }
    
    employmentModel =[[ISSTJobsModel alloc]init];
    employmentModel = [employmentArray objectAtIndex:indexPath.row];
    
    ISSTCommonCell *cell=(ISSTCommonCell *)[tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if (cell == nil) {
        cell = (ISSTCommonCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellTableIdentifier];
    }
    
    cell.title.text=employmentModel.title;
    cell.time.text=employmentModel.updatedAt;
    cell.content.text=employmentModel.description;
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
    
    self.detailView=[[ISSTEmploymentDetailViewController alloc]initWithNibName:@"ISSTEmploymentDetailViewController" bundle:nil];
    self.detailView.navigationItem.title =@"就业信息详情";
 //  ISSTJobsModel *tempEmploymentModel=[[ISSTJobsModel alloc]init];
   ISSTJobsModel *  tempEmploymentModel= [employmentArray objectAtIndex:indexPath.row];
    self.detailView.employmentId=tempEmploymentModel.messageId;
    // [self.navigationController setNavigationBarHidden:YES];    //set system navigationbar hidden
    [self.navigationController pushViewController:self.detailView animated: NO];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *listDatas = employmentArray;
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
    if ([self canGetMoreData]&&indexPath.row ==[employmentArray count]) {
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
        employmentArray = [[NSMutableArray alloc]initWithArray:backToControllerData];
        _refreshLoading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:employTableView];
    }
    else
    {
        _refreshLoading = NO;
        [employmentArray addObjectsFromArray:backToControllerData];
        [_getMoreCell setInfoText:@"查看更多" forState:MoreCellState_Information];
    }
    
    [employTableView reloadData];
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

#pragma mark Private Methods
- (void)pushViewController {
    NSString *vcTitle = [self.title stringByAppendingString:@" - Pushed"];
    UIViewController *vc = [[ISSTPushedViewController alloc] initWithTitle:vcTitle];
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
