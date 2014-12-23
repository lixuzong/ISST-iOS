//
//  AppDelegate.m
//  ISST
//
//  Created by XSZHAO on 14-3-20.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "AppDelegate.h"
#import "ISSTLoginViewController.h"
#import "BPush.h"
#import "JSONKit.h"
#import "ISSTUserCenterViewController.h"
#import "ISSTNewsViewController.h"
#import "LeftMenuViewController.h"


@implementation AppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] ;
   // self.navigationController = [[[UINavigationController alloc] initWithRootViewController:homeViewController] autorelease];

    
    pushtag=0;
    _foreground=0;
    login=0;
    
    [BPush setupChannel:launchOptions];
    [BPush setDelegate:self];
    

    //注册消息
    if
        ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            
        NSLog(@"ios8");
        UIUserNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    else

        
    {
        NSLog(@"<=ios7");
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
    
    
     ISSTLoginViewController *loginViewController = [[[ISSTLoginViewController alloc] init]autorelease];
    loginViewController.title = @"ISST";
    _navigationController = [[[UINavigationController alloc] initWithRootViewController:loginViewController] autorelease];
    _window.rootViewController = _navigationController ;

    [_window makeKeyAndVisible];
    
    
    
    return YES;
    
    
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"devicetoken");
    NSLog(@"devicetoken=%@",deviceToken);
    [BPush registerDeviceToken:deviceToken]; // 必须 [BPush bindChannel]
    [BPush bindChannel];
    
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
    }
}

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
    
    
    //推送从后台启动
    if (_foreground&&login) {
        _foreground=0;
        NSLog(@"push to menu");
                [self showmenu];
           }
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    
    NSLog(@"failed to register");
}
//-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
//{
//    [BPush handleNotification:userInfo];
//}


-(void)showmenu
{
    ISSTLoginViewController *loginViewController = [[[ISSTLoginViewController alloc] init]autorelease];
    UINavigationController *navigationController1 = [[UINavigationController alloc] initWithRootViewController:[[ISSTNewsViewController alloc] init]];
    LeftMenuViewController *leftMenuViewController = [[LeftMenuViewController alloc
                                                       ] init];
    RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:navigationController1
                                                                    leftMenuViewController:leftMenuViewController
                                                                   rightMenuViewController:nil];  //可以自行设置右边菜单
    
    sideMenuViewController.backgroundImage = [UIImage imageNamed:@"menu_backgroud.jpg"];
    
    sideMenuViewController.menuPreferredStatusBarStyle = 1; // UIStatusBarStyleLightContent
    sideMenuViewController.delegate = loginViewController;
   
    sideMenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);
    
    sideMenuViewController.contentViewShadowEnabled = YES;
    [self.navigationController pushViewController:sideMenuViewController animated: NO];
}

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
    NSLog(@"foreground---------");
    
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
