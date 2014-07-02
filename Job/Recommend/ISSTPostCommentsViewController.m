//
//  ISSTPostCommentsViewController.m
//  ISST
//
//  Created by XSZHAO on 14-4-19.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTPostCommentsViewController.h"
#import "ISSTJobsApi.h"
@interface ISSTPostCommentsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *commentsTextField;
@property (nonatomic,strong) ISSTJobsApi *jobApi;

- (void)postComments;
@end

@implementation ISSTPostCommentsViewController

@synthesize commentsTextField;
@synthesize jobApi;
@synthesize jobId;
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
    self.jobApi = [[ISSTJobsApi alloc]init ];
    self.jobApi.webApiDelegate = self;
    self.navigationItem.rightBarButtonItem=
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                  target:self
                                                  action:@selector(postComments)];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Private Method
- (void)postComments
{
    [self.jobApi requestPostComments:self.jobId content:self.commentsTextField.text];
}

#pragma mark -
#pragma mark  ISSTWebApiDelegate Methods
- (void)requestDataOnSuccess:(id)backToControllerData
{
 
    NSLog(@"%@",backToControllerData);
    NSString *message;
    if (backToControllerData) {
        message =@"评论成功";
    }
    else message =@"评论出问题";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您好:" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];

    
}

- (void)requestDataOnFail:(NSString *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您好:" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}


@end
