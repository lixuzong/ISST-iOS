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
#import "ISSTLoginApi.h"
#import "ISSTUserModel.h"
#import "AppCache.h"

@interface ISSTNewsDetailViewController ()
{
    NSString *title;
    NSString *time;
    NSString *publisher;
}
@property (strong,nonatomic) ISSTUserModel *userModel;
@property (strong,nonatomic) ISSTLoginApi *userApi;
@property (nonatomic,strong)ISSTLifeApi  *newsApi;
@property(nonatomic,strong)ISSTNewsDetailsModel *detailModel;

@end

@implementation ISSTNewsDetailViewController
@synthesize newsApi;
@synthesize detailModel;
@synthesize newsId;


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

//- (void)loadWebPageWithString:(NSString*)urlString
//{
//    NSURL *url =[NSURL URLWithString:urlString];
//   // NSLog(urlString);
//    NSURLRequest *request =[NSURLRequest requestWithURL:url];
//    [webView loadRequest:request];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.newsApi.webApiDelegate=nil;
    
    NSLog(@"news detail delloc");
}

#pragma mark -
#pragma mark  WebViewDelegate Methods
- (void)webViewDidStartLoad:(UIWebView *)webView
{
   // [activityIndicatorView startAnimating] ;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *currentURL = [webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
    //[activityIndicatorView stopAnimating];
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSLog(@"tit=%@",title);
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
   
    time=[NSString stringWithFormat:@"发布时间：%@",detailModel.updatedAt];
    int userId=[[detailModel.userModel objectForKey:@"id"]intValue];
    if(userId!=0)
    {
        NSString *userName=[detailModel.userModel objectForKey:@"name"];
        publisher=[NSString stringWithFormat:@"发布者：%d %@",userId,userName];
    }	
    else publisher=@"发布者：管理员";
    float fontSize=42;
    float imgwidth=320;
    //webView.scrollView.contentSize=CGSizeMake(320, 2000);
    NSString *htmlText=detailModel.content;

    
    NSString *jsString = [NSString stringWithFormat:@"<html> \n"
                          "<head> \n"
                          "<meta id='viewport' name='viewport' content='initial-scale=1.0; maximum-scale=1.0;'>\n"
//                          "<style type=\"text/css\"> \n"
                          
                          "<style type=\"text/css\"> \n"
                          "img{max-width:100%%; width:auto; height:auto;} "
//                          "body {color:#9C9C9C}"
//                          "body {font-size:40;}"
                          "</style> \n"
                          
                          "</head> \n"
                          "<body >\n"
                          "<h3 align='center'style='color:#262626'>%@</h3>"
                          "<h5 align='center'>"
                          "<font color='#9C9C9C'; size='1';>%@&nbsp&nbsp&nbsp&nbsp&nbsp%@</font>"
                          "</h5>"
                          "<hr align='center'; style=' height:1px;border:none;border-top:1px  solid #EBEBEB ;' />"
                           "</hr>"
                         
                           "%@</body> \n"
                       
                          
                          "</html>",detailModel.title,time,publisher,htmlText];
    
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
-(void) updateUserLogin{
    self.userApi=[[ISSTLoginApi alloc] init];
    _userModel=[[ISSTUserModel alloc] init ];
    _userModel=[AppCache getCache];
    if (_userModel) {
        [self.userApi updateLoginUserId:[NSString stringWithFormat:@"%d",_userModel.userId] andPassword:_userModel.password];
        
        [self viewDidLoad];
    }
}


@end
