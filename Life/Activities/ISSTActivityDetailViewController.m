//
//  ISSTActivityDetailViewController.m
//  ISST
//
//  Created by XSZHAO on 14-4-7.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTActivityDetailViewController.h"
#import "ISSTActivityApi.h"
#import "ISSTActivityModel.h"
@interface ISSTActivityDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *userinfo;
@property (nonatomic,strong)ISSTActivityApi  *activityApi;
@property(nonatomic,strong)ISSTActivityModel *detailModel;
@end

@implementation ISSTActivityDetailViewController

@synthesize activityId;
@synthesize titleLabel;
@synthesize contentLabel;
@synthesize activityApi;
@synthesize detailModel;
@synthesize webView;

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
    self.titleLabel.text=@"";
    self.userinfo.text=@"";
    self.contentLabel.text=@"";
    
    activityApi = [[ISSTActivityApi alloc]init];
    activityApi.webApiDelegate = self;
    [activityApi requestActivityDetailWithId:activityId];
    
//    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    webView.scalesPageToFit =YES;
    webView.delegate=self;
    NSLog(@"666666");
    NSLog(@"%d",activityId);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
#pragma mark - ISSTWebApiDelegate Methods
- (void)requestDataOnSuccess:(id)backToControllerData
{
    if(detailModel==nil)
    {
        detailModel=[[ISSTActivityModel alloc]init];
        detailModel = (ISSTActivityModel*)backToControllerData;
    }
    self.titleLabel.text=detailModel.title;
    //self.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
    self.titleLabel.numberOfLines = 0;
    int userId=[[detailModel.userModel objectForKey:@"id"]intValue];
    if(userId!=0)
    {
        NSString *userName=[detailModel.userModel objectForKey:@"name"];
        self.userinfo.text=[NSString stringWithFormat:@"发布者：%d %@",userId,userName];
    }
    else
        self.userinfo.text=@"发布者：管理员";
    
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
