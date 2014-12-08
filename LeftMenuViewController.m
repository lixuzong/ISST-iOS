//
//  LeftMenuViewController.m
//  ISST
//
//  Created by rth on 14/12/3.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "ISSTNewsViewController.h"
#import "ISSTWikisCollectionViewCell.h"
#import "ISSTWikisViewController.h"
#import "ISSTActivitiesViewController.h"
#import "ISSTServiceViewController.h"
#import "ISSTStudyViewController.h"
#import "ISSTInternshipViewController.h"
#import "ISSTRecommendViewController.h"
#import "ISSTExperienceViewController.h"
#import "ISSTAddressBookViewController.h"
#import "CityManagersViewController.h"
#import "ISSTSameCityAcitvitiesViewController.h"
#import "ISSTUserCenterViewController.h"
#import "ISSTEmploymentViewController.h"
#import "AppCache.h"
#import "ISSTUserModel.h"
#import "ISSTSameCityFriendViewController.h"

@interface LeftMenuViewController (){
    ISSTUserModel *userModel;
}

@property (strong, readwrite, nonatomic) UITableView *tableView;


@end

@implementation LeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialUserModel]; //打开userModel缓存

    UIImageView *imageview =[[UIImageView alloc]initWithFrame:CGRectMake(10,(self.view.frame.size.height - 54 * 8) / 2.0f,80,80)];
    imageview.image =[UIImage imageNamed:@"login_head.png" ];
    UILabel *namelabel = [[UILabel alloc]initWithFrame:CGRectMake(110,(self.view.frame.size.height - 54 * 8) / 2.0f,80,80)];
    namelabel.text=userModel.name;
    namelabel.textColor =[UIColor whiteColor];
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - 54 * 5) / 2.0f, self.view.frame.size.width, 54 * 6) style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        tableView;
    });
    [self.view addSubview:self.tableView];
    [self.view addSubview:imageview];
    [self.view addSubview:namelabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initialUserModel{
    
    userModel = [AppCache getCache];
    
}


#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section ==0) {
    switch (indexPath.row) {
        case 0: // 软院快讯
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[ISSTNewsViewController alloc] init]]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 1: // 软院百科
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[ISSTWikisViewController alloc] init]]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 2: //在校活动
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[ISSTActivitiesViewController alloc] init]]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 3: //便捷服务
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[ISSTServiceViewController alloc] init]]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 4: //学习园地
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[ISSTStudyViewController alloc] init]]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        default:
            break;
    }
    }else if (indexPath.section ==1) {
        switch (indexPath.row) {
            case 0: // 实习
                [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[ISSTInternshipViewController alloc] init]]
                                                             animated:YES];
                [self.sideMenuViewController hideMenuViewController];
                break;
            case 1: // 就业
                [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[ISSTEmploymentViewController alloc] init]]
                                                             animated:YES];
                [self.sideMenuViewController hideMenuViewController];
                break;
            case 2: //内推
                [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[ISSTRecommendViewController alloc] init]]
                                                             animated:YES];
                [self.sideMenuViewController hideMenuViewController];
                break;
            case 3: //经验交流
                [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[ISSTExperienceViewController alloc] init]]
                                                             animated:YES];
                [self.sideMenuViewController hideMenuViewController];
                break;
            default:
                break;
        }
    }else if (indexPath.section ==2) {
        switch (indexPath.row) {
            case 0: // 通讯录
                [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[ISSTAddressBookViewController alloc] init]]
                                                             animated:YES];
                [self.sideMenuViewController hideMenuViewController];
                break;
                    default:
                break;
        }
    }else if (indexPath.section ==3) {
        switch (indexPath.row) {
            case 0: // 城主
                [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[CityManagersViewController alloc] init]]
                                                             animated:YES];
                [self.sideMenuViewController hideMenuViewController];
                break;
            case 1: // 同城活动
                [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[ISSTSameCityAcitvitiesViewController alloc] init]]
                                                             animated:YES];
                [self.sideMenuViewController hideMenuViewController];
                break;
            case 2: //同城校友
                [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[ISSTSameCityFriendViewController alloc] init]]
                                                             animated:YES];
                [self.sideMenuViewController hideMenuViewController];
                break;
            default:
                break;
        }
    }else if (indexPath.section ==4) {
        switch (indexPath.row) {
            case 0: // 个人中心
                [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[ISSTUserCenterViewController alloc] init]]
                                                             animated:YES];
                [self.sideMenuViewController hideMenuViewController];
                break;
            default:
                break;
        }
    }


}



#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section) {
        return 1.0f;
    }
    return 0.0f;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    if (sectionIndex ==0) {
        return 5;
    }
    else if (sectionIndex ==1) {
        return 4;
    }
    else if (sectionIndex ==2) {
        return 1;
    }
    else if (sectionIndex ==3) {
        return 3;
    }
    else if (sectionIndex ==4) {
        return 1;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
    
    if(indexPath.section == 0){
        NSArray *titles = @[@"软院快讯", @"软院百科", @"在校活动", @"便捷服务", @"学习园地"];
        NSArray *images = @[@"IconHome", @"IconCalendar", @"IconProfile", @"IconSettings", @"IconSettings"];
        cell.textLabel.text = titles[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:images[indexPath.row]];
    }
    else if(indexPath.section ==1){
        NSArray *titles = @[@"实习", @"就业", @"内推", @"经验交流",];
        NSArray *images = @[@"IconHome", @"IconCalendar", @"IconProfile", @"IconSettings"];
        cell.textLabel.text = titles[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:images[indexPath.row]];
    }
    else if(indexPath.section ==2){
        NSArray *titles = @[@"通讯录"];
        NSArray *images = @[@"IconHome"];
        cell.textLabel.text = titles[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:images[indexPath.row]];
    }else if (indexPath.section ==3){
        NSArray *titles = @[@"城主",@"同城活动",@"同城校友"];
        NSArray *images = @[@"IconHome",@"IconHome",@"IconHome"];
        cell.textLabel.text = titles[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:images[indexPath.row]];
    }else if (indexPath.section ==4){
        NSArray *titles = @[@"个人中心"];
        NSArray *images = @[@"IconHome"];
        cell.textLabel.text = titles[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:images[indexPath.row]];
    }
    
    return cell;
}



@end
