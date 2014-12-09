//
//  GogoViewController.m
//  ISST
//
//  Created by XSZHAO on 14-3-20.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTNewsDetailViewController.h"
#import "ISSTLifeApi.h"
#import "ISSTNewsDetailsModel.h"

@interface ISSTNewsDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *userInfo;
@property (nonatomic,strong)ISSTLifeApi  *newsApi;
@property(nonatomic,strong)ISSTNewsDetailsModel *detailModel;
@end

@implementation ISSTNewsDetailViewController
@synthesize newsApi;
@synthesize detailModel;
@synthesize newsId;
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
    self.newsApi = [[ISSTLifeApi alloc]init];
    self.newsApi.webApiDelegate =self;
    [newsApi requestDetailInfoWithId:newsId];
    CGRect webframe =webView.frame;
    webframe.size.height=700;
    webView.frame=webframe;
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
    self.title.text=detailModel.title;
    self.title.textAlignment =NSTextAlignmentCenter;
    self.title.lineBreakMode = NSLineBreakByCharWrapping;
    self.title.numberOfLines= 0;
    self.time.text=[NSString stringWithFormat:@"发布时间：%@",detailModel.updatedAt];
    int userId=[[detailModel.userModel objectForKey:@"id"]intValue];
    if(userId!=0)
    {
        NSString *userName=[detailModel.userModel objectForKey:@"name"];
        self.userInfo.text=[NSString stringWithFormat:@"发布者：%d %@",userId,userName];
    }	
    else self.userInfo.text=@"发布者：管理员";
    float fontSize=42;
    float imgwidth=320;
    //webView.scrollView.contentSize=CGSizeMake(320, 2000);
    NSString *htmlText=detailModel.content;

    
    NSString *jsString = [NSString stringWithFormat:@"<html> \n"
                          "<head> \n"
                          "<style type=\"text/css\"> \n"
                          "body {font-size: %f}"
                        // "img {width:960;}"
                         
                          "</style> \n"
                          "</head> \n"
                          "<body>%@</body> \n"
                          "</html>", fontSize,htmlText];
    
    [webView loadHTMLString:jsString baseURL:nil];//加载html源代码
    //NSLog(@"self=%@ \n htmls=%@",self,backToControllerData);
    //NSLog(@"self=%@\n content=%@\n title=%@ \ndescription=%@",self,detailModel.content,detailModel.title,detailModel.description);
    //NSLog(@"%f",webView.frame.size.height);
}

- (void)requestDataOnFail:(NSString *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您好:" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    
}


@end
