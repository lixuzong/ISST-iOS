//
//  ISSTMyRecListViewController.m
//  ISST
//
//  Created by lixu on 14/12/23.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTMyRecListViewController.h"
#import "ISSTUserCenterApi.h"
#import "ISSTUserModel.h"
#import "ISSTLoginApi.h"
#import "ISSTWebApiDelegate.h"
#import "AppCache.h"
#import "MJRefresh.h"
#import "ISSTMyRecommendCell.h"
#import "ISSTMyRecommendViewController.h"
#import "ISSTRecommendModel.h"

@interface ISSTMyRecListViewController ()<ISSTWebApiDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property(strong,nonatomic) ISSTUserModel *userModel;
@property(strong,nonatomic) ISSTUserCenterApi *centerApi;
@property (strong,nonatomic) ISSTLoginApi *userApi;
@property (strong,nonatomic) ISSTMyRecommendViewController *postRecommendViewController;

@property (strong,nonatomic) NSMutableArray *recArray;

@end

@implementation ISSTMyRecListViewController
static int count=1;
@synthesize recArray;
static int  loadPage = 1;
static NSString* CellIdentifier=@"myRecommendCell";
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.centerApi requestRecommendListWithPage:loadPage pageSize:20];
}


- (void)viewDidLoad {
    self.recommendTable=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    [super viewDidLoad];
    self.centerApi=[[ISSTUserCenterApi alloc ]init];
    self.centerApi.webApiDelegate=self;
    self.recommendTable.delegate=self;
    self.recommendTable.dataSource=self;
    [self.view addSubview:_recommendTable];
    self.title=@"我的内推";
    self.recommendTable.rowHeight=80;
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(clickPost)];
    UINib *nib=[UINib nibWithNibName:@"ISSTMyRecommendCell" bundle:nil];
    [self.recommendTable registerNib:nib forCellReuseIdentifier:CellIdentifier];
    [self setupRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) clickPost{
    self.postRecommendViewController=[ISSTMyRecommendViewController new];
    self.postRecommendViewController.navigationItem.title=@"新内推";
    [self.navigationController pushViewController:self.postRecommendViewController animated:YES];
}

- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    // dateKey用于存储刷新时间，可以保证不同界面拥有不同的刷新时间
    [self.recommendTable addHeaderWithTarget:self action:@selector(headerRereshing) ];
    
    [self.recommendTable headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.recommendTable addFooterWithTarget:self action:@selector(footerRereshing)];
    
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    // 1.添加数据
    [self.centerApi requestRecommendListWithPage:loadPage pageSize:20];
    NSLog(@"#################################headerR####################################%@",recArray);
    // 刷新表格
    [self.recommendTable reloadData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [self.recommendTable headerEndRefreshing];
}


- (void)footerRereshing
{
    loadPage++;
    // 1.添加数据
    [self.centerApi requestRecommendListWithPage:loadPage pageSize:20];
    
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [self.recommendTable footerEndRefreshing];
}

-(NSString *) cityId2cityString:(int) cityId{
    NSString *cityString=[[NSString alloc] init];
    switch (cityId) {
        case 1:
            cityString=@"宁波";
            break;
        case 2:
            cityString=@"杭州";
            break;
        case 3:
            cityString=@"上海";
            break;
        case 4:
            cityString=@"北京";
            break;
            
        case 5:
            cityString=@"成都";
            break;
        case 6:
            cityString=@"广州";
            break;
        case 7:
            cityString=@"深圳";
            break;
        default:
            break;
    }
    return cityString;
}

#pragma mark -- UITableViewDataSource
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *list=recArray;
    return [list count];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==1) {
        [self clickPost];
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ISSTMyRecommendCell  *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell=[[ISSTMyRecommendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    ISSTRecommendModel *model=[recArray objectAtIndex:indexPath.row];
    cell.company.text=model.company;
    cell.title.text=model.title;
    cell.Cdescription.text=model.rDescription;
    cell.position.text=model.position;
    cell.city.text=[self cityId2cityString:model.cityId];
    cell.time.text=model.updatedAt;
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.postRecommendViewController=[[ISSTMyRecommendViewController alloc]init];
    ISSTRecommendModel *model=[ISSTRecommendModel new];
    model=[recArray objectAtIndex:indexPath.row];
    self.postRecommendViewController.positionString=model.position;
    self.postRecommendViewController.titleString=model.title;
    self.postRecommendViewController.companyString=model.company;
    self.postRecommendViewController.contentString=model.rDescription;
    self.postRecommendViewController.typeId=model.rId;
    
    self.postRecommendViewController.navigationItem.title=@"更新内推";
    [self.navigationController pushViewController:self.postRecommendViewController animated:YES];
    NSLog(@"++++++++++%@++++!!!!+++++++++++",model.rDescription);
//    [self presentViewController:self.postRecommendViewController animated:YES completion:nil];
}

#pragma mark-- ISSTWebDelegateApi
- (void)requestDataOnSuccess:(id)backToControllerData{
    if (loadPage==1) {
        recArray=[[NSMutableArray alloc] initWithArray:backToControllerData];
    }else{
        [recArray addObjectsFromArray:backToControllerData];
    }
    [self.recommendTable reloadData];
    NSLog(@"###########recArray%@#######################",recArray);
    if ([recArray count]==0 && count==1) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有发布过内推消息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"我要发布", nil];
        [alert show];
        count++;
    }
    
    
}

- (void)requestDataOnFail:(NSString *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您好:" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    
}
-(void) updateUserLogin{
    _userModel=[[ISSTUserModel alloc] init ];
    _userModel=[AppCache getCache];
    if (_userModel) {
        [self.userApi updateLoginUserId:[NSString stringWithFormat:@"%d",_userModel.userId] andPassword:_userModel.password];
        
        // 1.添加数据
        [self.centerApi requestRecommendListWithPage:loadPage pageSize:20];
        
        // 刷新表格
        [self.recommendTable reloadData];
        
    }
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
