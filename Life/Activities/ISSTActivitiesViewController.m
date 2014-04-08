//
//  ISSTActivitiesViewController.m
//  ISST
//
//  Created by XSZHAO on 14-4-7.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTActivitiesViewController.h"
#import "ISSTActivityApi.h"
#import "ISSTActivityModel.h"
#import "ISSTActivityTableViewCell.h"
#import "ISSTActivityDetailViewController.h"
@interface ISSTActivitiesViewController ()

@property (weak, nonatomic) IBOutlet UITableView    *activitiesTableView;
@property (nonatomic,strong)ISSTActivityApi         *activitiesApi;
@property (nonatomic,strong)NSMutableArray          *activitiesArray;
@property (nonatomic,strong)ISSTActivityModel       *activityModel;
@property (nonatomic,strong)ISSTActivityDetailViewController    *activityDetailViewController;
@end

@implementation ISSTActivitiesViewController
static NSString *CellTableIdentifier =@"ISSTActivityTableViewCell";
@synthesize activitiesArray;
@synthesize activitiesTableView;
@synthesize activityModel;
@synthesize activitiesApi;

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
    activitiesApi = [[ISSTActivityApi alloc]init];
    self.activitiesApi.webApiDelegate = self;
    [activitiesApi requestActivitiesLists:1 andPageSize:20 andKeywords:@"string"];
    [super viewDidLoad];
   // activitiesTableView = [[UITableView alloc]init];
    activitiesTableView.rowHeight=75;
    UINib *nib=[UINib nibWithNibName:CellTableIdentifier bundle:nil];
    [activitiesTableView registerNib:nib forCellReuseIdentifier:CellTableIdentifier];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark
#pragma mark Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return activitiesArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    activityModel =[[ISSTActivityModel alloc]init];
    activityModel = [activitiesArray objectAtIndex:indexPath.row];
    
    ISSTActivityTableViewCell *cell = (ISSTActivityTableViewCell *)[tableView  dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if (cell == nil) {
        cell =(ISSTActivityTableViewCell *) [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellTableIdentifier];
    }
    
    cell.titleLabel.text=activityModel.title;
    cell.descriptionLabel.text=activityModel.description;
    
    return cell;
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.activityDetailViewController=[[ISSTActivityDetailViewController alloc]initWithNibName:@"ISSTActivityDetailViewController" bundle:nil];
    self.activityDetailViewController.navigationItem.title=@"详细信息";
    ISSTActivityModel *tmpModel = activitiesArray[indexPath.row];
    self.activityDetailViewController.activityId = tmpModel.activityId;
    [self.navigationController pushViewController:self.activityDetailViewController   animated: YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark  ISSTWebApiDelegate Methods
- (void)requestDataOnSuccess:(id)backToControllerData
{
    if ([activitiesArray count]) {
        activitiesArray = [[NSMutableArray alloc]init];
    }
    activitiesArray = (NSMutableArray *)backToControllerData;
    NSLog(@"count =%d ,studyArray = %@",[activitiesArray   count],activitiesArray);
    [activitiesTableView reloadData];
}

- (void)requestDataOnFail:(NSString *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您好:" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    
    
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
