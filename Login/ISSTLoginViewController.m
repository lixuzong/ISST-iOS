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
#import "sys/utsname.h"

const    static  int   REQUESTLOGIN         = 1;
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
-(void)getDeviceInfo
{
    
    NSLog(@"设备为:%@",[UIDevice currentDevice].model);
    
    NSLog(@"%@",[self deviceString]);
    
    NSLog(@"手机尺寸:%@",NSStringFromCGSize([[UIScreen mainScreen]bounds].size));
    
//    if (DEVICE_IS_IPHONE5) {
//        NSLog(@"机型为 iphone5 or iphone5s or iphone 5c");
//    }
//    
//    else{
//        
//        NSLog(@"机型为 iphone4s");
//    }

}
- (void)viewDidLoad

{
    [super viewDidLoad];
    response=NO;
   
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationController setNavigationBarHidden:YES];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"5login_bg.jpg"]];
    nameField.delegate=self;
    passwordField.delegate=self;
    
    //添加巨型button透明
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = frame;

    button.backgroundColor = [UIColor clearColor];
   
    [button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [self.view sendSubviewToBack:button];
   
    
     //self.navigationController.navigationItem.leftBarButtonItem.title = @"登录";
    [self.passwordField setSecureTextEntry:YES];//set password ......
    
    //获取机型信息
    [self getDeviceInfo];
   
    self.userApi =[[ISSTLoginApi alloc]init];
    self.userApi.webApiDelegate = self;
    
    _contactsApi = [[ISSTContactsApi alloc] init];
    _contactsApi.webApiDelegate  = self;
    
  
}

- (void)viewWillAppear:(BOOL)animated
{
    flag=self.passvalue.signOutFlag;
//    NSDictionary* defaults = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
//     
//    NSLog(@"Defaults: %@", defaults);
    [self.defaultLoginSwitch addTarget:self action:@selector(switchIsChanged:) forControlEvents:UIControlEventValueChanged];
    
    BOOL switchValue =[[[NSUserDefaults standardUserDefaults] objectForKey:@"switchValue"]boolValue];
    defaultLoginSwitch.on =switchValue;
    
    //检查缓存中是否有用户数据，若果是的话，直接登入进去。
//      if (defaultLoginSwitch.on) {
//          self.userModel = [AppCache getCache];
//          if (userModel) {
//              
//              nameField.text = userModel.userName;
//              NSString *password1=[[NSUserDefaults standardUserDefaults] objectForKey:@"passwordText"];
//              passwordField.text =password1;
//              
//              if(![flag isEqual:@"1"]){method  =   REQUESTLOGIN;
//                  [self.userApi requestLoginName:self.nameField.text andPassword:self.passwordField.text];}
//              
//          }
//     
//    }
    
}

- (IBAction)switchChanged:(id)sender { //用NSUserDefaults存储switch开关的值（NSUserDefaults适合存储小规模数据）
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:defaultLoginSwitch.on forKey:@"switchValue"];
}

- (void)switchIsChanged:(UISwitch *)paramSender
{
    if ([self.defaultLoginSwitch isOn]) {
            NSLog(@"Switch is on");
        }
        else{
            NSLog(@"Switch is off");
        }
}


- (void)viewWillDisappear:(BOOL)animated
{
  
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
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:passwordField.text forKey:@"passwordText"];
    

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
            [self.navigationController setNavigationBarHidden:YES];    //set system navigationbar hidden
           
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
    sideMenuViewController.backgroundImage = [UIImage imageNamed:@"menu_backgroud.jpg"];
    sideMenuViewController.menuPreferredStatusBarStyle = 1; // UIStatusBarStyleLightContent
    sideMenuViewController.delegate = self;
    //sideMenuViewController.contentViewShadowColor = [UIColor blackColor];
    sideMenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);
    //sideMenuViewController.contentViewShadowOpacity = 0.6;
    //sideMenuViewController.contentViewShadowRadius = 12;
    sideMenuViewController.contentViewShadowEnabled = YES;
    
//    UIApplication *app =[UIApplication sharedApplication];//重新设置navigationcontroller
//    AppDelegate *app2 =app.delegate;
//    app2.window.rootViewController = sideMenuViewController;
//    [app2.window makeKeyAndVisible];
    [self.navigationController pushViewController:sideMenuViewController animated: NO];
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

//判断设备机型
- (NSString*)deviceString
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";

    return platform;
}

@end
