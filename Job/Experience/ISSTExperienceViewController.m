//
//  ISSTExperenceViewController.m
//  ISST
//
//  Created by liuyang on 14-4-4.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTExperienceViewController.h"
#import "ISSTLifeApi.h"
#import "ISSTCampusNewsModel.h"
#import "ISSTPushedViewController.h"
#import "ISSTCommonCell.h"
#import "ISSTExperienceDetailViewController.h"
@interface ISSTExperienceViewController ()
@property (weak, nonatomic) IBOutlet UITableView *experienceArrayTableView;
@property (nonatomic,strong)ISSTLifeApi  *experienceApi;
@property (nonatomic,strong)ISSTCampusNewsModel  *experenceModel;
@property (strong, nonatomic)NSMutableArray *experenceArray;
@property (nonatomic,strong) ISSTExperienceDetailViewController *detailView;
//- (void)pushViewController;
//- (void)revealSidebar;
@end

@implementation ISSTExperienceViewController

@synthesize experienceApi;
@synthesize experienceArrayTableView;
@synthesize experenceModel;
@synthesize experenceArray;

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
    self.experienceApi = [[ISSTLifeApi alloc]init];
    
    self.experienceApi.webApiDelegate=self;
    // self.newsArray =[[NSMutableArray alloc]init];
    UITableView *tableView=(id)[self.view viewWithTag:2];
    tableView.rowHeight=90;
    UINib *nib=[UINib nibWithNibName:@"ISSTCommonCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:CellTableIdentifier];
    
    
	self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [self.experienceApi requestExperienceLists:1 andPageSize:20 andKeywords:@"string"];
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
    return experenceArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    experenceModel =[[ISSTCampusNewsModel alloc]init];
    experenceModel = [experenceArray objectAtIndex:indexPath.row];
    
    ISSTCommonCell *cell=(ISSTCommonCell *)[tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if (cell == nil) {
        cell = (ISSTCommonCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellTableIdentifier];
    }
    
    cell.title.text=experenceModel.title;
    cell.time.text=experenceModel.updatedAt;
    cell.content.text= experenceModel.description;
    return cell;
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.detailView=[[ISSTExperienceDetailViewController alloc]initWithNibName:@"ISSTExperienceDetailViewController" bundle:nil];
    self.detailView.navigationItem.title =@"详细信息";
   // ISSTCampusNewsModel *tempNewsModel=[[ISSTCampusNewsModel alloc]init];
  ISSTCampusNewsModel *   tempNewsModel= [experenceArray objectAtIndex:indexPath.row];
   self.detailView.experienceId=tempNewsModel.newsId;
    // [self.navigationController setNavigationBarHidden:YES];    //set system navigationbar hidden
    [self.navigationController pushViewController:self.detailView animated: NO];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark  ISSTWebApiDelegate Methods
- (void)requestDataOnSuccess:(id)backToControllerData
{
    if ([experenceArray count]) {
        experenceArray = [[NSMutableArray alloc]init];
    }
    experenceArray = (NSMutableArray *)backToControllerData;
  //  NSLog(@"count =%d ,newsArray = %@",[ExperenceArray count],ExperenceArray);
    [experienceArrayTableView reloadData];
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

//- (void)revealSidebar {
//    _revealBlock();
//}

@end
