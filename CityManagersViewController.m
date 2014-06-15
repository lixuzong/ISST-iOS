//
//  CityManagersViewController.m
//  ISST
//
//  Created by apple on 14-4-27.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "CityManagersViewController.h"
#import "ISSTUserModel.h"
#import "ISSTSameCitiesApi.h"
#import "AppCache.h"
#import "ISSTSameCitiesModel.h"
#import "ISSTAddressBookDetailTableViewCell.h"
@interface CityManagersViewController ()
@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (weak, nonatomic) IBOutlet UITableView *cityManagerTableView;
@property (copy,nonatomic) ISSTUserModel *userInfo;
@property (copy,nonatomic)ISSTSameCitiesApi *sameCityApi;
@property (copy,nonatomic)ISSTSameCitiesModel *cityManagerModel;
@property (copy,nonatomic)NSMutableArray *cityManagerModelArray;
@property (copy,nonatomic)UITableView *cityListsTableView;
@property (copy,nonatomic)NSMutableArray *cityListsArray;
@end

@implementation CityManagersViewController
@synthesize cityNameLabel;
@synthesize cityManagerTableView;
@synthesize userInfo;
@synthesize sameCityApi;
@synthesize cityManagerModel;
@synthesize cityManagerModelArray;
@synthesize cityListsTableView;
@synthesize cityListsArray;
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
    sameCityApi = [[ISSTSameCitiesApi alloc] init];
    sameCityApi.webApiDelegate = self;
    
    userInfo = [[ISSTUserModel alloc] init];
    userInfo = [AppCache getCache];
    cityNameLabel.text = userInfo.cityName;
    
    cityListsArray = [[NSMutableArray alloc] init];
    cityManagerModel = [[ISSTSameCitiesModel alloc] init];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"切换城市" style:UIBarButtonSystemItemEdit target:self action:@selector(choseCityClick)];
    
    [sameCityApi requestSameCitiesLists:0 andPageSize:20];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)choseCityClick
{
    [self.view addSubview:cityListsTableView];
    [cityListsTableView reloadData];
}

-(void)reloadData
{
    for(ISSTSameCitiesModel *tempModel in cityManagerModelArray)
    {
        if([tempModel.cityName isEqualToString:cityNameLabel.text])
        {
            cityManagerModel = tempModel;
            break;
        }
    }
    [cityManagerTableView reloadData];
}
#pragma mark -
#pragma mark  ISSTWebApiDelegate Methods
- (void)requestDataOnSuccess:(id)backToControllerData
{
    cityManagerModelArray = backToControllerData;
    for(ISSTSameCitiesModel *tempModel in cityManagerModelArray)
        [cityListsArray addObject:tempModel.cityName];
    cityListsTableView = [[UITableView alloc] initWithFrame:CGRectMake(240 , 0, 80, 20*cityListsArray.count)];
    cityListsTableView.dataSource = self;
    cityListsTableView.delegate = self;
    
    [self reloadData];
}
    
- (void)requestDataOnFail:(NSString *)error
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您好:" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }


#pragma mark -
#pragma mark Table View  Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    int height = 0;
    if(tableView == cityManagerTableView)
    {
        if (section) {
            height = 15;
        }
        else
           height = 25;
    }
    return height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    int height = 0;
    if(tableView == cityManagerTableView)
        height = 10;
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int height = 20;
    if(tableView == cityManagerTableView)
        height = 40;
    return height;
}


#pragma mark -
#pragma mark Table View Data Source Methods
//定义分组数
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//定义分组行数
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger returnRow = 0;
    if(tableView == cityManagerTableView)
           returnRow = 6;
    else if(tableView == cityListsTableView)
        returnRow = cityListsArray.count;
    return returnRow;
}
//设置分组行头
-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(tableView == cityManagerTableView)
    {
        NSString *sectionTitle=@"城主信息";

        return sectionTitle;
    }
    else
        return nil;
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if(tableView == cityManagerTableView)
    {
        static NSString *detailInfoTableIdentifier=@"ISSTAddressBookDetailTableViewCell";
    //  ISSTAddressBookDetailTableViewCell *cell  = (ISSTAddressBookDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:detailInfoTableIdentifier];
    
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ISSTAddressBookDetailTableViewCell" owner:self options:nil];
        cell  = [nib objectAtIndex:0];
    
        switch (indexPath.row) {
            case 0:
                ((ISSTAddressBookDetailTableViewCell *)cell).titleLabel.text = @"姓名";
                ((ISSTAddressBookDetailTableViewCell *)cell).contentLabel.text = cityManagerModel.userModel.name;
            
                break;
            case 1:
                ((ISSTAddressBookDetailTableViewCell *)cell).titleLabel.text = @"邮箱";
                ((ISSTAddressBookDetailTableViewCell *)cell).contentLabel.text = cityManagerModel.userModel.email;

                break;
            case 2:
                ((ISSTAddressBookDetailTableViewCell *)cell).titleLabel.text = @"电话";
                ((ISSTAddressBookDetailTableViewCell *)cell).contentLabel.text = cityManagerModel.userModel.phone;

                break;
            case 3:
                ((ISSTAddressBookDetailTableViewCell *)cell).titleLabel.text = @"QQ";
                ((ISSTAddressBookDetailTableViewCell *)cell).contentLabel.text = cityManagerModel.userModel.qq;
                
                break;
            case 4:
                ((ISSTAddressBookDetailTableViewCell *)cell).titleLabel.text = @"公司";
                ((ISSTAddressBookDetailTableViewCell *)cell).contentLabel.text = cityManagerModel.userModel.company;

                break;
            case 5:
                ((ISSTAddressBookDetailTableViewCell *)cell).titleLabel.text = @"职位";
                ((ISSTAddressBookDetailTableViewCell *)cell).contentLabel.text = cityManagerModel.userModel.position;

                break;

            default:
                break;
        }
    }
     else if(tableView ==cityListsTableView)
    {
        static NSString* cityListIdentifier = @"UITableViewCell";
        cell=(UITableViewCell *)[tableView  dequeueReusableCellWithIdentifier:cityListIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cityListIdentifier];
        }
        cell.textLabel.text = [cityListsArray objectAtIndex:indexPath.row];
    }
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == cityListsTableView)
    {
        cityNameLabel.text = [cityListsArray objectAtIndex:indexPath.row];
        [self reloadData];
        [cityListsTableView removeFromSuperview];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
