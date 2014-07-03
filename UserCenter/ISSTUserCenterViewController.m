//
//  ISSTUserCenterViewController.m
//  ISST
//
//  Created by XSZHAO on 14-4-5.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTUserCenterViewController.h"
#import "ISSTLoginViewController.h"
#import "ISSTUserInfoViewController.h"
#import "ISSTUserCenterUserInfoTableViewCell.h"
#import "ISSTContactsAPi.h"
#import "ISSTTasksViewController.h"
#import "ISSTMyExperienceViewController.h"
#import "AppCache.h"
#import "ISSTUserModel.h"

@interface ISSTUserCenterViewController ()
@property (weak, nonatomic) IBOutlet UITableView *userCenterCatalogueTableView;
@property (nonatomic,strong)ISSTUserInfoViewController*     userInfoViewController;
@property (nonatomic,strong)ISSTUserModel  *userModel;
@property (nonatomic,strong)ISSTContactsApi *contactsApi ;
@property (nonatomic,strong)ISSTMajorModel *majorModel;
@property (nonatomic,strong)ISSTClassModel *classModel;
@property (nonatomic,strong)NSMutableArray *classArray;
@property (nonatomic,strong)NSMutableArray *majorArray;
- (void)signOut;
- (void)go2UserInfoViewController:(NSIndexPath *)indexPath tableView:(UITableView *)tableView;
@end

@implementation ISSTUserCenterViewController

@synthesize userCenterCatalogueTableView;
@synthesize userInfoViewController;
@synthesize userModel;
@synthesize contactsApi;
@synthesize classModel;
@synthesize majorModel;
@synthesize classArray;
@synthesize majorArray;

int method;

static NSString *CellTableIdentifier=@"ISSTUserCenterViewCell";

NSArray *titleForRowArray= nil;

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
    self.contactsApi = [[ISSTContactsApi alloc]init];;
    self.contactsApi.webApiDelegate = self;
    titleForRowArray =[NSArray  arrayWithObjects:
                        [NSArray  arrayWithObjects:@"用户数据",nil],
                       [NSArray  arrayWithObjects:@"学生事务",nil],
                       [NSArray arrayWithObjects:@"任务中心",@"我的内推",@"我的经验",nil],
                       [NSArray  arrayWithObjects:@"活动管理",@"附近的人",nil],
                       [NSArray  arrayWithObjects:@"注销",nil],
                       nil];

    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    //检查缓存中是否有用户数据
    self.userModel = [AppCache getCache];
    if (userModel) {
        NSLog(@"%@" ,[userModel description]);
    }
    // if([AppCache isMenuItemsStale] || !self.menuItems) {
    
    //   [AppDelegate.engine fetchMenuItemsOnSucceeded:^(NSMutableArray
    
    //                                                *listOfModelBaseObjects) {
    
    //     self.userModel = listOfModelBaseObjects;
    
    //    [self.tableView reloadData];
    
    //  } onError:^(NSError *engineError) {
    
    //    [UIAlertView showWithError:engineError];
    
    // }];    //没有的话，从服务器获取 ,更新UI,
    // }
    // [super viewWillAppear:animated];
    
    //有缓存数据的话
    //判断数据是否过时
    //过时，从服务器获取数据  更新UI,
    //未过时，更新UI,
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
}
//go2UserInfoViewController
- (void)go2UserInfoViewController:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    ISSTUserInfoViewController *infoVC = [[ISSTUserInfoViewController alloc] init];
    [self.navigationController pushViewController:infoVC animated:YES];
    
}
//signOut
- (void)signOut
{
    ISSTLoginViewController *slider =[[ISSTLoginViewController alloc]init];
    [self.navigationController setNavigationBarHidden:YES];    //set system navigationbar hidden
    [self.navigationController pushViewController:slider animated: NO];
}

#pragma mark -
#pragma mark - UITableViewDelegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section||indexPath.row) {
        return 40.0f;
    }
    return 75.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section) {
        return 10.0f;
    }
    return 0.0f;
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 2.0f;
}
#pragma mark - Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0==indexPath.row&&0==indexPath.section) {
       
        [self go2UserInfoViewController:indexPath tableView:tableView];
    }
    
   else if (indexPath.section == [titleForRowArray count]-1&&indexPath.row == [[titleForRowArray objectAtIndex:([titleForRowArray count]-1) ] count]-1 )///logout
    {
       [self signOut];
    }
   else if (indexPath.row == 0 &&indexPath.section == 2) {
        ISSTTasksViewController *controller = [[ISSTTasksViewController alloc] init];
        [self.navigationController pushViewController:controller  animated:YES];
    }
   else if (indexPath.row == 2 &&indexPath.section == 2) {
       ISSTMyExperienceViewController *controller = [[ISSTMyExperienceViewController alloc] init];
       [self.navigationController pushViewController:controller  animated:YES];
   }
    
    
}

/*- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
*/

#pragma mark -
#pragma mark - UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   // NSLog(@"title =%@",[[titleForRowArray objectAtIndex:section] objectAtIndex:0]);
    return [[titleForRowArray objectAtIndex:section] count];

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell;
    NSLog(@"section=%d row= %ld",indexPath.section,(long)indexPath.row);
    if (indexPath.row||indexPath.section) {
        cell=[tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellTableIdentifier];
        }

        cell.imageView.image =[UIImage imageNamed:@"user.png"];
        cell.textLabel.text    =  titleForRowArray[indexPath.section][indexPath.row];
    }
    else
    {
       // UINib *nib=[UINib nibWithNibName:@"ISSTUserCenterUserInfoTableViewCell" bundle:nil];
        //[userCenterCatalogueTableView registerNib:nib forCellReuseIdentifier:@"ISSTUserCenterUserInfoTableViewCell"];
        //cell = [[UITableViewCell alloc]init;
//              cell =(ISSTUserCenterUserInfoTableViewCell *) [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        //不可重用
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ISSTUserCenterUserInfoTableViewCell" owner:self options:nil];
        
       ISSTUserCenterUserInfoTableViewCell   *userCell = (ISSTUserCenterUserInfoTableViewCell*)[nib objectAtIndex:0];
        userCell.userNameLabel.text = userModel.name;
       // userCell.userDescriptionLabel.text = userModel.description;
        cell= userCell;
    }
    return cell;

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  5;
}

//- (void)requestDataOnSuccess:(id)backToControllerData
//{
//    switch (method) {
//        case CLASSESLISTS:
//            if ([self.classArray count]) {
//                self.classArray = [[NSMutableArray alloc]init];
//            }
//            self.classArray = (NSMutableArray *)backToControllerData;
//                for(ISSTClassModel *tempModel in self.classArray)
//                {
//                    if(tempModel.classId==self.userModel.classId)
//                    {
//                        self.classModel = [[ISSTClassModel alloc] init];
//                        self.classModel = tempModel;
//                        break;
//                    }
//                }
//            method = MAJORSLISTS;
//            [self.contactsApi requestMajorsLists];
//            break;
//        case MAJORSLISTS:
//            if ([self.majorArray count]) {
//                self.majorArray = [[NSMutableArray alloc]init];
//            }
//            self.majorArray = (NSMutableArray *)backToControllerData;
//                for(ISSTMajorModel *tempModel in self.majorArray)
//                {
//                    if(tempModel.majorId==self.userModel.majorId)
//                    {
//                        self.majorModel = [[ISSTMajorModel alloc] init];
//                        self.majorModel = tempModel;
//                        break;
//                    }
//                }
//            method = CLASSESLISTS;
//            self.userInfoViewController = [[ISSTUserInfoViewController alloc]initWithNibName:@"ISSTUserInfoViewController" bundle:nil];
//            self.userInfoViewController.classInfo = self.classModel;
//            self.userInfoViewController.majorInfo = self.majorModel;
//            self.userInfoViewController.userDetailInfo = self.userModel;
//            self.userInfoViewController.navigationItem.title =@"详细信息";
//            [self.navigationController pushViewController:self.userInfoViewController   animated: NO];
//            break;
//        default:
//            break;
//    }
//}
//


//- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
//{
//    return nil;
//}

@end
