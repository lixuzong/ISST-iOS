//
//  ISSTTasksViewController.m
//  ISST
//
//  Created by zhangran on 14-7-2.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTTasksViewController.h"
#import "ISSTTasksModel.h"
#import "ISSTUserCenterApi.h"
#import "ISSTTasksSurveyViewController.h"
@interface ISSTTasksViewController ()<UITableViewDataSource,UITableViewDelegate,ISSTWebApiDelegate>
{
    NSMutableArray *_listData;
    
    ISSTUserCenterApi *_userCenterApi;
    UITableView *_tableView;
    
}
@end

@implementation ISSTTasksViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initializatio
        self.title =@"去向调查";
        _userCenterApi = [[ISSTUserCenterApi alloc]init];
        _userCenterApi.webApiDelegate = self;
        _listData = [[NSMutableArray alloc] init];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UITableView *tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    tableView.dataSource = self ;
    tableView.delegate = self;
    
    [self.view addSubview:tableView];
    _tableView = tableView;
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [_userCenterApi requestTasksLists:0 pageSize:20 keywords:@""];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_listData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellTableIdentifier=@"ISSTTasksCell";
   // UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier forIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    
    if (cell ==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellTableIdentifier];
    }
    ISSTTasksModel *model = _listData[indexPath.row];
    cell.textLabel.text = model.name;
    
    return cell;
}

#pragma mark -UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"123");
    ISSTTasksSurveyViewController *controller = [[ISSTTasksSurveyViewController alloc] init];
    controller.model= _listData[indexPath.row];
    [self.navigationController pushViewController:controller  animated:NO];
    
    
}

#pragma mark - ISSTWebApiDelegate

- (void)requestDataOnSuccess:(id)backToControllerData
{
    _listData = backToControllerData;
    [_tableView reloadData];
}

- (void)requestDataOnFail:(NSString *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"异常" message:error delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
    [alert show];
}


@end
