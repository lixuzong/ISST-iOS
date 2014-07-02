//
//  ISSTEmploymentViewController.m
//  ISST
//
//  Created by liuyang on 14-4-15.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTEmploymentViewController.h"
#import "ISSTCommonCell.h"
#import "ISSTEmploymentDetailViewController.h"
#import "ISSTPushedViewController.h"
#import "ISSTJobsApi.h"
#import "ISSTJobsModel.h"
@interface ISSTEmploymentViewController ()
@property (weak, nonatomic) IBOutlet UITableView *employTableView;
@property (nonatomic,strong)ISSTJobsApi  *employmentApi;
@property (nonatomic,strong)ISSTJobsModel  *employmentModel;
@property (strong, nonatomic)NSMutableArray *employmentArray;
@property (nonatomic,strong) ISSTEmploymentDetailViewController *detailView;
@end

@implementation ISSTEmploymentViewController
@synthesize employmentModel;
@synthesize employmentApi;
@synthesize employmentArray;
@synthesize employTableView;
static NSString *CellTableIdentifier=@"ISSTCommonCell";


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
    self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	self.view.backgroundColor = [UIColor lightGrayColor];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [super viewDidLoad];
    self.employmentApi = [[ISSTJobsApi alloc]init];
    
    self.employmentApi.webApiDelegate=self;
    // self.newsArray =[[NSMutableArray alloc]init];
    //UITableView *tableView=(id)[self.view viewWithTag:99];
    employTableView.rowHeight=90;
    UINib *nib=[UINib nibWithNibName:@"ISSTCommonCell" bundle:nil];
    [employTableView registerNib:nib forCellReuseIdentifier:CellTableIdentifier];
    
    
	self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [self.employmentApi requestEmploymentLists:1 andPageSize:20 andKeywords:@"string"];
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
    return employmentArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    employmentModel =[[ISSTJobsModel alloc]init];
    employmentModel = [employmentArray objectAtIndex:indexPath.row];
    
    ISSTCommonCell *cell=(ISSTCommonCell *)[tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if (cell == nil) {
        cell = (ISSTCommonCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellTableIdentifier];
    }
    
    cell.title.text=employmentModel.title;
    cell.time.text=employmentModel.updatedAt;
    cell.content.text=employmentModel.description;
    return cell;
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.detailView=[[ISSTEmploymentDetailViewController alloc]initWithNibName:@"ISSTEmploymentDetailViewController" bundle:nil];
    self.detailView.navigationItem.title =@"就业信息详情";
 //  ISSTJobsModel *tempEmploymentModel=[[ISSTJobsModel alloc]init];
   ISSTJobsModel *  tempEmploymentModel= [employmentArray objectAtIndex:indexPath.row];
    self.detailView.employmentId=tempEmploymentModel.messageId;
    // [self.navigationController setNavigationBarHidden:YES];    //set system navigationbar hidden
    [self.navigationController pushViewController:self.detailView animated: NO];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark  ISSTWebApiDelegate Methods
- (void)requestDataOnSuccess:(id)backToControllerData
{
    if ([employmentArray count]) {
        employmentArray = [[NSMutableArray alloc]init];
    }
    employmentArray = (NSMutableArray *)backToControllerData;
    //  NSLog(@"count =%d ,newsArray = %@",[ExperenceArray count],ExperenceArray);
    [employTableView reloadData];
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

#pragma mark Private Methods
- (void)pushViewController {
    NSString *vcTitle = [self.title stringByAppendingString:@" - Pushed"];
    UIViewController *vc = [[ISSTPushedViewController alloc] initWithTitle:vcTitle];
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
