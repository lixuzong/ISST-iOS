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
@interface ISSTActivitiesViewController ()

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
    self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
      [super viewDidLoad];
    
    self.activitiesApi = [[ISSTActivityApi alloc]init];
    self.activitiesApi.webApiDelegate = self;
    //[activitiesApi requestActivitiesLists:1 andPageSize:20 andKeywords:@"string"];
   // activitiesTableView = [[UITableView alloc]init];
    activitiesTableView.rowHeight=75;
    UINib *nib=[UINib nibWithNibName:CellTableIdentifier bundle:nil];
    [activitiesTableView registerNib:nib forCellReuseIdentifier:CellTableIdentifier];
    
    
    UITableView *tableView=(id)[self.view viewWithTag:111];
    self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    //[self.internshipApi requestInternshipLists:0 andPageSize:20 andKeywords:@"string"];
    
    
    if (_refreshHeaderView == nil ) {
        Class refreshHeaderViewClazz = NSClassFromString(@"EGORefreshTableHeaderView");
        _refreshHeaderView = [[refreshHeaderViewClazz alloc]initWithFrame:CGRectMake(0, -tableView.bounds.size.height, tableView.frame.size.width, tableView.bounds.size.height)];
        
    }
    _refreshHeaderView.delegate= self;
    [tableView addSubview:_refreshHeaderView];
    
    self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    [self    triggerRefresh];
    
    
    
    //scrollview需要的代码
    NSMutableArray *viewsArray = [@[] mutableCopy];
    //NSArray *sourceArray = [[NSArray alloc]initWithObjects:@"活动.png",@"就业.png",@"就业1.png", @"就业2.png",@"就业3.png",@"就业4.png",nil];
    
    for (int i = 0; i < 5; ++i) {
        UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 214)];
        //tempLabel.backgroundColor= [(UIColor *)[colorArray objectAtIndex:i] colorWithAlphaComponent:0.5];
        // tempLabel.backgroundColor= [(UIColor *)[sourceArray objectAtIndex:i] colorWithAlphaComponent:0.5];
        //tempLabel.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageWithData:sourceArray]];
        // tempLabel.backgroundColor=[(UIColor *)[sourceArray objectAtIndex:i ]];
        //tempLabel.backgroundColor = [UIColor colorWithPatternImage:[sourceArray objectAtIndex:i]];
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
    activitiesTableView.contentOffset = contentOffset;
    NSLog(@"&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&=%f",activitiesTableView.contentOffset.y);
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:activitiesTableView];
    //[self requestRefresh];
    
    //设置分割线
    activitiesTableView.separatorColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    if([activitiesTableView respondsToSelector:@selector(separatorInset)])
    {
        activitiesTableView.separatorInset = UIEdgeInsetsZero;
    }
    activitiesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
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
        [self.activitiesApi requestActivitiesLists:loadPage andPageSize:20 andKeywords:@"string"];
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
        [self.activitiesApi requestActivitiesLists:loadPage andPageSize:20 andKeywords:@"string"];
        [_getMoreCell setInfoText:@"正在加载更多..." forState:MoreCellState_Loading];
    }
}

-(BOOL)canGetMoreData
{
    return YES;
}

-(void)dealloc
{
    activitiesTableView.dataSource = nil;
    activitiesTableView.delegate = nil;
    activitiesTableView = nil;
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
    int count = [activitiesArray count];
    //NSLog(@"================%d",indexPath.row);
    if (count ==0)
    {
        if (!_refreshLoading)
        {
            _emptyCell.state = EmptyCellState_Tips;
            
        }
        return _emptyCell;
    }
    else if ([self canGetMoreData]&&indexPath.row == [activitiesArray count])
    {
        [_getMoreCell setInfoText:@"查看更多" forState:MoreCellState_Information];
        //[_getMoreCell setInfoText:@"已全部加载" forState:MoreCellState_Information];
        return _getMoreCell;
    }
    
    activityModel =[[ISSTActivityModel alloc]init];
    activityModel = [activitiesArray objectAtIndex:indexPath.row];
    
    ISSTActivityTableViewCell *cell = (ISSTActivityTableViewCell *)[tableView  dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if (cell == nil) {
        cell =(ISSTActivityTableViewCell *) [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellTableIdentifier];
    }
    
    cell.titleLabel.text=activityModel.title;
    cell.descriptionLabel.text = activityModel.description;
    
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
    
    self.activityDetailViewController=[[ISSTActivityDetailViewController alloc]initWithNibName:@"ISSTActivityDetailViewController" bundle:nil];
    self.activityDetailViewController.navigationItem.title=@"详细信息";
    ISSTActivityModel *tmpModel = activitiesArray[indexPath.row];
    self.activityDetailViewController.activityId = tmpModel.activityId;
    [self.navigationController pushViewController:self.activityDetailViewController   animated: YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *listDatas = activitiesArray;
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
    if ([self canGetMoreData]&&indexPath.row ==[activitiesArray count]) {
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
        activitiesArray = [[NSMutableArray alloc]initWithArray:backToControllerData];
        _refreshLoading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:activitiesTableView];
    }
    else
    {
        _refreshLoading = NO;
        [activitiesArray addObjectsFromArray:backToControllerData];
        [_getMoreCell setInfoText:@"查看更多" forState:MoreCellState_Information];
    }
    
    [activitiesTableView reloadData];
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
