//
//  ISSTTasksViewController.m
//  ISST
//
//  Created by rth on 14-12-6.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//  该页面暂时不用
//  该页面暂时不用

#import "ISSTTasksViewController.h"
#import "ISSTTasksModel.h"
#import "ISSTUserCenterApi.h"
#import "ISSTTasksSurveyViewController.h"
#import "ISSTTaskCell.h"

@interface ISSTTasksViewController ()<UITableViewDataSource,UITableViewDelegate,ISSTWebApiDelegate>
{
    NSMutableArray *_listData;
    
    ISSTUserCenterApi *_userCenterApi;
    UITableView *_tableView;
    
}
@end

@implementation ISSTTasksViewController
static NSString *CellTableIdentifier=@"ISSTTaskCell";


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
    //_tableView = tableView;
    [_userCenterApi requestTasksLists:0 pageSize:20 keywords:@"string"];
    
    // Do any additional setup after loading the view.
}

//-(void)viewWillAppear:(BOOL)animated
//{
//    
//}

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
    //static NSString *CellTableIdentifier=@"ISSTTaskCell";
     //newsModel = [newsArray objectAtIndex:indexPath.row];
   // UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier forIndexPath:indexPath];
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    UINib *nib=[UINib nibWithNibName:@"ISSTTaskCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:CellTableIdentifier];
    ISSTTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    
    if (cell ==nil) {
        cell = [[ISSTTaskCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellTableIdentifier];
    }
    ISSTTasksModel *model = [_listData objectAtIndex:indexPath.row];
    //model = [_listData objectAtIndex:indexPath.row];
    //cell.textLabel.text = model.name;
    cell.TaskType.text = @"woca";
    cell.TaskActivity.text = model.name;
    NSLog(@"666666");
    NSLog(@"%@",model.name);
    NSLog(@"%@",cell.TaskActivity.text);
    
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
    NSLog(@"7758258");
    _listData = backToControllerData;
    [_tableView reloadData];
}

- (void)requestDataOnFail:(NSString *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"异常" message:error delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
    [alert show];
}


@end
