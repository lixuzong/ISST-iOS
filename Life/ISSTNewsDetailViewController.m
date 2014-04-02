//
//  GogoViewController.m
//  ISST
//
//  Created by XSZHAO on 14-3-20.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTNewsDetailViewController.h"
#import "ISSTNewsApi.h"
#import "ISSTNewsDetailsModel.h"

@interface ISSTNewsDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *Title;
@property (nonatomic,strong)ISSTNewsApi  *newsApi;
@property(nonatomic,strong)ISSTNewsDetailsModel *detailModel;
@end

@implementation ISSTNewsDetailViewController
@synthesize newsApi;
@synthesize detailModel;
@synthesize newsId;
@synthesize Title;

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
    self.newsApi = [[ISSTNewsApi alloc]init];
    self.newsApi.webApiDelegate =self;
    [newsApi requestDetailInfoWithId:newsId];
    
    webView.scalesPageToFit =YES;
    webView.delegate=self;
   // [self loadWebPageWithString:detailModel.content];
    // Do any additional setup after loading the view from its nib.
}

- (void)loadWebPageWithString:(NSString*)urlString
{
    NSURL *url =[NSURL URLWithString:urlString];
    NSLog(urlString);
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
    //    if ([newsArray count]) {
    //        newsArray = [[NSMutableArray alloc]init];
    //    }
    //    newsArray = (NSMutableArray *)backToControllerData;
    //    NSLog(@"count =%d ,newsArray = %@",[newsArray count],newsArray);
    //    [newsArrayTableView reloadData];
    if(detailModel==nil)
    {
     detailModel=[[ISSTNewsDetailsModel alloc]init];
     detailModel = (ISSTNewsDetailsModel*)backToControllerData;
    }
    self.Title.text=detailModel.title;
    [webView loadHTMLString:detailModel.content baseURL:nil];
    NSLog(@"self=%@ \n htmls=%@",self,backToControllerData);
    NSLog(@"self=%@\n content=%@\n title=%@ \ndescription=%@",self,detailModel.content,detailModel.title,detailModel.description);
}

- (void)requestDataOnFail:(NSString *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您好:" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    
}


@end
