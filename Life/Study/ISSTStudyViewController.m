//
//  ISSTStudyViewController.m
//  ISST
//
//  Created by XSZHAO on 14-4-2.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTStudyViewController.h"
#import "ISSTLifeApi.h"
#import "ISSTNewsDetailsModel.h"
#import "ISSTLoginViewController.h"
#import "ISSTCampusNewsModel.h"
#import "ISSTStudyDetailViewController.h"
#import "ISSTStudyTableViewCell.h"

@interface ISSTStudyViewController ()
@property (weak, nonatomic) IBOutlet UITableView *studyArrayTableView;
@property (nonatomic,strong)ISSTLifeApi  *studyApi;

@property (nonatomic,strong)ISSTCampusNewsModel  *studyModel;

@property(nonatomic,strong)ISSTStudyDetailViewController *studyDetailView;

@property (strong, nonatomic) NSMutableArray *studyArray;
@end

@implementation ISSTStudyViewController

@synthesize studyModel;
@synthesize studyApi;
@synthesize studyArray;
@synthesize studyArrayTableView;
@synthesize studyDetailView;
static NSString *CellTableIdentifier=@"ISSTStudyTableViewCell";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.rightBarButtonItem.image=[UIImage imageNamed:@"user.png"];
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
    self.studyApi = [[ISSTLifeApi alloc]init];
    
    self.studyApi.webApiDelegate = self;
    // self.newsArray =[[NSMutableArray alloc]init];
    UITableView *tableView=(id)[self.view viewWithTag:3];
    tableView.rowHeight=90;
    UINib *nib=[UINib nibWithNibName:@"ISSTStudyTableViewCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:CellTableIdentifier];
    
    
	self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [self.studyApi requestStudyingLists:1 andPageSize:20 andKeywords:@"string"];
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
    return studyArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    studyModel =[[ISSTCampusNewsModel alloc]init];
    studyModel = [studyArray objectAtIndex:indexPath.row];
    
    ISSTStudyTableViewCell *cell=(ISSTStudyTableViewCell *)[tableView  dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellTableIdentifier];
    }
    
    cell.title.text=[NSString stringWithFormat:@"%@",studyModel.title];
    cell.time.text=studyModel.updatedAt;
    cell.content.text= [NSString stringWithFormat:@"%@",studyModel.description];
    return cell;
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.studyDetailView=[[ISSTStudyDetailViewController alloc]initWithNibName:@"ISSTNewsDetailViewController" bundle:nil];
    self.studyDetailView.navigationItem.title=@"详细信息";
    ISSTCampusNewsModel *tempstudyModel=[[ISSTCampusNewsModel alloc]init];
    tempstudyModel= [studyArray objectAtIndex:indexPath.row];
    self.studyDetailView.studyId=tempstudyModel.newsId;
    // [self.navigationController setNavigationBarHidden:YES];    //set system navigationbar hidden
    [self.navigationController pushViewController:self.studyDetailView animated: NO];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark  ISSTWebApiDelegate Methods
- (void)requestDataOnSuccess:(id)backToControllerData
{
    if ([studyArray count]) {
        studyArray = [[NSMutableArray alloc]init];
    }
    studyArray = (NSMutableArray *)backToControllerData;
    NSLog(@"count =%d ,studyArray = %@",[studyArray count],studyArray);
    [studyArrayTableView reloadData];
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




//#pragma mark Private Methods
//- (void)pushViewController {
//    NSString *vcTitle = [self.title stringByAppendingString:@" - Pushed"];
//    UIViewController *vc = [[ISSTPushedViewController alloc] initWithTitle:vcTitle];
//    
//    [self.navigationController pushViewController:vc animated:YES];
//}


@end
