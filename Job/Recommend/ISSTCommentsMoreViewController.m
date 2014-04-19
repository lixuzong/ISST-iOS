//
//  ISSTCommentsMoreViewController.m
//  ISST
//
//  Created by XSZHAO on 14-4-19.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTCommentsMoreViewController.h"
#import "ISSTCLTableViewCell.h"
#import "ISSTUserModel.h"
#import "ISSTCommentsModel.h"
#import "ISSTJobsApi.h"
#import "ISSTPostCommentsViewController.h"
@interface ISSTCommentsMoreViewController ()
@property (weak, nonatomic) IBOutlet UITableView *commentsMoreTableView;
@property (nonatomic,strong)NSMutableArray *commentsArray;
@property (nonatomic,strong)ISSTJobsApi  *recommendApi;

- (void) postComments;

@end

@implementation ISSTCommentsMoreViewController
@synthesize jobId;
static NSString *CellTableIdentifier=@"ISSTCLTableViewCell";
@synthesize recommendApi;
@synthesize commentsMoreTableView;
@synthesize commentsArray;

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
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                  target:self
                                                  action:@selector(postComments)];
    recommendApi = [[ISSTJobsApi alloc]init];
    recommendApi.webApiDelegate = self;
    UINib *nib=[UINib nibWithNibName:CellTableIdentifier bundle:nil];
    [commentsMoreTableView registerNib:nib forCellReuseIdentifier:CellTableIdentifier];

    [recommendApi requestRCLists:1 andPageSize:20 andJobId:self.jobId];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) postComments
{
    ISSTPostCommentsViewController *postCommentsVC = [[ISSTPostCommentsViewController alloc]initWithNibName:@"ISSTPostCommentsViewController" bundle:nil];
    postCommentsVC.navigationItem.title = @"发表评论";
    postCommentsVC.jobId= self.jobId;
    [self.navigationController pushViewController:postCommentsVC animated:YES];
}


#pragma mark -
#pragma mark - UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [commentsArray count];
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return  1;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        ISSTCLTableViewCell *cell=(ISSTCLTableViewCell  *)[tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
        if (cell == nil) {
            cell = (ISSTCLTableViewCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellTableIdentifier];
        }
    if (commentsArray) {
        ISSTCommentsModel*   cModel =  [commentsArray objectAtIndex:indexPath.row];
        cell.nameLabel.text = cModel.userModel.name;
        cell.contentLabel.text=cModel.content;
        cell.timeLabel.text = cModel.createdAt;
    }
    
    return cell;
}

#pragma mark -
#pragma mark - UITableViewDelegate Method
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

#pragma mark -
#pragma mark  ISSTWebApiDelegate Methods
- (void)requestDataOnSuccess:(id)backToControllerData
{
    commentsArray = (NSMutableArray*)backToControllerData;
    NSLog(@"%@",backToControllerData);
    [commentsMoreTableView  reloadData];
   
}

- (void)requestDataOnFail:(NSString *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您好:" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}


@end
