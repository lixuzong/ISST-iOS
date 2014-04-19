//
//  ISSTStudyDetailViewController.m
//  ISST
//
//  Created by zhukang on 14-4-4.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTStudyDetailViewController.h"
#import "ISSTLifeApi.h"
#import "ISSTNewsDetailsModel.h"
@interface ISSTStudyDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *userInfo;
@property (nonatomic,strong)ISSTLifeApi  *studyApi;
@property(nonatomic,strong)ISSTNewsDetailsModel *detailModel;
@end

@implementation ISSTStudyDetailViewController
@synthesize studyApi;
@synthesize detailModel;
@synthesize studyId;
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
    self.studyApi = [[ISSTLifeApi alloc]init];
    self.studyApi.webApiDelegate =self;
    [studyApi requestDetailInfoWithId:studyId];
    
    webView.scalesPageToFit =YES;
    webView.delegate=self;
    // [self loadWebPageWithString:detailModel.content];
    // Do any additional setup after loading the view from its nib.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
        detailModel=[[ISSTNewsDetailsModel alloc]init];
        detailModel = (ISSTNewsDetailsModel*)backToControllerData;
    }
    self.title.text=detailModel.title;
    self.time.text=[NSString stringWithFormat:@"发布时间：%@",detailModel.updatedAt];
    int userId=[[detailModel.userModel objectForKey:@"id"]intValue];
    if(userId!=0)
    {
        NSString *userName=[detailModel.userModel objectForKey:@"name"];
        self.userInfo.text=[NSString stringWithFormat:@"发布者：%d %@",userId,userName];
    }
    else self.userInfo.text=@"发布者：管理员";
    [webView loadHTMLString:detailModel.content baseURL:nil];//加载html源代码
    NSLog(@"self=%@ \n htmls=%@",self,backToControllerData);
    NSLog(@"self=%@\n content=%@\n title=%@ \ndescription=%@",self,detailModel.content,detailModel.title,detailModel.description);
}

- (void)requestDataOnFail:(NSString *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您好:" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    
}

@end
