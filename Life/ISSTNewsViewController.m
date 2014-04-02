//
//  GoViewController.m
//  ISST
//
//  Created by XSZHAO on 14-3-20.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//
#import "ISSTNewsDetailViewController.h"
#import "ISSTNewsViewController.h"
#import "ISSTNewsApi.h"
#import "ISSTNewsTableViewCell.h"
#import "ISSTCampusNewsModel.h"

@interface ISSTNewsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *newsArrayTableView;
@property (nonatomic,strong)ISSTNewsApi  *newsApi;

@property (nonatomic,strong) ISSTCampusNewsModel  *newsModel;

@property (strong, nonatomic) NSMutableArray *newsArray;

- (void)pushViewController;
- (void)revealSidebar;
@end

@implementation ISSTNewsViewController
{
@private
    RevealBlock _revealBlock;
}
@synthesize newsModel;
@synthesize newsApi;
@synthesize newsArray;
@synthesize newsArrayTableView;
static NSString *CellTableIdentifier=@"ISSTNewsTableViewCell";

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
    self.newsApi = [[ISSTNewsApi alloc]init];
  
    self.newsApi.webApiDelegate = self;
   // self.newsArray =[[NSMutableArray alloc]init];
    UITableView *tableView=(id)[self.view viewWithTag:1];
    tableView.rowHeight=65;
    UINib *nib=[UINib nibWithNibName:@"ISSTNewsTableViewCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:CellTableIdentifier];
    
    
	self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [self.newsApi requestCampusNews:1 andPageSize:20 andKeywords:@"string"];
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
    return newsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
     newsModel =[[ISSTCampusNewsModel alloc]init];
      newsModel = [newsArray objectAtIndex:indexPath.row];
    
    ISSTNewsTableViewCell *cell=(ISSTNewsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellTableIdentifier];
    }

    cell.Title.text=[NSString stringWithFormat:@"%@",newsModel.title];
    cell.Time.text=newsModel.updatedAt;
    cell.Content.text= [NSString stringWithFormat:@"%@",newsModel.description];
    return cell;
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