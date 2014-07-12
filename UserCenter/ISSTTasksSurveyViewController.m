//
//  ISSTTasksSurveyViewController.m
//  ISST
//
//  Created by zhangran on 14-7-5.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTTasksSurveyViewController.h"
#import "ISSTUserCenterApi.h"
#import "ISSTSurveyModel.h"
@interface ISSTTasksSurveyViewController ()<ISSTWebApiDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_listData;
    
    ISSTUserCenterApi *_userCenterApi;
    UITableView *_tableView;
    
    NSUInteger selectIndex;
}
@end

@implementation ISSTTasksSurveyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
              _listData = [NSMutableArray array];
        _userCenterApi = [[ISSTUserCenterApi alloc] init];
        _userCenterApi.webApiDelegate = self;
        
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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStyleBordered target:self action:@selector(send)];
    // Do any additional setup after loading the view.
}

-(void)send
{
    if (selectIndex ==-1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未选择内容，请先选择内容后在提交" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
        [alert show];
    }
    else{
        ISSTSurveyModel *surveyModel = _listData[selectIndex];
        [_userCenterApi requestSurveyResult:_model.taskId optionId:surveyModel.surveyId optionOther:nil remarks:nil];
    }


}

-(void)viewWillAppear:(BOOL)animated
{
    [_userCenterApi requestSurveyLists:_model.taskId];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
    ISSTSurveyModel *model = _listData[indexPath.row];
    cell.textLabel.text = model.label;
    
    return cell;
}

#pragma mark -UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"123");
    selectIndex = indexPath.row;
    
}
#pragma mark - ISSTWebApiDelegate

- (void)requestDataOnSuccess:(id)backToControllerData
{
    if (_userCenterApi.methodId==Survey) {
      
        _listData = backToControllerData;
        selectIndex =-1;
        [_tableView reloadData];
    }
    else if (_userCenterApi.methodId == SurveyResult)
    {
//      if ([backToControllerData isEqualToString:@"提交成功"]) {
//            [self.navigationController popViewControllerAnimated:NO];
//        }
//        else
//        {
//            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:backToControllerData delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
//            [alert show];
//        }

        ISSTSurveyModel *surveyModel = _listData[selectIndex];
        [_userCenterApi requestPostedSurvey:_model.taskId  optionId:surveyModel.surveyId ];
           }
  
    
    
}

- (void)requestDataOnFail:(NSString *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:error delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
    [alert show];
}

@end
