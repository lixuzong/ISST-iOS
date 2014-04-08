//
//  ISSTUserInfoViewController.m
//  ISST
//
//  Created by XSZHAO on 14-4-7.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTUserInfoViewController.h"
#import "ISSTLoginApi.h"
#import "ISSTUserModel.h"
@interface ISSTUserInfoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;
@property (weak, nonatomic) IBOutlet UILabel *classNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *qqLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;

@property (strong, nonatomic) ISSTLoginApi      *loginApi;
@property (strong, nonatomic) ISSTUserModel     *userModel;
@end

@implementation ISSTUserInfoViewController
@synthesize userNameLabel,genderLabel,gradeLabel,classNameLabel,telLabel,emailLabel,qqLabel,cityLabel,companyLabel,positionLabel;
@synthesize loginApi;
@synthesize userModel;
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
    loginApi = [[ISSTLoginApi alloc]init];
    self.loginApi.webApiDelegate = self;
    [self.loginApi requestLoginName:@"21351110" andPassword:@"111111"];
   // [self.loginApi updateLogin];
  //  [self.loginApi requestUserInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)reloadView
{
    self.userNameLabel.text= userModel.userName;
    self.genderLabel.text  = userModel.gender == MALE?@"男":@"女";
    self.gradeLabel.text   = [NSString stringWithFormat:@"%d级",userModel.grade];// @"级";
    self.classNameLabel.text = [NSString stringWithFormat:@"%d",userModel.classId];
    self.telLabel.text       = userModel.phone;
    self.cityLabel.text      = [NSString stringWithFormat:@"%d",userModel.cityId];
    self.qqLabel.text        = userModel.qq;
    self.positionLabel.text  = userModel.position;
    self.companyLabel.text   = userModel.company;
    self.emailLabel.text     = userModel.email;
    
    
}

#pragma mark -
#pragma mark - ISSTWebApiDelegate Methods
- (void)requestDataOnSuccess:(id)backToControllerData
{
    userModel = (ISSTUserModel*)backToControllerData;
    [self reloadView];
   
    
   // NSLog(@"self=%@\n name=%@\n email=%@",self,userModel.name,userModel.email);
}

- (void)requestDataOnFail:(NSString *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您好:" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    
}

@end
