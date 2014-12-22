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

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] ;
    
    BOOL switchValue =[[[NSUserDefaults standardUserDefaults] objectForKey:@"switchValue"]boolValue];
    
    if(switchValue){//如果用户选择了自动登入则直接登入到软院快讯界面
        ISSTLoginApi *userApi =[[ISSTLoginApi alloc]init];
        
        userModel =[AppCache getCache];
        
        userApi.webApiDelegate = self;
        
        NSString *password1=[[NSUserDefaults standardUserDefaults] objectForKey:@"passwordText"];

        NSLog(@"%@",userModel.name);
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
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您好:" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//    [alert show];
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
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
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
