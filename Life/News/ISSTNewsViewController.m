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

@interface ISSTNewsViewController ()
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
static int  loadPage = 0;


-(BOOL)isList
{
    return YES;
}

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
    self.newsApi = [[ISSTLifeApi alloc]init];
    self.newsApi.webApiDelegate = self;
     self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	self.view.backgroundColor = [UIColor lightGrayColor];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [super viewDidLoad];
    
   
    
    UITableView *tableView=(id)[self.view viewWithTag:1];
    tableView.rowHeight=80;
    UINib *nib=[UINib nibWithNibName:@"ISSTCommonCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:CellTableIdentifier];
    
    
    
    if (_refreshHeaderView == nil ) {
        Class refreshHeaderViewClazz = NSClassFromString(@"EGORefreshTableHeaderView");
        _refreshHeaderView = [[refreshHeaderViewClazz alloc]initWithFrame:CGRectMake(0, -tableView.bounds.size.height, tableView.frame.size.width, tableView.bounds.size.height)];
        
    }
    _refreshHeaderView.delegate= self;
    [tableView addSubview:_refreshHeaderView];
    
	self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
  
    [self    triggerRefresh];
}

-(void)triggerRefresh
{
    if (_refreshLoading) {
        return;
    }
    
    CGPoint contentOffset = CGPointMake(0, -55-10-_refreshHeaderView.scrollViewInset.top);
    newsArrayTableView.contentOffset = contentOffset;
    NSLog(@"&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&=%f",newsArrayTableView.contentOffset.y);
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:newsArrayTableView];
    //[self requestRefresh];
    
    //设置分割线
    newsArrayTableView.separatorColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    if([newsArrayTableView respondsToSelector:@selector(separatorInset)])
    {
        newsArrayTableView.separatorInset = UIEdgeInsetsZero;
    }
    newsArrayTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}


-(void)requestRefresh
{
    if (NO)  //self.newsApi.isLoadingData;
    {
        
    }
    else
    {
        NSLog(@"111111111111111111111111111111111111111111111111111111111");
        _refreshLoading = YES;
        loadPage =0;
        [self.newsApi requestCampusNewsLists:loadPage andPageSize:20 andKeywords:@"string"];
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
        [self.newsApi requestCampusNewsLists:loadPage andPageSize:20 andKeywords:@"string"];

        [_getMoreCell setInfoText:@"正在加载更多..." forState:MoreCellState_Loading];
    }
}

-(BOOL)canGetMoreData
{
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)dealloc
{
    newsArrayTableView.dataSource = nil;
    newsArrayTableView.delegate = nil;
    newsArrayTableView = nil;
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
    int count = [newsArray count];
    NSLog(@"================%d",indexPath.row);
    if (count ==0)
    {
        if (!_refreshLoading)
        {
            _emptyCell.state = EmptyCellState_Tips;
            
        }
        return _emptyCell;
    }
    else if ([self canGetMoreData]&&indexPath.row == [newsArray count])
    {
        [_getMoreCell setInfoText:@"查看更多" forState:MoreCellState_Information];
        return _getMoreCell;
    }
    
    
    newsModel =[[ISSTCampusNewsModel alloc]init];
    newsModel = [newsArray objectAtIndex:indexPath.row];
    
    ISSTCommonCell *cell=(ISSTCommonCell *)[tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if (cell == nil) {
        cell = (ISSTCommonCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellTableIdentifier];
    }

    cell.title.text     =   newsModel.title;
    cell.time.text      =   newsModel.updatedAt;
    cell.content.text   =   newsModel.description;
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
    self.newsDetailView=[[ISSTNewsDetailViewController alloc]initWithNibName:@"ISSTNewsDetailViewController" bundle:nil];
    self.newsDetailView.navigationItem.title =@"详细信息";
  //  ISSTCampusNewsModel *tempNewsModel=[[ISSTCampusNewsModel alloc]init];
     ISSTCampusNewsModel * tempNewsModel= [newsArray objectAtIndex:indexPath.row];
    self.newsDetailView.newsId=tempNewsModel.newsId;
   // [self.navigationController setNavigationBarHidden:YES];    //set system navigationbar hidden
    [self.navigationController pushViewController:self.newsDetailView animated: NO];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *listDatas = newsArray;
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
    if ([self canGetMoreData]&&indexPath.row ==[newsArray count]) {
        return 45;
    }
    return 77;
    
}


#pragma mark -
#pragma mark  ISSTWebApiDelegate Methods
- (void)requestDataOnSuccess:(id)backToControllerData
{
    _refreshHeaderView.lastRefreshDate = [NSDate date];
    
    if (loadPage == 0) {
        newsArray = [[NSMutableArray alloc]initWithArray:backToControllerData];
        _refreshLoading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:newsArrayTableView];
    }
    else
    {
        _refreshLoading = NO;
        [newsArray addObjectsFromArray:backToControllerData];
        [_getMoreCell setInfoText:@"查看更多" forState:MoreCellState_Information];
    }
    
    [newsArrayTableView reloadData];
    
    
    
//    if ([newsArray count]) {
//        newsArray = [[NSMutableArray alloc]init];
//    }
//    newsArray = (NSMutableArray *)backToControllerData;
//    NSLog(@"count =%d ,newsArray = %@",[newsArray count],newsArray);
//     [newsArrayTableView reloadData];
}

- (void)requestDataOnFail:(NSString *)error
{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您好:" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//    [alert show];
    
    
    _refreshHeaderView.lastRefreshDate = [NSDate date];
    
    if (loadPage == 0) {
        _refreshLoading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:newsArrayTableView];
    }
    else
    {
        [_getMoreCell setInfoText:@"加载更多失败，点击查看更多" forState:MoreCellState_Information];
    }
    
    UIAlertView  *alertView = [[UIAlertView alloc]initWithTitle:@"错误" message:@"查看网络连接" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
    [alertView show];
    
    
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
