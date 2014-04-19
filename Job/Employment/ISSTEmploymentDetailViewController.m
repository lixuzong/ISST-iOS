//
//  GogoViewController.m
//  ISST
//
//  Created by XSZHAO on 14-3-20.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTEmploymentDetailViewController.h"
#import "ISSTJobsApi.h"
#import "ISSTJobsDetailModel.h"
#import "ISSTUserModel.h"

@interface ISSTEmploymentDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *userInfo;
@property (nonatomic,strong)ISSTJobsApi  *employmentApi;
@property(nonatomic,strong)ISSTJobsDetailModel *detailModel;
@end

@implementation ISSTEmploymentDetailViewController
@synthesize employmentApi;
@synthesize detailModel;
@synthesize employmentId;
@synthesize title;

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
    self.employmentApi = [[ISSTJobsApi alloc]init];
    self.employmentApi.webApiDelegate =self;
    [employmentApi requestDetailInfoWithId:employmentId];
    
    webView.scalesPageToFit = YES;
    webView.delegate = self;

}

- (void)loadWebPageWithString:(NSString*)urlString
{
    NSURL *url =[NSURL URLWithString:urlString];
   // NSLog(urlString);
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark  WebViewDelegate Methods
- (void)webViewDidStartLoad:(UIWebView *)webView
{
   // [activityIndicatorView startAnimating] ;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //[activityIndicatorView stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    UIAlertView *alterview = [[UIAlertView alloc] initWithTitle:@"" message:[error localizedDescription]  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alterview show];
}

#pragma mark -
#pragma mark  ISSTWebApiDelegate Methods
- (void)requestDataOnSuccess:(id)backToControllerData
{
    if(detailModel==nil)
    {
     detailModel=[[ISSTJobsDetailModel alloc]init];
     detailModel = (ISSTJobsDetailModel*)backToControllerData;
    }
    self.title.text=detailModel.title;
    self.time.text=detailModel.updatedAt;
    int userId=detailModel.userModel.userId;
    if(userId!=0)
    {
        NSString *userName=detailModel.userModel.userName;
        self.userInfo.text=[NSString stringWithFormat:@"发布者：%d %@",userId,userName];
    }
    else self.userInfo.text=@"发布者：管理员";

    [webView loadHTMLString:detailModel.content baseURL:nil];//加载html源代码
    NSLog(@"self=%@\n content=%@\n messageName=%@ \ndescription=%@",self,detailModel.content,detailModel.title,detailModel.description);
}

- (void)requestDataOnFail:(NSString *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您好:" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    
}


@end
