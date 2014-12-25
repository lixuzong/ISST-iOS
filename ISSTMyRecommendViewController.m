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
#import "ISSTRecommendModel.h"
#import "ZHPickView.h"
#import <QuartzCore/QuartzCore.h>
#import "ISSTMyRecListViewController.h"


@interface ISSTMyRecommendViewController ()<ISSTWebApiDelegate,ZHPickViewDelegate,UIAlertViewDelegate>
@property(strong,nonatomic) ISSTUserModel *userModel;
@property(strong,nonatomic) ISSTUserCenterApi *centerApi;
@property (strong,nonatomic) ISSTLoginApi *userApi;
@property (strong,nonatomic) ZHPickView *cityPickerView;

-(void) clickPostRecommend;
@property (strong,nonatomic) ISSTRecommendModel *model;
@property (strong,nonatomic) NSArray* cityArray;
@end

@implementation ISSTMyRecommendViewController
@synthesize titleField,comanyField,positionField,contentTextView,model,typeId,cityId,cityArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    cityId=1;
    
    cityArray=[[NSArray alloc] initWithObjects:@"宁波",@"杭州",@"上海",@"北京",@"成都",@"广州",@"深圳", nil];
    //设置边框
    self.contentTextView.layer.borderColor=[UIColor grayColor].CGColor;
    self.contentTextView.layer.borderWidth=1.0;
    
    self.titleField.text=_titleString;
    self.contentTextView.text=_contentString;
    self.comanyField.text=_companyString ;
    self.positionField.text=_positionString;
    
    NSLog(@"+++++++++++++++++++typeId%li+++++++++++++++++",(long)typeId);
    self.centerApi=[[ISSTUserCenterApi alloc] init];
    self.centerApi.webApiDelegate=self;
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonSystemItemEdit target:self action:@selector(clickPostRecommend)];
    // Do any additional setup after loading the view from its nib.
}

-(void) clickPostRecommend{
    [self.centerApi requestPostRecommendWithType:typeId titile:titleField.text content:contentTextView.text company:comanyField.text position:positionField.text cityId:cityId];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ZhpickVIewDelegate

-(void) toobarDonBtnHaveClick:(ZHPickView *)pickView resultIndex:(NSInteger)index {
    switch (index) {
        case 0:
            cityId=1;
            break;
        case 1:
            cityId=2;
            break;
        case 2:
            cityId=3;
            break;
        case 3:
            cityId=4;
            break;
            
        case 4:
            cityId=5;
            break;
        case 5:
            cityId=6;
            break;
        case 6:
            cityId=7;
            break;
        default:
            break;
            
        
    }
    NSLog(@"*****************************%i**************************",cityId);
}

-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString{
    
    self.cityButton.titleLabel.text=resultString;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0f;
}


#pragma mark -- ISSTWebApiDelegate
-(void) requestDataOnFail:(NSString *)error{
    if ([error isKindOfClass:[NSNull class]]) {
        error=@"发送成功";
    }
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:error delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    NSLog(@"********************************error*******************");
    [alert show];
     NSLog(@"********************************error*******************");
    
}
-(void) updateUserLogin{
    _userModel=[[ISSTUserModel alloc] init ];
    _userModel=[AppCache getCache];
    if (_userModel) {
        [self.userApi updateLoginUserId:[NSString stringWithFormat:@"%d",_userModel.userId] andPassword:_userModel.password];
        [self viewDidLoad];
    }
    
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
//    ISSTMyRecListViewController *listViewController=[[ISSTMyRecListViewController alloc] init];
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)selectCity:(id)sender {
    self.cityPickerView=[[ZHPickView alloc] initPickviewWithArray:cityArray isHaveNavControler:NO];
    self.cityPickerView.delegate=self;
    [self.cityPickerView show];
    
}
@end
