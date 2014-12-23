//
//  ISSTLogin.m
//  ISST
//
//  Created by XSZHAO on 14-3-22.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTLoginViewController.h"
//#import "ISSTSlidebarNavController.h"
#import "ISSTLoginApi.h"
#import "AppCache.h"
#import "ISSTUserModel.h"
#import "ISSTContactsApi.h"
#import "ISSTUserCenterViewController.h"
#import "passValue.h"
#import "MBProgressHUD.h"
#import "ISSTNewsViewController.h"
#import "LeftMenuViewController.h"
#import "ISSTUpdateLogin.h"

const    static  int   REQUESTLOGIN         = 1;
const    static  int   UPDATELOGIN          = 2;
const static int        CLASSESLISTS        = 3;
const static int        MAJORSLISTS         = 4;
int method;

#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)

@interface ISSTLoginViewController ()<MBProgressHUDDelegate>
{
    ISSTContactsApi *_contactsApi;
    
    BOOL response ;//判断是否选中了texdfield。
    NSString *flag;//判断是否是注销 0表示未注销 1表示注销
    
    MBProgressHUD *HUD;

}
@property (nonatomic,strong)ISSTUserModel  *userModel;
@property (nonatomic,strong)ISSTLoginApi  *userApi;
@property (weak, nonatomic) IBOutlet UIButton *btnlogin;
@property (weak, nonatomic) IBOutlet UISwitch *defaultLoginSwitch;
@end

@implementation ISSTLoginViewController

@synthesize nameField;
@synthesize passwordField;
@synthesize userApi;
@synthesize userModel;
@synthesize defaultLoginSwitch;
@synthesize btnlogin;





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
    
    response=NO;
 
//     if ([[[UIDevice currentDevice]systemVersion] doubleValue] >= 7.0) {
//         self.edgesForExtendedLayout =UIRectEdgeNone;

//         NSLog(@"aaa");
//         NSLog(@"%f",self.view.frame.size.height);
//    }

   
    //self.title=@"ISST";
    
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationController setNavigationBarHidden:YES];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"5login_bg.jpg"]];
    nameField.delegate=self;
    passwordField.delegate=self;
    //添加巨型button透明
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = frame;
    //[self.view addSubview:img];
   // [self.view sendSubviewToBack:img];
    button.backgroundColor = [UIColor clearColor];
   
    [button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [self.view sendSubviewToBack:button];
    //
    
    if (DEVICE_IS_IPHONE5) {
        NSLog(@"4 inch");
        
        
    }else{
        
        NSLog(@"3.5");
        }
     //self.navigationController.navigationItem.leftBarButtonItem.title = @"登录";
    [self.passwordField setSecureTextEntry:YES];//set password ......
    
   
    self.userApi =[[ISSTLoginApi alloc]init];
    self.userApi.webApiDelegate = self;
    
    _contactsApi = [[ISSTContactsApi alloc] init];
    _contactsApi.webApiDelegate  = self;
    
    //self.navigationController.navigationBar.barTintColor  [[UIColor blueColor];
   // self.navigationController.navigationBar.barTintColor = [UIColor blueColor]; //设置导航栏颜色
    //self.navigationController.navigationBarHidden = YES;     隐藏导航栏
    //UINavigationController *navigationcontroller =[[ISSTNewsViewController alloc]init];
    
  
}

- (void)viewWillAppear:(BOOL)animated


{
    flag=self.passvalue.signOutFlag;
   //[self passValue:flag];
    NSLog(@"%@",flag);
    
//    nameField.text=@"21351007";
//    passwordField.text=@"111111";
    
    //检查缓存中是否有用户数据，若果是的话，直接登入进去。
//      if (defaultLoginSwitch.on) {
    self.userModel = [AppCache getCache];
    NSLog(@"是否有缓存");
//    ISSTUpdateLogin *up=[[ISSTUpdateLogin alloc]init];
//    [up update];
          if (userModel&&!flag) { //flag＝0 表示没有注销
              
              NSLog(@"检测是否有用户名！");
              NSLog(@"%@",self.userModel.userName);
              NSLog(@"%@",self.userModel.password);
              NSLog(@"%@",self.userModel.phone);
              nameField.text = userModel.userName;
              passwordField.text = userModel.password;
//              passwordField.text =userModel.
//              passwordField.text=@"111111";
              
//              if(![flag isEqual:@"1"]){method  =   REQUESTLOGIN;
//                  [self.userApi requestLoginName:self.nameField.text andPassword:self.passwordField.text];}
              

              
          
    NSLog(@"userid=%d",userModel.userId);
              
              // 正在登录提示框
              HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
              [self.navigationController.view addSubview:HUD];
              HUD.delegate = self;
              HUD.labelText = @"正在登录，请稍后...";
              [HUD show:YES];
              [HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
              
            // 正在登录方法
    [self.userApi updateLogin:[NSString stringWithFormat:@"%d",userModel.userId]andpwd:userModel.password];
    method=UPDATELOGIN;
    }
//    else
//    {
//        nameField.text = nil;
//        passwordField.text=nil;
//    }
    
    
    //有缓存数据的话
    //判断数据是否过时
    //过时，从服务器获取数据  更新UI,
    //未过时，更新UI,
}


- (void)viewWillDisappear:(BOOL)animated
{
    //NSString *password =nameField.text;
    //NSLog(@"%@" ,[userModel description]);
    //缓存数据模型
   // NSLog(@"%@",password);
    
    [AppCache saveCache:self.userModel];
    [super viewWillDisappear:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(id)sender {
     method  =   REQUESTLOGIN;
    
    //MBprogress
     HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
     HUD.delegate = self;
     HUD.labelText = @"请稍后...";
     [HUD show:YES];
     [HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];

   [self.userApi requestLoginName:self.nameField.text andPassword:self.passwordField.text];
    
}

-(void)buttonClicked
{
   
    [UIView beginAnimations:@"View Flip" context:nil];
    //动画持续时间
    [UIView setAnimationDuration:0.3];
    [nameField resignFirstResponder];
    [passwordField resignFirstResponder];
    NSLog(@"button click");
    if([[[UIDevice currentDevice]systemVersion] doubleValue] >= 7.0)
    {
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    else{
        self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    [UIView commitAnimations];
}

#pragma mark -
#pragma mark  ISSTWebApiDelegate Methods
- (void)requestDataOnSuccess:(id)backToControllerData;
{
    //ISSTSlidebarNavController *slider ;


    switch (method) {
        case REQUESTLOGIN:
        
            userModel = backToControllerData;
             method = CLASSESLISTS;
            [_contactsApi requestClassesLists];
            
            //[HUD hide:YES afterDelay:0.5];//3s延迟
            [HUD hide:YES];  //隐藏MBprogressHUD

            break;
        case CLASSESLISTS:
            method = MAJORSLISTS;
             [_contactsApi requestMajorsLists];
         
            
            break;
        case MAJORSLISTS:
        case UPDATELOGIN:
            [HUD hide:YES];
            //slider =[[ISSTSlidebarNavController alloc]init];
            [self.navigationController setNavigationBarHidden:YES];    //set system navigationbar hidden
            //[self.navigationController pushViewController:slider animated: NO];
           
            [self showMenu];
            break;
            
         default:
            
            break;
    }
    
    

  
    
}


-(void) showMenu{
    UINavigationController *navigationController1 = [[UINavigationController alloc] initWithRootViewController:[[ISSTNewsViewController alloc] init]];
    LeftMenuViewController *leftMenuViewController = [[LeftMenuViewController alloc
                                                       ] init];
    RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:navigationController1
                                                                    leftMenuViewController:leftMenuViewController
                                                                   rightMenuViewController:nil];  //可以自行设置右边菜单
//<<<<<<< HEAD
////    sideMenuViewController.backgroundImage = [UIImage imageNamed:@"124.png"];
//=======
    sideMenuViewController.backgroundImage = [UIImage imageNamed:@"menu_backgroud.jpg"];
//>>>>>>> 17436050c4bff9ab43e4469eca10c9c906fa77f4
    sideMenuViewController.menuPreferredStatusBarStyle = 1; // UIStatusBarStyleLightContent
    sideMenuViewController.delegate = self;
    //sideMenuViewController.contentViewShadowColor = [UIColor blackColor];
    sideMenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);
    //sideMenuViewController.contentViewShadowOpacity = 0.6;
    //sideMenuViewController.contentViewShadowRadius = 12;
    sideMenuViewController.contentViewShadowEnabled = YES;
//<<<<<<< HEAD
////    
//=======
//    
//>>>>>>> 17436050c4bff9ab43e4469eca10c9c906fa77f4
//    UIApplication *app =[UIApplication sharedApplication];//重新设置navigationcontroller
//    AppDelegate *app2 =app.delegate;
//    app2.window.rootViewController = sideMenuViewController;
//    [app2.window makeKeyAndVisible];
//<<<<<<< HEAD
//      [self.navigationController pushViewController:sideMenuViewController animated: NO];
//=======
    [self.navigationController pushViewController:sideMenuViewController animated: NO];
//>>>>>>> 17436050c4bff9ab43e4469eca10c9c906fa77f4
}

- (void)requestDataOnFail:(NSString *)error
{

    [HUD hide:YES]; //MBProgressHUD 隐藏
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您好:" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
//        self.nameField.text = @"";
//        self.passwordField.text = @"";
//   }
  
    self.nameField.text = @"";
    self.passwordField.text = @"";

}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //if(!DEVICE_IS_IPHONE5)
    {
    NSLog(@"sdsd");
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //上移30个单位，按实际情况设置
        
    CGRect rect=CGRectMake(0.0f,-80,width,height);
        
       // CGRect text=btnlogin.frame;
    self.view.frame=rect;
        //text=CGRectMake(30, 350, 238, 30);
       // btnlogin.frame=text;
   [UIView commitAnimations];
    }
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
     response=NO;
    [UIView beginAnimations:@"View Flip" context:nil];
    //动画持续时间
    [UIView setAnimationDuration:0.3f];
   
    [textField resignFirstResponder];
    [UIView commitAnimations];

    
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (!response) {
        
    //[UIView beginAnimations:@"asjkasjdkadj" context:nil];
        [UIView beginAnimations:@"View Flip" context:nil];
        //动画持续时间
        [UIView setAnimationDuration:0.3f];
    
self.view.frame =CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
       // [UIView setAnimationDuration:2];
        //动画会造成登录后动画错乱－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
         [UIView commitAnimations];
    }}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    response=YES;
}


#pragma mark - Execution code（MBProgressHUD）
- (void)myTask {
    // Do something usefull in here instead of sleeping ...可以增加一些逻辑代码
    sleep(3);
}


#pragma mark - MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    HUD = nil;
}
@end
