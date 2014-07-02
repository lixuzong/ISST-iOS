//
//  ISSTStudyViewController.m
//  ISST
//
//  Created by XSZHAO on 14-4-2.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTStudyViewController.h"
#import "ISSTLifeApi.h"
#import "ISSTNewsDetailsModel.h"
#import "ISSTLoginViewController.h"
#import "ISSTCampusNewsModel.h"
#import "ISSTStudyDetailViewController.h"
#import "ISSTStudyTableViewCell.h"

@interface ISSTStudyViewController ()
@property (weak, nonatomic) IBOutlet UITableView *studyArrayTableView;
@property (nonatomic,strong)ISSTLifeApi  *studyApi;

@property (nonatomic,strong)ISSTCampusNewsModel  *studyModel;

@property(nonatomic,strong)ISSTStudyDetailViewController *studyDetailView;

@property (strong, nonatomic) NSMutableArray *studyArray;
@end

@implementation ISSTStudyViewController


@synthesize studyModel;
@synthesize studyApi;
@synthesize studyArray;
@synthesize studyArrayTableView;
@synthesize studyDetailView;
static NSString *CellTableIdentifier=@"ISSTStudyTableViewCell";
//页面标记
static int  loadPage = 0;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.rightBarButtonItem.image=[UIImage imageNamed:@"user.png"];
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
    self.studyApi = [[ISSTLifeApi alloc]init];
    
    self.studyApi.webApiDelegate = self;
    // self.newsArray =[[NSMutableArray alloc]init];
    UITableView *tableView=(id)[self.view viewWithTag:3];
    tableView.rowHeight=90;
    UINib *nib=[UINib nibWithNibName:@"ISSTStudyTableViewCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:CellTableIdentifier];
    
    
	self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    if (_refreshHeaderView == nil ) {
        Class refreshHeaderViewClazz = NSClassFromString(@"EGORefreshTableHeaderView");
        _refreshHeaderView = [[refreshHeaderViewClazz alloc]initWithFrame:CGRectMake(0, -tableView.bounds.size.height, tableView.frame.size.width, tableView.bounds.size.height)];
        
    }
    _refreshHeaderView.delegate= self;
    [tableView addSubview:_refreshHeaderView];
    
	self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    [self    triggerRefresh];

    
    
 //   [self.studyApi requestStudyingLists:1 andPageSize:20 andKeywords:@"string"];
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
    studyArrayTableView.contentOffset = contentOffset;
    NSLog(@"&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&=%f",studyArrayTableView.contentOffset.y);
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:studyArrayTableView];
    //[self requestRefresh];
    
    //设置分割线
    studyArrayTableView.separatorColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    if([studyArrayTableView respondsToSelector:@selector(separatorInset)])
    {
        studyArrayTableView.separatorInset = UIEdgeInsetsZero;
    }
    studyArrayTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}


-(void)requestRefresh
{
    if (NO)  //self.newsApi.isLoadingData;
    {
        
    }
    else
    {
        _refreshLoading = YES;
        loadPage =0;
  [self.studyApi requestStudyingLists:loadPage andPageSize:20 andKeywords:@"string"];
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
        [self.studyApi requestStudyingLists:loadPage andPageSize:20 andKeywords:@"string"];
        [_getMoreCell setInfoText:@"正在加载更多..." forState:MoreCellState_Loading];
    }
}

-(BOOL)canGetMoreData
{
    return YES;
}

-(void)dealloc
{
    studyArrayTableView.dataSource = nil;
    studyArrayTableView.delegate = nil;
    studyArrayTableView = nil;
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
    NSArray *listData = studyArray;
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
    int count = [studyArray count];
    NSLog(@"================%d",indexPath.row);
    if (count ==0)
    {
        if (!_refreshLoading)
        {
            _emptyCell.state = EmptyCellState_Tips;
            
        }
        return _emptyCell;
    }
    else if ([self canGetMoreData]&&indexPath.row == [studyArray count])
    {
        [_getMoreCell setInfoText:@"查看更多" forState:MoreCellState_Information];
        return _getMoreCell;
    }
    

    studyModel =[[ISSTCampusNewsModel alloc]init];
    studyModel = [studyArray objectAtIndex:indexPath.row];
    
    ISSTStudyTableViewCell *cell=(ISSTStudyTableViewCell *)[tableView  dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellTableIdentifier];
    }
    
    cell.title.text=[NSString stringWithFormat:@"%@",studyModel.title];
    cell.time.text=studyModel.updatedAt;
    cell.content.text= [NSString stringWithFormat:@"%@",studyModel.description];
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
    
    self.studyDetailView=[[ISSTStudyDetailViewController alloc]initWithNibName:@"ISSTNewsDetailViewController" bundle:nil];
    self.studyDetailView.navigationItem.title=@"详细信息";
   // ISSTCampusNewsModel *tempstudyModel=[[ISSTCampusNewsModel alloc]init];
  ISSTCampusNewsModel*  tempstudyModel= [studyArray objectAtIndex:indexPath.row];
    self.studyDetailView.studyId=tempstudyModel.newsId;
    // [self.navigationController setNavigationBarHidden:YES];    //set system navigationbar hidden
    [self.navigationController pushViewController:self.studyDetailView animated: NO];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *listDatas = studyArray;
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
    if ([self canGetMoreData]&&indexPath.row ==[studyArray count]) {
        return 45;
    }
    return 100;
    
}

#pragma mark -
#pragma mark  ISSTWebApiDelegate Methods
- (void)requestDataOnSuccess:(id)backToControllerData
{
    
    _refreshHeaderView.lastRefreshDate = [NSDate date];
    
    if (loadPage == 0) {
        studyArray = [[NSMutableArray alloc]initWithArray:backToControllerData];
        _refreshLoading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:studyArrayTableView];
    }
    else
    {
        _refreshLoading = NO;
        [studyArray addObjectsFromArray:backToControllerData];
        [_getMoreCell setInfoText:@"查看更多" forState:MoreCellState_Information];
    }
    
    [studyArrayTableView reloadData];

    
//    if ([studyArray count]) {
//        studyArray = [[NSMutableArray alloc]init];
//    }
//    studyArray = (NSMutableArray *)backToControllerData;
//    NSLog(@"count =%d ,studyArray = %@",[studyArray count],studyArray);
//    [studyArrayTableView reloadData];
}

- (void)requestDataOnFail:(NSString *)error
{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您好:" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//    [alert show];
//    

    _refreshHeaderView.lastRefreshDate = [NSDate date];
    
    if (loadPage == 0) {
        _refreshLoading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:studyArrayTableView];
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
//    NSString *vcTitle = [self.title stringByAppendingString:@" - Pushed"];
//    UIViewController *vc = [[ISSTPushedViewController alloc] initWithTitle:vcTitle];
//    
//    [self.navigationController pushViewController:vc animated:YES];
//}


@end
