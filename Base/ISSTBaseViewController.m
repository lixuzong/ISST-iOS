//
//  ISSTBaseViewController.m
//  ISST
//
//  Created by rth on 14/12/9.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTBaseViewController.h"
#import "RESideMenu.h"

@interface ISSTBaseViewController ()

@end

@implementation ISSTBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIColor * cc = [UIColor whiteColor];//设置字体颜色为白色
    NSDictionary * dict = [NSDictionary dictionaryWithObject:cc forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(21.0/255.0) green:(153.0 / 255.0) blue:(224.0 / 255.0) alpha:1]; // 设置navigationbar的背景色
    
    self.navigationController.navigationBar.tintColor =[UIColor whiteColor]; //设置空间颜色
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];  //设置leftbarButtonItem
    [leftButton setFrame:CGRectMake(0, 0, 40, 40)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"login_head.png"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
