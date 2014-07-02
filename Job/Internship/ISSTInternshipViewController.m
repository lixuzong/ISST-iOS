//
//  ISSTEmploymentViewController.m
//  ISST
//
//  Created by liuyang on 14-4-15.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTInternshipViewController.h"
#import "ISSTCommonCell.h"
#import "ISSTPushedViewController.h"
#import "ISSTJobsApi.h"
#import "ISSTJobsModel.h"
#import "ISSTInternshipDetailViewController.h"

@interface ISSTInternshipViewController ()
@property (weak, nonatomic) IBOutlet UITableView *internshipTableView;
@property (nonatomic,strong)ISSTJobsApi  *internshipApi;
@property (nonatomic,strong)ISSTJobsModel  *internshipModel;
@property (strong, nonatomic)NSMutableArray *internshipArray;
@property (nonatomic,strong) ISSTInternshipDetailViewController *detailView;
@end

@implementation ISSTInternshipViewController
@synthesize internshipTableView;
@synthesize internshipApi;
@synthesize internshipModel;
@synthesize internshipArray;
@synthesize detailView;
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
    self.internshipApi = [[ISSTJobsApi alloc]init];
    
    self.internshipApi.webApiDelegate=self;
    // self.newsArray =[[NSMutableArray alloc]init];
    //UITableView *tableView=(id)[self.view viewWithTag:99];
    internshipTableView.rowHeight=90;
    UINib *nib=[UINib nibWithNibName:@"ISSTCommonCell" bundle:nil];
    [internshipTableView registerNib:nib forCellReuseIdentifier:CellTableIdentifier];
    
    
	self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [self.internshipApi requestInternshipLists:1 andPageSize:20 andKeywords:@"string"];
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
    return internshipArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    internshipModel =[[ISSTJobsModel alloc]init];
    internshipModel = [internshipArray objectAtIndex:indexPath.row];
    
    ISSTCommonCell *cell=(ISSTCommonCell *)[tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if (cell == nil) {
        cell = (ISSTCommonCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellTableIdentifier];
    }
    
    cell.title.text=internshipModel.title;
    cell.time.text=internshipModel.updatedAt;
    cell.content.text=internshipModel.description;
    return cell;
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.detailView=[[ISSTInternshipDetailViewController alloc]initWithNibName:@"ISSTInternshipDetailViewController" bundle:nil];
    self.detailView.navigationItem.title =@"详细信息";
    ISSTJobsModel *  tempModel= [internshipArray objectAtIndex:indexPath.row];
    self.detailView.internshipId=tempModel.messageId;
    // [self.navigationController setNavigationBarHidden:YES];    //set system navigationbar hidden
    [self.navigationController pushViewController:detailView animated: NO];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark  ISSTWebApiDelegate Methods
- (void)requestDataOnSuccess:(id)backToControllerData
{
    if ([internshipArray count]) {
        internshipArray = [[NSMutableArray alloc]init];
    }
    internshipArray = (NSMutableArray *)backToControllerData;
    //  NSLog(@"count =%d ,newsArray = %@",[ExperenceArray count],ExperenceArray);
    [internshipTableView reloadData];
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
