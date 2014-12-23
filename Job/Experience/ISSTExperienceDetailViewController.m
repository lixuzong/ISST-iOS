//
//  ISSTExperenceDetailViewController.m
//  ISST
//
//  Created by liuyang on 14-4-4.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTExperienceDetailViewController.h"
#import "ISSTLifeApi.h"
#import "ISSTNewsDetailsModel.h"
@interface ISSTExperienceDetailViewController ()
{
    
    NSString *title;
    NSString *time;
    NSString *publisher;
}
@property (nonatomic,strong)ISSTLifeApi  *experienceApi;

@property(nonatomic,strong)ISSTNewsDetailsModel *detailModel;
@end

@implementation ISSTExperienceDetailViewController
@synthesize experienceApi;
@synthesize detailModel;
@synthesize experienceId;



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
    
       self.experienceApi = [[ISSTLifeApi alloc]init];
    self.experienceApi.webApiDelegate =self;
    [experienceApi requestDetailInfoWithId:experienceId];
    
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
        detailModel=[[ISSTNewsDetailsModel alloc]init];
        detailModel = (ISSTNewsDetailsModel*)backToControllerData;
    }
    
    title=detailModel.title;
    
    time=[NSString stringWithFormat:@"发布时间：%@",detailModel.updatedAt];
    int userId=[[detailModel.userModel objectForKey:@"id"]intValue];
    if(userId!=0)
    {
        NSString *userName=[detailModel.userModel objectForKey:@"name"];
        //self.userInfo.text=[NSString stringWithFormat:@"发布者：%d %@",userId,userName];
        publisher =[NSString stringWithFormat:@"发布者:%@",userName];
    }
    else publisher=@"发布者：管理员";
    
    float fontSize=50;
    NSString *jsString = [NSString stringWithFormat:@"<html> \n"
                          "<head> \n"
                          "<style type=\"text/css\"> \n"
                          "body {font-size: %f}"
                          // "img {width:960;}"
                          
                          "</style> \n"
                          "</head> \n"
                          "<body>\n"
                          "<h3 align='center'>%@</h3>"
                          "<h5 align='center'>%@&nbsp&nbsp&nbsp&nbsp&nbsp%@</h5>"
                          "%@</body> \n"
                          "</html>", fontSize,title,time,publisher,detailModel.content];
    
    
    [webView loadHTMLString:jsString baseURL:nil];//加载html源代码
  //  NSLog(@"self=%@ \n htmls=%@",self,backToControllerData);
  //  NSLog(@"self=%@\n content=%@\n title=%@ \ndescription=%@",self,detailModel.content,detailModel.title,detailModel.description);
}

- (void)requestDataOnFail:(NSString *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您好:" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    
}

@end
