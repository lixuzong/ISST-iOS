//
//  GoViewController.m
//  ISST
//
//  Created by XSZHAO on 14-3-20.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//
#import "ISSTNewsDetailViewController.h"
#import "ISSTNewsViewController.h"
#import "ISSTLifeApi.h"
#import "ISSTNewsTableViewCell.h"
#import "ISSTCampusNewsModel.h"

@interface ISSTNewsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *newsArrayTableView;
@property (nonatomic,strong)ISSTLifeApi  *newsApi;

@property (nonatomic,strong) ISSTCampusNewsModel  *newsModel;

@property(nonatomic,strong)ISSTNewsDetailViewController *newsDetailView;

@property (strong, nonatomic) NSMutableArray *newsArray;

//- (void)pushViewController;
//- (void)revealSidebar;
@end

@implementation ISSTNewsViewController

@synthesize newsModel;
@synthesize newsApi;
@synthesize newsArray;
@synthesize newsArrayTableView;
@synthesize newsDetailView;
static NSString *CellTableIdentifier=@"ISSTNewsTableViewCell";




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
    self.newsApi = [[ISSTLifeApi alloc]init];
    self.newsApi.webApiDelegate = self;
    [self.newsApi requestCampusNewsLists:1 andPageSize:20 andKeywords:@"string"];
    self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	self.view.backgroundColor = [UIColor lightGrayColor];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [super viewDidLoad];
  
    UITableView *tableView=(id)[self.view viewWithTag:1];
    tableView.rowHeight=80;
    UINib *nib=[UINib nibWithNibName:@"ISSTNewsTableViewCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:CellTableIdentifier];

    
	self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
    return newsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    newsModel =[[ISSTCampusNewsModel alloc]init];
    newsModel = [newsArray objectAtIndex:indexPath.row];
    
    ISSTNewsTableViewCell *cell=(ISSTNewsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if (cell == nil) {
        cell = (ISSTNewsTableViewCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellTableIdentifier];
    }

    cell.title.text     =   newsModel.title;
    cell.time.text      =   newsModel.updatedAt;
    cell.content.text   =   newsModel.description;
    return cell;
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.newsDetailView=[[ISSTNewsDetailViewController alloc]initWithNibName:@"ISSTNewsDetailViewController" bundle:nil];
    self.newsDetailView.navigationItem.title =@"详细信息";
  //  ISSTCampusNewsModel *tempNewsModel=[[ISSTCampusNewsModel alloc]init];
     ISSTCampusNewsModel * tempNewsModel= [newsArray objectAtIndex:indexPath.row];
    self.newsDetailView.newsId=tempNewsModel.newsId;
   // [self.navigationController setNavigationBarHidden:YES];    //set system navigationbar hidden
    [self.navigationController pushViewController:self.newsDetailView animated: NO];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark  ISSTWebApiDelegate Methods
- (void)requestDataOnSuccess:(id)backToControllerData
{
    if ([newsArray count]) {
        newsArray = [[NSMutableArray alloc]init];
    }
    newsArray = (NSMutableArray *)backToControllerData;
    NSLog(@"count =%d ,newsArray = %@",[newsArray count],newsArray);
     [newsArrayTableView reloadData];
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
//    NSString *vcTitle = [self.title stringByAppendingString:@""];
//    UIViewController *vc = [[ISSTPushedViewController alloc] initWithTitle:vcTitle];
//    
//    [self.navigationController pushViewController:vc animated:YES];
//}





@end
