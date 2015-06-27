//
//  ISSTPushViewController.m
//  ISST
//
//  Created by apple on 14/12/11.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTPushViewController.h"
#import "ISSTUserCenterApi.h"
#import "ISSTPushCell.h"
#import "MJRefresh.h"
#import "ISSTUserModel.h"
#import "ISSTPushModel.h"
#import "ISSTLoginApi.h"
#import "AppCache.h"

@interface ISSTPushViewController ()
{
    NSMutableArray *pushArray;
    int  loadPage ;
    
}

@property (nonatomic,strong)ISSTUserCenterApi *pushApi;
@property(nonatomic,strong)ISSTLoginApi *userApi;
@property(nonatomic,strong)ISSTUserModel *userModel;
@property(nonatomic,strong)ISSTPushModel *pushModel;
@property(nonatomic,strong)ISSTPushDetailViewController *pushDetailView;

@end


@implementation ISSTPushViewController
@synthesize pushApi;
@synthesize userApi;
@synthesize pushModel;
@synthesize pushTableview;
@synthesize pushDetailView;
static NSString *CellTableIdentifier=@"ISSTPushCell";
//static int  loadPage = 1;
- (void)viewDidLoad {
    [super viewDidLoad];
    loadPage=1;
    //初始化pushapi，并设置代理
    pushApi=[[ISSTUserCenterApi alloc]init];
    pushApi.webApiDelegate=self;
    
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.title=@"重要信息";
    
    //定义table行高
    pushTableview.rowHeight=60;
    
    //注册tableviewcell
    UINib *nib=[UINib nibWithNibName:CellTableIdentifier bundle:nil];
    [pushTableview registerNib:nib forCellReuseIdentifier:CellTableIdentifier];
    
    //请求数据
//    [pushApi requestPushListWithPage:1 pagSize:20];
    [self setupRefresh];
    
}

- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    // dateKey用于存储刷新时间，可以保证不同界面拥有不同的刷新时间
    [pushTableview addHeaderWithTarget:self action:@selector(headerRereshing) ];
    
    [pushTableview headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [pushTableview addFooterWithTarget:self action:@selector(footerRereshing)];
    
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    // 1.添加数据
    [self.pushApi requestPushListWithPage:loadPage pagSize:20];
    
    // 刷新表格
    [self.pushTableview reloadData];
    
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [self.pushTableview headerEndRefreshing];
    
    
}


- (void)footerRereshing
{
    loadPage++;
    // 1.添加数据
    [self.pushApi requestPushListWithPage:loadPage pagSize:20];
    
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [pushTableview footerEndRefreshing];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if ([pushArray count]==0) {
        return 1;
    }
    else
    return [pushArray count];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ISSTPushCell  *cell=(ISSTPushCell *)[tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if (cell == nil) {
        cell = [[ISSTPushCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellTableIdentifier];
    }

    if ([pushArray count]==0) {
        cell.titleLabel.text=@"";
        cell.contentLabel.text=@"目前暂无消息";
        cell.timeLabel.hidden=YES;
    }
    else {
        
    pushModel=[pushArray objectAtIndex:indexPath.row];
        cell.timeLabel.hidden=NO;
        cell.titleLabel.text=pushModel.title;
    cell.contentLabel.text=pushModel.content;
    cell.timeLabel.text=pushModel.updatedAt;
    }
    return cell;
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"select");
    pushDetailView=[[ISSTPushDetailViewController alloc]init];
    pushDetailView.navigationItem.title=@"详细信息";
    ISSTPushModel *pushModel=[pushArray objectAtIndex:indexPath.row];
    pushDetailView.tit=pushModel.title;
    pushDetailView.content=pushModel.content;
    pushDetailView.updateAt=pushModel.updatedAt;
    
    [self.navigationController pushViewController:pushDetailView animated:YES];
    
}

#pragma mark - webapidelegate
- (void)requestDataOnSuccess:(id)backToControllerData{
    NSLog(@"laodpage=%d",loadPage);
    if (loadPage==1) {
        pushArray=[[NSMutableArray alloc] initWithArray:backToControllerData];
    }else{
        [pushArray addObjectsFromArray:backToControllerData];
    }
    [self.pushTableview reloadData];
    
    NSLog(@"####################pushArray#######################%@",pushArray);
//    pushModel=[pushArray objectAtIndex:0];
    NSLog(@"title=%@",pushModel.title);
//    NSLog(@"列表行数＝%d",[pushArray count]);
    
    
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
        
        //1.添加数据
        [self.pushApi requestPushListWithPage:loadPage pagSize:20];

        
        // 刷新表格
        [self.pushTableview reloadData];
        
    }
    
}

-(void)dealloc
{
    pushApi.webApiDelegate=nil;
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
