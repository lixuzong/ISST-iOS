//
//  ISSTExperenceViewController.m
//  ISST
//
//  Created by liuyang on 14-4-4.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTExperenceViewController.h"
#import "ISSTNewsApi.h"
#import "ISSTCampusNewsModel.h"
#import "ISSTPushedViewController.h"
#import "ISSTExperenceTableViewCell.h"
@interface ISSTExperenceViewController ()
@property (weak, nonatomic) IBOutlet UITableView *ExperenceArrayTableView;
@property (nonatomic,strong)ISSTNewsApi  *ExperenceApi;
@property (nonatomic,strong)ISSTCampusNewsModel  *ExperenceModel;
@property (strong, nonatomic)NSMutableArray *ExperenceArray;
- (void)pushViewController;
- (void)revealSidebar;
@end

@implementation ISSTExperenceViewController
{
@private
    RevealBlock _revealBlock;
}
@synthesize ExperenceApi;
@synthesize ExperenceArrayTableView;
@synthesize ExperenceModel;
@synthesize ExperenceArray;
static NSString *CellTableIdentifier=@"ISSTExperenceTableViewCell";
#pragma mark Memory Management
- (id)initWithTitle:(NSString *)title withRevealBlock:(RevealBlock)revealBlock {
    if (self = [super initWithNibName:nil bundle:nil]) {
		self.title = title;
		_revealBlock = [revealBlock copy];
		self.navigationItem.leftBarButtonItem =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                      target:self
                                                      action:@selector(revealSidebar)];
        
	}
	return self;
}

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
    self.ExperenceApi = [[ISSTNewsApi alloc]init];
    
    self.ExperenceApi.webApiDelegate=self;
    // self.newsArray =[[NSMutableArray alloc]init];
    UITableView *tableView=(id)[self.view viewWithTag:2];
    tableView.rowHeight=90;
    UINib *nib=[UINib nibWithNibName:@"ISSTExperenceTableViewCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:CellTableIdentifier];
    
    
	self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [self.ExperenceApi requestExperence:1 andPageSize:20 andKeywords:@"string"];
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
    return ExperenceArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ExperenceModel =[[ISSTCampusNewsModel alloc]init];
    ExperenceModel = [ExperenceArray objectAtIndex:indexPath.row];
    
    ISSTExperenceTableViewCell *cell=(ISSTExperenceTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellTableIdentifier];
    }
    
    cell.Title.text=[NSString stringWithFormat:@"%@",ExperenceModel.title];
    cell.Time.text=ExperenceModel.updatedAt;
    cell.Content.text= [NSString stringWithFormat:@"%@",ExperenceModel.description];
    return cell;
}
//#pragma mark - Table view delegate
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    self.DetailView=[[ISSTNewsDetailViewController alloc]initWithNibName:@"ISSTNewsDetailViewController" bundle:nil];
//    self.newsDetailView.title=@"详细信息";
//    ISSTCampusNewsModel *tempNewsModel=[[ISSTCampusNewsModel alloc]init];
//    tempNewsModel= [newsArray objectAtIndex:indexPath.row];
//    self.newsDetailView.newsId=tempNewsModel.newsId;
//    // [self.navigationController setNavigationBarHidden:YES];    //set system navigationbar hidden
//    [self.navigationController pushViewController:self.newsDetailView animated: NO];
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}

#pragma mark -
#pragma mark  ISSTWebApiDelegate Methods
- (void)requestDataOnSuccess:(id)backToControllerData
{
    if ([ExperenceArray count]) {
        ExperenceArray = [[NSMutableArray alloc]init];
    }
    ExperenceArray = (NSMutableArray *)backToControllerData;
    NSLog(@"count =%d ,newsArray = %@",[ExperenceArray count],ExperenceArray);
    [ExperenceArrayTableView reloadData];
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

- (void)revealSidebar {
    _revealBlock();
}

@end
