//
//  AppDelegate.m
//  ISST
//
//  Created by XSZHAO on 14-3-20.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "AppDelegate.h"
#import "ISSTLoginViewController.h"
#import "ISSTLoginApi.h"
#import "AppCache.h"
#import "BPush.h"
#import "JSONKit.h"
#import "ISSTUserModel.h"
#import "AppDelegate.h"
#import "ISSTContactsApi.h"
#import "RESideMenu.h"
#import "ISSTNewsViewController.h"
#import "LeftMenuViewController.h"


@implementation AppDelegate
@synthesize window = _window;
@synthesize navigationController = _navigationController;
@synthesize userModel;
@synthesize userApi;

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    userApi =[[ISSTLoginApi alloc]init];
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] ;
    
    BOOL switchValue =[[[NSUserDefaults standardUserDefaults] objectForKey:@"switchValue"]boolValue];
    
    //初始化（推送，后台，登陆）标识。
    pushtag=0;
    _foreground=0;
    login=0;
    
    
    
    [BPush setupChannel:launchOptions];
    [BPush setDelegate:self];
    
    
    
    //注册消息
    if
        ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            
            NSLog(@"系统版本>=ios8");
            UIUserNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        }
    
    else
        
        
    {
        NSLog(@"系统版本<=ios7");
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
    
    // 处理badge
    if([launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey])
    {
        pushtag=1;
        int badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
        NSLog(@"badge=%d",badge);
        if(badge > 0)
        {
            badge--;
            [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
        }
    }

    
    if(switchValue){
        
        //如果用户选择了自动登入则直接登入到软院快讯界面
        
        //要判断是否能上网的情况
        
        userModel =[AppCache getCache];
        
        userApi.webApiDelegate=self;
        NSString *password1=[[NSUserDefaults standardUserDefaults] objectForKey:@"passwordText"];
 
        NSLog(@"name:%@",userModel.name);
        [userApi requestLoginName:userModel.name andPassword:password1];
        
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
        
        //[self.navigationController pushViewController:sideMenuViewController animated: NO];
        
        _window.rootViewController = sideMenuViewController ;
        [_window makeKeyAndVisible];
        
        
    }
    else
        {
        ISSTLoginViewController *loginViewController = [[[ISSTLoginViewController alloc] init]autorelease];
        loginViewController.title = @"ISST";
        _navigationController = [[[UINavigationController alloc] initWithRootViewController:loginViewController] autorelease];
        _window.rootViewController = _navigationController ;
        [_window makeKeyAndVisible];
        }
    
    
    
    return YES;
    
    
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"get the devicetoken");
    NSLog(@"devicetoken=%@",deviceToken);
    [BPush registerDeviceToken:deviceToken]; // 必须 [BPush bindChannel]
    [BPush bindChannel];
    
}



- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}


- (void) onMethod:(NSString*)method response:(NSDictionary*)data
{
    if
        ([BPushRequestMethod_Bind isEqualToString:method])
    {
        NSDictionary* res = [[NSDictionary alloc] initWithDictionary:data];
        NSString *appid = [res valueForKey:BPushRequestAppIdKey];
        NSString *userid = [res valueForKey:BPushRequestUserIdKey];
        NSString *channelid = [res valueForKey:BPushRequestChannelIdKey];
        int returnCode = [[res valueForKey:BPushRequestErrorCodeKey] intValue];
        NSString *requestid = [res valueForKey:BPushRequestRequestIdKey];
        NSLog(@"userid=%@",userid);
         NSLog(@"channelid=%@",channelid);
        bpuserid=userid;
        bpchannelid=channelid;
        
        
        userModel =[AppCache getCache];
          userApi.webApiDelegate=self;
       
        if(userModel.userName)
        {
            NSLog(@"post push id by startappview");
         [self.userApi postPushWithStudentid: userModel.userName andUserid:bpuserid andChannelid:bpchannelid];
        }
       
    }
}

// receive the notification
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    int badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    NSLog(@"badge=%d",badge);
    if(badge > 0)
    {
        badge--;
        [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
    }
    pushtag=1;
    
    [BPush handleNotification:userInfo];
    
    
    //push start from background
    if (_foreground&&login) {
        _foreground=0;
        NSLog(@"从后台启动推送");
        [self showmenu];
    }
    
    //push start from foreground
    else if(login)
    {
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"推送通知" message:@"您收到了通知" delegate:self cancelButtonTitle:@"下次再说" otherButtonTitles:@"好前往查看", nil];
        [alert show];
    }
}

// alertview event
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"clickButtonAtIndex:%ld",(long)buttonIndex);
    if(buttonIndex==1)//click ok
    {
        NSLog(@"推送从前台启动");
        [self showmenu];
    }
    else //click cancel
    {
        pushtag=0; //把推送标识设为0；
    }
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
        NSLog(@"failed to register push service");
}

//-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
//{
//    [BPush handleNotification:userInfo];
//}

// show the homepage skipping the login page
-(void)showmenu
{
    UINavigationController *navigationController1 = [[UINavigationController alloc] initWithRootViewController:[[ISSTNewsViewController alloc] init]];
    LeftMenuViewController *leftMenuViewController = [[LeftMenuViewController alloc
                                                       ] init];
    RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:navigationController1
                                                                    leftMenuViewController:leftMenuViewController
                                                                   rightMenuViewController:nil];  //可以自行设置右边菜单
    
    sideMenuViewController.backgroundImage = [UIImage imageNamed:@"menu_backgroud.jpg"];
    
    sideMenuViewController.menuPreferredStatusBarStyle = 1; // UIStatusBarStyleLightContent
    sideMenuViewController.delegate = self;
    
    sideMenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);
    
    sideMenuViewController.contentViewShadowEnabled = YES;
   
//   [_navigationController pushViewController:sideMenuViewController animated: NO];//竟然没效果
    NSLog(@"self.navigationController%@",self.navigationController);
    _window.rootViewController = sideMenuViewController ;
      [_window makeKeyAndVisible];
    
}


- (void)requestDataOnSuccess:(id)backToControllerData;
{
    userModel = backToControllerData;
//    ISSTContactsApi *contactsApi =[[ISSTContactsApi alloc]init];
//    [contactsApi requestClassesLists];
//    [contactsApi requestMajorsLists];
//    
}

//- (void)requestDataOnFail:(NSString *)error
//{
//    
////    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您好:" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
////    [alert show];
//    
//    
//}


- (void)dealloc
{
    _window = nil;
    _navigationController = nil;
    [super dealloc];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    _foreground=1;
    NSLog(@"enter foreground---------");

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
