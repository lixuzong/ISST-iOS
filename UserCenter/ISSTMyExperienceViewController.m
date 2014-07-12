//
//  ISSTMyExperienceViewController.m
//  ISST
//
//  Created by zhangran on 14-7-3.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTMyExperienceViewController.h"
#import "ISSTUserCenterApi.h"
#import "ISSTExperienceModel.h"
#import "ISSTCommonCell.h"
#import "ISSTPostExperienceViewController.h"

@interface ISSTMyExperienceViewController ()<UITableViewDataSource,UITableViewDelegate,ISSTWebApiDelegate>
{
    NSMutableArray *_listData;
    
    ISSTUserCenterApi *_userCenterApi;
    UITableView *_tableView;
    
}
@end

@implementation ISSTMyExperienceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initializatio
        self.title =@"我的经验";
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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStyleBordered target:self action:@selector(sendExperience)];
    UITableView *tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    tableView.dataSource = self ;
    tableView.delegate = self;
    
    [self.view addSubview:tableView];
    _tableView = tableView;
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [_userCenterApi requestExperienceLists:0 pageSize:20 keywords:@""];
}

-(void)sendExperience
{
    ISSTPostExperienceViewController *controller = [[ISSTPostExperienceViewController alloc] init];
    [self.navigationController pushViewController:controller animated:NO];
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
    static NSString *CellTableIdentifier=@"ISSTCommonCell";
    
    ISSTCommonCell *cell=(ISSTCommonCell *)[tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if (cell == nil) {
        cell = (ISSTCommonCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellTableIdentifier];
    }
    ISSTExperienceModel *model = _listData[indexPath.row];
    cell.textLabel.text = model.title;
    cell.title.text=model.title;
    cell.time.text=@"";
    cell.content.text= model.content;
    
    
    
    return cell;
}

#pragma mark -UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"123");
       
}

#pragma mark - ISSTWebApiDelegate

- (void)requestDataOnSuccess:(id)backToControllerData
{
    _listData = backToControllerData;
    if ([_listData count]>0) {
             [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
          [_tableView reloadData];
    }
    else
    {
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"您未发送过经验" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
        [alert show];
    }
  
}

- (void)requestDataOnFail:(NSString *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"异常" message:error delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
    [alert show];
}

@end


