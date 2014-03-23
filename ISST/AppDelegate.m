//
//  AppDelegate.m
//  ISST
//
//  Created by XSZHAO on 14-3-20.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "AppDelegate.h"
/*
#import "ISSTRevealViewController.h"
#import "ISSTMenuViewController.h"
#import "ISSTRootViewController.h"
#import "ISSTMenuTableViewCell.h"

#import "ISSTSidebarSearchViewController.h"
#import "ISSTSidebarSearchViewControllerDelegate.h"

#import "GoViewController.h"
#pragma mark Private Interface
@interface AppDelegate ()<ISSTSidebarSearchViewControllerDelegate>
@property (nonatomic, strong) ISSTRevealViewController *revealController;
//搜索栏控制器
@property (nonatomic, strong) ISSTSidebarSearchViewController *searchController;

@property (nonatomic, strong) ISSTMenuViewController       *menuController;
@end
*/


#import "ISSTLoginViewController.h"
@implementation AppDelegate
@synthesize window = _window;
@synthesize navigationController = _navigationController;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /*
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
    UIColor *bgColor = [UIColor colorWithRed:(50.0f/255.0f) green:(57.0f/255.0f) blue:(74.0f/255.0f) alpha:1.0f];
    self.revealController = [[ISSTRevealViewController alloc]initWithNibName:nil bundle:nil];
    self.revealController.view.backgroundColor = bgColor;
    
    RevealBlock revealBlock = ^(){
        [self.revealController toggleSidebar:!self.revealController.sidebarShowing duration:kISSTRevealSidebarDefaultAnimationDuration];
    };
    
    NSArray *header =@[
                    //   [NSNull null],
                       @"软院生活",
                       @"职场信息",
                       @"通讯录",
                        @"同城",
                       @"个人中心"
                       ];

    
    NSArray *controllers = @[
                             @[
                                 [[UINavigationController alloc] initWithRootViewController:[[GoViewController alloc] initWithTitle:@"软院快讯" withRevealBlock:revealBlock]],
                                 [[UINavigationController alloc] initWithRootViewController:[[ISSTRootViewController alloc] initWithTitle:@"软院百科" withRevealBlock:revealBlock]],
                                 [[UINavigationController alloc] initWithRootViewController:[[ISSTRootViewController alloc] initWithTitle:@"在校活动" withRevealBlock:revealBlock]],
                                 [[UINavigationController alloc] initWithRootViewController:[[ISSTRootViewController alloc] initWithTitle:@"便捷服务" withRevealBlock:revealBlock]],
                                 [[UINavigationController alloc] initWithRootViewController:[[ISSTRootViewController alloc] initWithTitle:@"学习园地" withRevealBlock:revealBlock]]
                                 ],
                           @[
                                 [[UINavigationController alloc] initWithRootViewController:[[ISSTRootViewController alloc] initWithTitle:@"实习" withRevealBlock:revealBlock]],
                                 [[UINavigationController alloc] initWithRootViewController:[[ISSTRootViewController alloc] initWithTitle:@"就业" withRevealBlock:revealBlock]],
                                 [[UINavigationController alloc] initWithRootViewController:[[ISSTRootViewController alloc] initWithTitle:@"内推" withRevealBlock:revealBlock]],
                                 [[UINavigationController alloc] initWithRootViewController:[[ISSTRootViewController alloc] initWithTitle:@"经验交流" withRevealBlock:revealBlock]]
                                 ],
                             @[
                                 [[UINavigationController alloc] initWithRootViewController:[[ISSTRootViewController alloc] initWithTitle:@"通讯录" withRevealBlock:revealBlock]]
                                 ],
                             @[
                                 [[UINavigationController alloc] initWithRootViewController:[[ISSTRootViewController alloc] initWithTitle:@"城主" withRevealBlock:revealBlock]],
                                 [[UINavigationController alloc] initWithRootViewController:[[ISSTRootViewController alloc] initWithTitle:@"同城活动" withRevealBlock:revealBlock]],
                                 [[UINavigationController alloc] initWithRootViewController:[[ISSTRootViewController alloc] initWithTitle:@"同城校友" withRevealBlock:revealBlock]]
                                 ],
                             @[
                                 [[UINavigationController alloc] initWithRootViewController:[[ISSTRootViewController alloc] initWithTitle:@"消息中心" withRevealBlock:revealBlock]],
                                 [[UINavigationController alloc] initWithRootViewController:[[ISSTRootViewController alloc] initWithTitle:@"任务中心" withRevealBlock:revealBlock]],
                                 [[UINavigationController alloc] initWithRootViewController:[[ISSTRootViewController alloc] initWithTitle:@"个人信息" withRevealBlock:revealBlock]],
                                 [[UINavigationController alloc] initWithRootViewController:[[ISSTRootViewController alloc] initWithTitle:@"活动管理" withRevealBlock:revealBlock]],
                                 [[UINavigationController alloc] initWithRootViewController:[[ISSTRootViewController alloc] initWithTitle:@"在职事务" withRevealBlock:revealBlock]],
                                 [[UINavigationController alloc] initWithRootViewController:[[ISSTRootViewController alloc] initWithTitle:@"附近的人" withRevealBlock:revealBlock]]
                                 ]
                          
                             ];
  
    NSArray *cellInfos = @[
                           @[
                               @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: NSLocalizedString(@"软院快讯", @"")},
                                @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey:NSLocalizedString(@"软院百科", @"")},
                               @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: NSLocalizedString(@"在校活动", @"")},
                               @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: NSLocalizedString(@"便捷服务", @"")},
                               @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: NSLocalizedString(@"学习园地", @"")}
                                ],
                           @[
                               @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: NSLocalizedString(@"实习", @"")},
                               @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: NSLocalizedString(@"就业", @"")},
                               @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: NSLocalizedString(@"内推", @"")},
                               @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: NSLocalizedString(@"经验交流", @"")}
                               ],
                           @[
                               @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: NSLocalizedString(@"通讯录", @"")}
                               ],
                           @[
                               @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: NSLocalizedString(@"城主", @"")},
                               @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: NSLocalizedString(@"同城活动", @"")},
                               @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: NSLocalizedString(@"同城校友", @"")}
                               ],
                           @[
                               @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: NSLocalizedString(@"消息中心", @"")},
                               @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: NSLocalizedString(@"任务中心", @"")},
                               @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: NSLocalizedString(@"个人信息", @"")},
                               @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: NSLocalizedString(@"活动管理", @"")},
                               @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: NSLocalizedString(@"在职事务", @"")},
                               @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: NSLocalizedString(@"附近的人", @"")}
                               ]
                           ];
    
    [controllers enumerateObjectsUsingBlock:
     ^(id obj,NSUInteger idx,BOOL *stop)
    {
        [(NSArray *)obj enumerateObjectsUsingBlock:^(id obj2, NSUInteger idx2, BOOL *stop2)
         {
             UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self.revealController action:@selector(dragContentView:)];
             panGesture.cancelsTouchesInView = YES;
             [((UINavigationController *)obj2).navigationBar addGestureRecognizer:panGesture];
         }
        ];
    }
   ];
    //搜索栏控制器
    self.searchController = [[ISSTSidebarSearchViewController alloc] initWithSidebarViewController:self.revealController];
	self.searchController.view.backgroundColor = [UIColor clearColor];
    self.searchController.searchDelegate = self;
	self.searchController.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.searchController.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	self.searchController.searchBar.backgroundImage = [UIImage imageNamed:@"searchBarBG.png"];
	self.searchController.searchBar.placeholder = NSLocalizedString(@"Search", @"");
	self.searchController.searchBar.tintColor = [UIColor colorWithRed:(58.0f/255.0f) green:(67.0f/255.0f) blue:(104.0f/255.0f) alpha:1.0f];
	for (UIView *subview in self.searchController.searchBar.subviews) {
		if ([subview isKindOfClass:[UITextField class]]) {
			UITextField *searchTextField = (UITextField *) subview;
			searchTextField.textColor = [UIColor colorWithRed:(154.0f/255.0f) green:(162.0f/255.0f) blue:(176.0f/255.0f) alpha:1.0f];
		}
	}
	[self.searchController.searchBar setSearchFieldBackgroundImage:[[UIImage imageNamed:@"searchTextBG.png"]
                                                                    resizableImageWithCapInsets:UIEdgeInsetsMake(16.0f, 17.0f, 16.0f, 17.0f)]
														  forState:UIControlStateNormal];
	[self.searchController.searchBar setImage:[UIImage imageNamed:@"searchBarIcon.png"]
							 forSearchBarIcon:UISearchBarIconSearch
										state:UIControlStateNormal];

    
    self.menuController = [[ISSTMenuViewController alloc] initWithSidebarViewController:self.revealController
																		withSearchBar:self.searchController.searchBar
																		  withHeaders:header
																	  withControllers:controllers
																		withCellInfos:cellInfos];
	
     */
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
   // self.navigationController = [[[UINavigationController alloc] initWithRootViewController:homeViewController] autorelease];

    
     ISSTLoginViewController *loginViewController = [[[ISSTLoginViewController alloc] init]autorelease];
    //loginViewController.title = @"iSST";
    self.navigationController = [[[UINavigationController alloc] initWithRootViewController:loginViewController] autorelease];

    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  
//      self.window.rootViewController = self.revealController;
    self.window.rootViewController = self.navigationController ;
    [self.window makeKeyAndVisible];

    return YES;
}
/*
//搜索栏代理方法
#pragma mark GHSidebarSearchViewControllerDelegate
- (void)searchResultsForText:(NSString *)text withScope:(NSString *)scope callback:(SearchResultsBlock)callback {
	callback(@[@"Foo", @"Bar", @"Baz"]);
}

- (void)searchResult:(id)result selectedAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"Selected Search Result - result: %@ indexPath: %@", result, indexPath);
}

- (UITableViewCell *)searchResultCellForEntry:(id)entry atIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView {
	static NSString* identifier = @"ISSTSearchMenuCell";
	ISSTMenuTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (!cell) {
		cell = [[ISSTMenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
	}
	cell.textLabel.text = (NSString *)entry;
	cell.imageView.image = [UIImage imageNamed:@"user"];
	return cell;
}

*/




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
