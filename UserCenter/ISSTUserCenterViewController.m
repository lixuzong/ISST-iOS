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
#import "ISSTTaskViewController.h"
#import "ISSTMyExperienceViewController.h"
#import "AppCache.h"
#import "ISSTUserModel.h"
#import "passValue.h"
#import "ISSTFeedbackViewController.h"
#import "RESideMenu.h"
#import "ISSTAboutViewController.h"
#import "ISSTMyRecListViewController.h"
#import "ISSTPushViewController.h"
#import "ZBarViewController.h"

@interface ISSTUserCenterViewController ()
@property (weak, nonatomic) IBOutlet UITableView *userCenterCatalogueTableView;
@property (nonatomic,strong)ISSTUserInfoViewController*     userInfoViewController;
@property (nonatomic,strong)ISSTUserModel  *userModel;
@property (nonatomic,strong)ISSTContactsApi *contactsApi ;
@property (nonatomic,strong)ISSTMajorModel *majorModel;
@property (nonatomic,strong)ISSTClassModel *classModel;
@property (nonatomic,strong)NSMutableArray *classArray;
@property (nonatomic,strong)NSMutableArray *majorArray;
@property (nonatomic,strong)ISSTFeedbackViewController  *feedbackViewController;
@property (nonatomic,strong)ISSTAboutViewController     *aboutViewController;

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
@synthesize feedbackViewController;
@synthesize aboutViewController;


int method;

static NSString *CellTableIdentifier=@"ISSTUserCenterViewCell";

NSArray *titleForRowArray= nil;
NSArray *imageForRowArray= nil;

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
    self.title = @"个人中心";
    
    self.contactsApi = [[ISSTContactsApi alloc]init];;
    self.contactsApi.webApiDelegate = self;
    titleForRowArray =[NSArray  arrayWithObjects:
                       [NSArray  arrayWithObjects:@"用户数据",nil],
                       [NSArray  arrayWithObjects:@"任务中心",nil],
                       [NSArray arrayWithObjects:@"我的内推",@"我的经验",@"重要信息",@"意见反馈",nil],
                       [NSArray  arrayWithObjects:@"活动管理",@"附近的人",@"扫码签到",nil],
                       [NSArray  arrayWithObjects:@"关于",nil],
                       [NSArray  arrayWithObjects:@"注销",nil],
                       nil];

    imageForRowArray =[NSArray  arrayWithObjects:
                       [NSArray  arrayWithObjects:@"个人中心icon.png",nil],
                       [NSArray  arrayWithObjects:@"实习icon.png",nil],
                       [NSArray arrayWithObjects:@"软院百科icon.png",@"内推icon.png",@"经验交流icon.png",@"经验交流icon.png",@"经验交流icon.png",nil],
                       [NSArray  arrayWithObjects:@"在校活动icon.png",@"通讯录icon.png",nil],
                       [NSArray  arrayWithObjects:@"便捷服务icon.png",nil],
                       nil];
    [super viewDidLoad];
    
    //判断是否有推送
    if(pushtag)
    {
        
        pushtag=0;
        //        [UIView beginAnimations:@"push" context:nil];
        //        [UIView setAnimationDuration:0.5];
        [self.navigationController pushViewController:[[ISSTPushViewController alloc]init] animated:NO];
//        [self.navigationController pushViewController:[[ISSTMyExperienceViewController alloc]init] animated:NO];
        //        [UIView commitAnimations];
    }

    //self.view.scrollEnabled =YES;
    
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
    //passValue *passValue = [[passalloc] init];
    passValue *passvalue = [[passValue alloc] init];
    passvalue.signOutFlag = @"1";
    pushbind=1;
    slider.passvalue=passvalue;
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
   else if (indexPath.row == 0 &&indexPath.section == 1) { //任务中心
//        ISSTTaskViewController *controller = [[ISSTTaskViewController alloc] init];
//        [self.navigationController pushViewController:controller  animated:YES];
       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"亲，该功能尚未开通！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
       alert.delegate = self;
       [alert show];
    }
   else if (indexPath.row == 1 &&indexPath.section == 2) { //我的经验
       ISSTMyExperienceViewController *controller = [[ISSTMyExperienceViewController alloc] init];
       [self.navigationController pushViewController:controller  animated:YES];
   }
   else if (indexPath.row ==0 && indexPath.section == 2 ){ //我的内推板块
       ISSTMyRecListViewController *controller=[[ISSTMyRecListViewController alloc] init];
       [self.navigationController pushViewController:controller animated:YES];
   }
   else if (indexPath.row ==2 && indexPath.section == 2){ //重要信息板块，还没做 0.0
       ISSTPushViewController *push=[[ISSTPushViewController alloc]init];
       [self.navigationController pushViewController:push animated:YES];
   }
   else if (indexPath.row ==3 && indexPath.section ==2){ //意见反馈板块
       feedbackViewController = [[ISSTFeedbackViewController alloc]init];
       [self.navigationController pushViewController:feedbackViewController animated:YES];
   }
   else if (indexPath.row == 0 && indexPath.section==3){ //活动管理板块，还没做 0.0
       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"亲，该功能尚未开通！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
       alert.delegate = self;
       [alert show];
   }
   else if (indexPath.row == 1 && indexPath.section==3){ //附近的人板块，还没做 0.0
       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"亲，该功能尚未开通！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
       alert.delegate = self;
       [alert show];
   }
   else if (indexPath.row == 2 && indexPath.section==3){
//       ZBarViewController *saoma=[[ZBarViewController alloc] init];
//       saoma.title=@"扫码签到";
//       [self.navigationController pushViewController:saoma animated:YES];
       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"亲，该功能尚未开通！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
       alert.delegate = self;
       [alert show];

   }
   else if (indexPath.row == 0 && indexPath.section==4){ //关于
       aboutViewController = [[ISSTAboutViewController alloc] init];
       [self.navigationController pushViewController:aboutViewController  animated:YES];
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
    
    if (indexPath.row||indexPath.section) {
        cell=[tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellTableIdentifier];
        }
        //cell.imageView.image =[UIImage imageNamed:@"user.png"];
        //cell.imageView.image =[UIImage imageNamed:imageForRowArray[indexPath.section][indexPath.row]];// 个人中心icon的获取
        //NSLog(@“%d”，titleForRowArray[indexPath.section][indexPath.row]);
        cell.textLabel.text    =  titleForRowArray[indexPath.section][indexPath.row];
        cell.textLabel.textAlignment =NSTextAlignmentCenter;
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
    return  6;
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
