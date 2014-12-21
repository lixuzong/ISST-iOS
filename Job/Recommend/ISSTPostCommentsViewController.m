//
//  ISSTPostCommentsViewController.m
//  ISST
//
//  Created by XSZHAO on 14-4-19.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTPostCommentsViewController.h"
#import "ISSTJobsApi.h"
#import "MBProgressHUD.h"

@interface ISSTPostCommentsViewController ()<MBProgressHUDDelegate>
{
     MBProgressHUD *HUD;
}

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
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
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
    //MBprogress
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"发送中...";
    [HUD show:YES];
    [HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    [self.jobApi requestPostComments:self.jobId content:self.commentsTextField.text];
}

#pragma mark -
#pragma mark  ISSTWebApiDelegate Methods
- (void)requestDataOnSuccess:(id)backToControllerData
{
 
    NSLog(@"%@",backToControllerData);
    NSString *message;
    if (backToControllerData) {
         [HUD hide:YES];
        message =@"评论成功";
    }
    else{
         [HUD hide:YES];
        message =@"评论出问题";
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您好:" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];

    
}

- (void)requestDataOnFail:(NSString *)error
{
    [HUD hide:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您好:" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

#pragma mark - Execution code（MBProgressHUD）
- (void)myTask {
    // Do something usefull in here instead of sleeping ...可以增加一些逻辑代码
    sleep(3);
}


#pragma mark - MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    HUD = nil;
}



@end
