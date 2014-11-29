//
//  ISSTAddressBookDetailViewController.m
//  ISST
//
//  Created by zhukang on 14-4-13.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTAddressBookDetailViewController.h"

@interface ISSTAddressBookDetailViewController ()
@property (weak, nonatomic) IBOutlet UITableView *addressBookDetailTableView;

@end

@implementation ISSTAddressBookDetailViewController
@synthesize addressBookDetailTableView;
@synthesize userDetailInfo;
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
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark Table View  Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section) {
        return 15;
    }
    else
        return 25;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}


#pragma mark -
#pragma mark Table View Data Source Methods
//定义分组数
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
//定义分组行数
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger returnRow = 0;
    switch (section) {
        case 0:
            returnRow=4;
            break;
        case 1:
            returnRow=3;
            break;
        case 2:
            returnRow=3;
            break;
    }
    return returnRow;
}
//设置分组行头
-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionTitle;
    switch (section) {
        case 0:
            sectionTitle=@"基本信息";
            break;
        case 1:
            sectionTitle=@"联系方式";
            break;
        case 2:
            sectionTitle=@"职场信息";
            break;
        default:
            break;
    }
    return sectionTitle;
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *detailInfoTableIdentifier=@"ISSTAddressBookDetailTableViewCell";
  //  ISSTAddressBookDetailTableViewCell *cell  = (ISSTAddressBookDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:detailInfoTableIdentifier];
   
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ISSTAddressBookDetailTableViewCell" owner:self options:nil];
    ISSTAddressBookDetailTableViewCell *cell  = [nib objectAtIndex:0];
    
    switch (indexPath.section) {
        case 0:
        {
            
            switch (indexPath.row) {
                case 0:
                {
                    cell.contentLabel.text=userDetailInfo.name;
                    cell.titleLabel.text=@"姓名";
                    break;
                }
                case 1:
                {
                    if(userDetailInfo.gender==1)
                        cell.contentLabel.text=@"男";
                    else cell.contentLabel.text=@"女";
                    cell.titleLabel.text=@"性别";
                    break;
                }
                case 2:
                {
                    cell.contentLabel.text=userDetailInfo.className;
                    cell.titleLabel.text=@"班级";
                    break;
                }
                case 3:
                {
                    cell.contentLabel.text=userDetailInfo.majorName;
                    cell.titleLabel.text=@"专业方向";
                    break;
                }
                default:
                    break;
            }
            
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    cell.contentLabel.text=userDetailInfo.phone;
                    cell.titleLabel.text=@"手机";
                    break;
                }
                case 1:
                {
                    cell.contentLabel.text=userDetailInfo.qq;
                    cell.titleLabel.text=@"QQ";
                    break;
                }
                case 2:
                {
                    cell.contentLabel.text=userDetailInfo.email;
                    cell.titleLabel.text=@"E-mail";
                    break;
                }
                default:
                    break;
            }

        }
            
            break;
            
        case 2:
        {
            switch (indexPath.row) {
                case 0:
                {
                    cell.contentLabel.text=[NSString stringWithFormat:@"%@",userDetailInfo.cityName];
                    cell.titleLabel.text=@"所在城市";
                    break;
                }
                case 1:
                {
                    cell.contentLabel.text=userDetailInfo.company;
                    cell.titleLabel.text=@"工作单位";
                    break;
                }
                case 2:
                {
                    cell.contentLabel.text=userDetailInfo.position;
                    cell.titleLabel.text=@"职位";
                    break;
                }
                default:
                    break;
            }

            
        }
            break;
            
        default:
            break;
    }
    return cell;

}

@end
