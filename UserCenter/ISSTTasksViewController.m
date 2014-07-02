//
//  ISSTTasksViewController.m
//  ISST
//
//  Created by zhangran on 14-7-2.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTTasksViewController.h"

#import "ISSTUserCenterApi.h"

@interface ISSTTasksViewController ()
{
    ISSTUserCenterApi *_userCenterApi;
}
@end

@implementation ISSTTasksViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initializatio
        self.title =@"任务列表";
        _userCenterApi = [[ISSTUserCenterApi alloc]init];
        _userCenterApi.webApiDelegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
