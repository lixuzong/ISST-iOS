//
//  ISSTUserCenterViewController.m
//  ISST
//
//  Created by XSZHAO on 14-4-5.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTUserCenterViewController.h"
#import "ISSTLoginViewController.h"
@interface ISSTUserCenterViewController ()

@end

@implementation ISSTUserCenterViewController

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
                       [NSArray  arrayWithObjects:@"学生事务",nil],
                       [NSArray arrayWithObjects:@"任务中心",@"我的内推",@"我的经验",nil],
                       [NSArray  arrayWithObjects:@"活动管理",@"附近的人",nil],
                       [NSArray  arrayWithObjects:@"注销",nil],
                       nil];

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
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
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 0;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
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
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellTableIdentifier];
    }
   // cell.detailTextLabel.text =@"detail";
    cell.textLabel.text    =  [[titleForRowArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    return cell;

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  4;
}


//- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
//{
//    return nil;
//}

@end
