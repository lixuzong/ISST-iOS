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
#import "RESideMenu.h"
#import "MJRefresh.h"

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
static int  loadPage = 1;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        self.navigationItem.rightBarButtonItem.image=[UIImage imageNamed:@"user.png"];
//    }
//    return self;
//}


- (void)viewDidLoad
{
    self.title = @"学习园地";
    
    self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [super viewDidLoad];
    self.studyApi = [[ISSTLifeApi alloc]init];
    
    self.studyApi.webApiDelegate = self;
    UITableView *tableView=(id)[self.view viewWithTag:3];
    tableView.rowHeight=126;
    UINib *nib=[UINib nibWithNibName:@"ISSTStudyTableViewCell" bundle:nil];
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
    [self.studyArrayTableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    
    [self.studyArrayTableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.studyArrayTableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    // 1.添加数据
    [self.studyApi requestStudyingLists:loadPage andPageSize:20 andKeywords:@"string"];
    
    // 刷新表格
    [self.studyArrayTableView reloadData];
    
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [self.studyArrayTableView headerEndRefreshing];
}


- (void)footerRereshing
{
    loadPage++;
    // 1.添加数据
    [self.studyApi requestStudyingLists:loadPage andPageSize:20 andKeywords:@"string"];
    
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [self.studyArrayTableView footerEndRefreshing];
}


-(void)dealloc
{
    studyArrayTableView.dataSource = nil;
    studyArrayTableView.delegate = nil;
    studyArrayTableView = nil;
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
    NSArray *listData = studyArray;
    int count = [listData count];
    return count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    studyModel =[[ISSTCampusNewsModel alloc]init];
    studyModel = [studyArray objectAtIndex:indexPath.row];
    
    ISSTStudyTableViewCell *cell=(ISSTStudyTableViewCell *)[tableView  dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if (cell == nil) {
        cell = [[ISSTStudyTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellTableIdentifier];
    }
    
    cell.title.text=[NSString stringWithFormat:@"%@",studyModel.title];
    cell.time.text=studyModel.updatedAt;
    cell.content.text= [NSString stringWithFormat:@"%@",studyModel.description];
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    self.studyDetailView=[[ISSTStudyDetailViewController alloc]initWithNibName:@"ISSTNewsDetailViewController" bundle:nil];
    self.studyDetailView.navigationItem.title=@"详细信息";
   // ISSTCampusNewsModel *tempstudyModel=[[ISSTCampusNewsModel alloc]init];
  ISSTCampusNewsModel*  tempstudyModel= [studyArray objectAtIndex:indexPath.row];
    self.studyDetailView.studyId=tempstudyModel.newsId;
    // [self.navigationController setNavigationBarHidden:YES];    //set system navigationbar hidden
    [self.navigationController pushViewController:self.studyDetailView animated: NO];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark  ISSTWebApiDelegate Methods
- (void)requestDataOnSuccess:(id)backToControllerData
{
    
    if (loadPage == 1) {
        studyArray = [[NSMutableArray alloc]initWithArray:backToControllerData];
    }
    else
    {
        [studyArray addObjectsFromArray:backToControllerData];
    }
    
    [studyArrayTableView reloadData];

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




//#pragma mark Private Methods
//- (void)pushViewController {
//    NSString *vcTitle = [self.title stringByAppendingString:@" - Pushed"];
//    UIViewController *vc = [[ISSTPushedViewController alloc] initWithTitle:vcTitle];
//    
//    [self.navigationController pushViewController:vc animated:YES];
//}


@end
