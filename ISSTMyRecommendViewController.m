//
//  ISSTMyRecommendViewController.m
//  ISST
//
//  Created by lixu on 14/12/23.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTMyRecommendViewController.h"
#import "ISSTUserCenterApi.h"
#import "ISSTWebApiDelegate.h"
#import "ISSTUserModel.h"
#import "ISSTLoginApi.h"
#import "AppCache.h"

#define POST 0
#define UPDATE 1
@interface ISSTMyRecommendViewController ()<ISSTWebApiDelegate>
@property(strong,nonatomic) ISSTUserModel *userModel;
@property(strong,nonatomic) ISSTUserCenterApi *centerApi;
@property (strong,nonatomic) ISSTLoginApi *userApi;

-(void) clickPostRecommend;

@end

@implementation ISSTMyRecommendViewController
@synthesize titleField,comanyField,positionField,contentTextView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.centerApi=[[ISSTUserCenterApi alloc] init];
    self.centerApi.webApiDelegate=self;
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonSystemItemEdit target:self action:@selector(clickPostRecommend)];
    // Do any additional setup after loading the view from its nib.
}

-(void) clickPostRecommend{
    [self.centerApi requestPostRecommendWithType:POST titile:titleField.text content:contentTextView.text company:comanyField.text position:positionField.text cityId:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- ISSTWebApiDelegate
-(void) requestDataOnFail:(NSString *)error{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    
}
-(void) updateUserLogin{
    _userModel=[[ISSTUserModel alloc] init ];
    _userModel=[AppCache getCache];
    if (_userModel) {
        [self.userApi updateLoginUserId:[NSString stringWithFormat:@"%d",_userModel.userId] andPassword:_userModel.password];
        [self viewDidLoad];
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
