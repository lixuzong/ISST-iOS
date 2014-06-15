//
//  ChangeUserInfoVC.m
//  ISST
//
//  Created by zhaoxs on 6/15/14.
//  Copyright (c) 2014 MSE.ZJU. All rights reserved.
//

#import "ChangeUserInfoVC.h"

@interface ChangeUserInfoVC ()<UITableViewDataSource,UITabBarDelegate>
{
    UITableView *_tableView;
}
@end

@implementation ChangeUserInfoVC

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
    [super viewDidLoad];
    _tableView =[[UITableView alloc]initWithFrame:self.view.bounds];
    // Do any additional setup after loading the view from its nib.
    _tableView.delegate= self;
    _tableView.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tabaleDataSource
- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}


@end
