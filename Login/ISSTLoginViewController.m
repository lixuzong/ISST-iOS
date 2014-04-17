//
//  ISSTLogin.m
//  ISST
//
//  Created by XSZHAO on 14-3-22.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTLoginViewController.h"
#import "ISSTSlidebarNavController.h"
#import "ISSTLoginApi.h"
#import "AppCache.h"
#import "ISSTUserModel.h"

@interface ISSTLoginViewController ()
@property (nonatomic,strong)ISSTUserModel  *userModel;
@property (nonatomic,strong)ISSTLoginApi  *userApi;
@property (weak, nonatomic) IBOutlet UISwitch *defaultLoginSwitch;
@end

@implementation ISSTLoginViewController
@synthesize nameField;
@synthesize passwordField;
@synthesize userApi;
@synthesize userModel;
@synthesize defaultLoginSwitch;

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

    if ([[[UIDevice currentDevice]systemVersion] doubleValue] >= 7.0) {
        self.edgesForExtendedLayout =UIRectEdgeNone;
    }
    self.title=@"iSST";
    [self.navigationItem setHidesBackButton:YES];
   [self.navigationController setNavigationBarHidden:NO];
    
     self.navigationController.navigationItem.leftBarButtonItem.title = @"登录";
    [self.passwordField setSecureTextEntry:YES];//set password ......
    self.userApi =[[ISSTLoginApi alloc]init];
    self.userApi.webApiDelegate = self;
  
}

- (void)viewWillAppear:(BOOL)animated
{
    //检查缓存中是否有用户数据
      if (defaultLoginSwitch.on) {
          self.userModel = [AppCache getCache];
          if (userModel) {
              NSLog(@"%@" ,[userModel description]);
          }
          nameField.text = userModel.userName;
          passwordField.text=@"111111";
    }
    else
    {
        nameField.text = nil;
        passwordField.text=nil;
    }
    
    
    //有缓存数据的话
    //判断数据是否过时
    //过时，从服务器获取数据  更新UI,
    //未过时，更新UI,
}


- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"%@" ,[userModel description]);
    NSLog(@"%@",userModel.name);
    //缓存数据模型
    
    [AppCache saveCache:self.userModel];
    [super viewWillDisappear:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(id)sender {
    
  // ISSTSlidebarNavController *slider =[[[ISSTSlidebarNavController alloc]init]autorelease];

   //[self.navigationController pushViewController:slider animated: NO];
   [self.userApi requestLoginName:self.nameField.text andPassword:self.passwordField.text];
   


}



#pragma mark -
#pragma mark  ISSTWebApiDelegate Methods
- (void)requestDataOnSuccess:(id)backToControllerData;
{
    
    userModel = backToControllerData;
      ISSTSlidebarNavController *slider =[[ISSTSlidebarNavController alloc]init]
    ;
   // [self.navigationController pushViewController:[[ISSTSlidebarNavController alloc]init] animated:YES ];
 
     [self.navigationController setNavigationBarHidden:YES];    //set system navigationbar hidden
    [self.navigationController pushViewController:slider animated: NO];
    
}

- (void)requestDataOnFail:(NSString *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您好:" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
  
    self.nameField.text = @"";
    self.passwordField.text = @"";

}




@end
