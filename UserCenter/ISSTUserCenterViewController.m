//
//  ISSTUserCenterViewController.m
//  ISST
//
//  Created by XSZHAO on 14-4-5.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTUserCenterViewController.h"
#import "ISSTLoginViewController.h"
#import "ISSTUserCenterUserInfoTableViewCell.h"
#import "ISSTUserInfoViewController.h"
@interface ISSTUserCenterViewController ()
@property (weak, nonatomic) IBOutlet UITableView *userCenterCatalogueTableView;
@property (nonatomic,strong)ISSTUserInfoViewController*     userInfoViewController;
- (void)signOut;
- (void)go2UserInfoViewController:(NSIndexPath *)indexPath tableView:(UITableView *)tableView;
@end

@implementation ISSTUserCenterViewController
@synthesize userCenterCatalogueTableView;
@synthesize userInfoViewController;
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
    titleForRowArray =[NSArray  arrayWithObjects:
                        [NSArray  arrayWithObjects:@"用户数据",nil],
                       [NSArray  arrayWithObjects:@"学生事务",nil],
                       [NSArray arrayWithObjects:@"任务中心",@"我的内推",@"我的经验",nil],
                       [NSArray  arrayWithObjects:@"活动管理",@"附近的人",nil],
                       [NSArray  arrayWithObjects:@"注销",nil],
                       nil];

    [super viewDidLoad];

 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
}
//go2UserInfoViewController
- (void)go2UserInfoViewController:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    self.userInfoViewController = [[ISSTUserInfoViewController alloc]initWithNibName:@"ISSTUserInfoViewController" bundle:nil];
      self.userInfoViewController.navigationItem.title =@"详细信息";
    [self.navigationController pushViewController:self.userInfoViewController   animated: NO];
   [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
//    self.newsDetailView=[[ISSTNewsDetailViewController alloc]initWithNibName:@"ISSTNewsDetailViewController" bundle:nil];
//    self.newsDetailView.navigationItem.title =@"详细信息";
//    ISSTCampusNewsModel *tempNewsModel=[[ISSTCampusNewsModel alloc]init];
//    tempNewsModel= [newsArray objectAtIndex:indexPath.row];
//    self.newsDetailView.newsId=tempNewsModel.newsId;
//    [self.navigationController pushViewController:self.newsDetailView animated: NO];
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (0==indexPath.row&&0==indexPath.section) {
       
        [self go2UserInfoViewController:indexPath tableView:tableView];
    }
    
    if (indexPath.section == [titleForRowArray count]-1&&indexPath.row == [[titleForRowArray objectAtIndex:([titleForRowArray count]-1) ] count]-1 )///logout
    {
        [self signOut];
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
    NSLog(@"section=%d row= %d",indexPath.section,indexPath.row);
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
        cell = [nib objectAtIndex:0];
        
    }
    return cell;

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  5;
}


//- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
//{
//    return nil;
//}

@end
