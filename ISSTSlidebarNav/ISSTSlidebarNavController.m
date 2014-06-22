//
//  ISSTSlidebarNavController.m
//  ISST
//
//  Created by XSZHAO on 14-3-22.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTSlidebarNavController.h"
#import "ISSTRevealViewController.h"
#import "ISSTMenuViewController.h"
#import "ISSTRootViewController.h"
#import "ISSTMenuTableViewCell.h"
#import "ISSTLoginViewController.h"
#import "ISSTStudyViewController.h"
#import "ISSTServiceViewController.h"
#import "ISSTAddressBookViewController.h"

#import "ISSTExperienceViewController.h"
#import "ISSTWikisViewController.h"
#import "ISSTActivitiesViewController.h"
#import "ISSTEmploymentViewController.h"
#import "ISSTInternshipViewController.h"
#import "ISSTRecommendViewController.h"
#import "CityManagersViewController.h"
#import "ISSTSameCityAcitvitiesViewController.h"
//#import "ISSTSidebarSearchViewController.h"
//#import "ISSTSidebarSearchViewControllerDelegate.h"

#import "ISSTNewsViewController.h"
#import "ISSTUserCenterViewController.h"
@interface ISSTSlidebarNavController ()//<ISSTSidebarSearchViewControllerDelegate>
@property (nonatomic, strong) ISSTRevealViewController *revealController;
//搜索栏控制器
//@property (nonatomic, strong) ISSTSidebarSearchViewController *searchController;

@property (nonatomic, strong) ISSTMenuViewController       *menuController;
@end


@implementation ISSTSlidebarNavController


/*- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

- (void)viewDidLoad
{  [self viewSlidebarLoad];
   [super viewDidLoad];
     //self.navigationItem.title=@"321";
   // self.navigationItem.leftBarButtonItem.
   // self.navigationController.navigationBar.hidden =YES;
  //  [self.navigationController popToRootViewControllerAnimated:YES];
    // [self.navigationController removeFromParentViewController];
    //[self.navigationController pushViewController:self.revealController animated:YES];

    //[self viewSlidebarLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewSlidebarLoad
{
    if ([UIDevice currentDevice].systemVersion.doubleValue <= 7.0) {
          [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
    }
    else
    {
      [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    }
  
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
    ISSTAddressBookViewController *sameCityAddressBook = [[ISSTAddressBookViewController alloc] initWithTitle:@"同城校友" withRevealBlock:revealBlock];
    sameCityAddressBook.sameCitySwitch =true;

    NSArray *controllers = @[
                             @[
                                 
                                 [[UINavigationController alloc] initWithRootViewController:[[ISSTNewsViewController alloc] initWithTitle:@"软院快讯" withRevealBlock:revealBlock]],
                                 [[UINavigationController alloc] initWithRootViewController:[[ISSTWikisViewController alloc] initWithTitle:@"软院百科" withRevealBlock:revealBlock]],
                                 [[UINavigationController alloc] initWithRootViewController:[[ISSTActivitiesViewController alloc] initWithTitle:@"在校活动" withRevealBlock:revealBlock]],
                                 [[UINavigationController alloc] initWithRootViewController:[[ISSTServiceViewController alloc] initWithTitle:@"便捷服务" withRevealBlock:revealBlock]],
                                 [[UINavigationController alloc] initWithRootViewController:[[ISSTStudyViewController alloc] initWithTitle:@"学习园地" withRevealBlock:revealBlock]]
                                 ],
                             @[
                                 [[UINavigationController alloc] initWithRootViewController:[[ISSTInternshipViewController alloc] initWithTitle:@"实习" withRevealBlock:revealBlock]],
                                 [[UINavigationController alloc] initWithRootViewController:[[ISSTEmploymentViewController alloc] initWithTitle:@"就业" withRevealBlock:revealBlock]],
                                 [[UINavigationController alloc] initWithRootViewController:[[ISSTRecommendViewController alloc] initWithTitle:@"内推" withRevealBlock:revealBlock]],
                                 [[UINavigationController alloc] initWithRootViewController:[[ISSTExperienceViewController alloc] initWithTitle:@"经验交流" withRevealBlock:revealBlock]]
                                 ],
                             @[
                                 [[UINavigationController alloc] initWithRootViewController:[[ISSTAddressBookViewController alloc] initWithTitle:@"通讯录" withRevealBlock:revealBlock]]
                                 ],
                             @[
                                 [[UINavigationController alloc] initWithRootViewController:[[CityManagersViewController alloc] initWithTitle:@"城主" withRevealBlock:revealBlock]],
                                 [[UINavigationController alloc] initWithRootViewController:[[ISSTSameCityAcitvitiesViewController alloc] initWithTitle:@"同城活动" withRevealBlock:revealBlock]],
                                 [[UINavigationController alloc] initWithRootViewController:sameCityAddressBook]
                                 ],
                             @[
                                 [[UINavigationController alloc] initWithRootViewController:[[ISSTUserCenterViewController alloc] initWithTitle:@"个人中心" withRevealBlock:revealBlock]]
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
                               @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: NSLocalizedString(@"个人中心", @"")}
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
  /*  self.searchController = [[ISSTSidebarSearchViewController alloc] initWithSidebarViewController:self.revealController];
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
    
    */
    //UIImage *image =[UIImage imageNamed:@"user.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user.png"]];
    self.menuController = [[ISSTMenuViewController alloc] initWithSidebarViewController:self.revealController
                                                                          withImageView:imageView
                                                                            withHeaders:header
                                                                        withControllers:controllers
                                                                          withCellInfos:cellInfos];
    
    //UINavigationController *navigation =[[UINavigationController alloc]initWithRootViewController:self.revealController];
    [self.navigationController pushViewController:self.revealController animated:YES];
     
}


/*
//搜索栏代理方法
#pragma mark GHSidebarSearchViewControllerDelegate
- (void)searchResultsForText:(NSString *)text withScope:(NSString *)scope callback:(SearchResultsBlock)callback {
	//callback(@[@"Foo", @"Bar", @"Baz"]);
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


@end
