//
//  ISSTActivityDetailViewController.m
//  ISST
//
//  Created by apple on 14-6-22.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTSameCityActivityDetailViewController.h"
#import "ISSTUserModel.h"
#import "ISSTActivityModel.h"
#import "ISSTActivityStatusModel.h"
#import "AppCache.h"

@interface ISSTSameCityActivityDetailViewController ()
{
    NSString *title;
    NSString *starttime;
    NSString *endtime;
    NSString *publisher;
    NSString *content;
    NSString *location;
}
@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
//@property (weak, nonatomic) IBOutlet UILabel *title;
//@property (weak, nonatomic) IBOutlet UILabel *releaseUserLabel;
//@property (weak, nonatomic) IBOutlet UILabel *startTime;
//@property (weak, nonatomic) IBOutlet UILabel *endTime;
//@property (weak, nonatomic) IBOutlet UILabel *location;
//@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIButton *participatedButton;
@property (copy, nonatomic) ISSTUserModel    *userModel;
@property (copy, nonatomic) ISSTSameCitiesApi *requestApi;
@property (copy, nonatomic) ISSTActivityModel *activityModel;
@property (copy, nonatomic) ISSTActivityStatusModel *activityStatus;
- (IBAction)participatedAction:(id)sender;
@end

@implementation ISSTSameCityActivityDetailViewController
@synthesize cityId,activityId,pictureView,participatedButton,userModel,requestApi,activityModel,activityStatus;
@synthesize webView;
const static int SAMECITY_ACTIVITY_DETAIL   = 1;
const static int SAMECITY_PATICIPATE        = 2;
const static int SAMECITY_CANCEL_PATICIPATE = 3;
int method;

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
    
    
    
    userModel = [[ISSTUserModel alloc] init];
    userModel = [AppCache getCache];
    
    requestApi = [[ISSTSameCitiesApi alloc] init];
    requestApi.webApiDelegate = self;
    
    method = SAMECITY_ACTIVITY_DETAIL;
    [requestApi requestSameCityDetailInfo:cityId andActivityId:activityId];
    
    webView.scalesPageToFit =YES;
    webView.delegate=self;
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // Do any additional setup after loading the view from its nib.
}

-(void)firstLoadParticipatedButton
{
    if (activityModel.participated)
    {
        participatedButton.titleLabel.text = [NSString stringWithFormat:@"已报名"];
    }
    else
    {
        participatedButton.titleLabel.text = [NSString stringWithFormat:@"未报名"];
        
    }
    
}

-(void)loadParticipatedButton
{
    if (method == SAMECITY_PATICIPATE)
    {
        if (activityStatus.statusId == 0)
        {
            participatedButton.titleLabel.text = [NSString stringWithFormat:@"已报名"];
            method = SAMECITY_CANCEL_PATICIPATE;
            activityModel.participated = true;
        }
        else
        {
            NSString *errorMessage;
            switch ( activityStatus.statusId ) {
                case 30:
                    errorMessage = @"活动不存在！";
                    break;
                case 31:
                    errorMessage = @"活动尚未开始，不能报名！";
                    break;
                case 32:
                    errorMessage = @"活动已结束";
                    break;
                case 33:
                    errorMessage = @"您已报名，请勿重复报名！";
                    break;
                    
                default:
                    break;
            }
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:errorMessage delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            
        }
    }
    else if(method == SAMECITY_CANCEL_PATICIPATE)
    {
        if (activityStatus.statusId == 0)
        {
            participatedButton.titleLabel.text = [NSString stringWithFormat:@"未报名"];
            method = SAMECITY_PATICIPATE;
            activityModel.participated =false;
        }
        else
        {
            NSString *errorMessage;
            switch ( activityStatus.statusId ) {
                case 34:
                    errorMessage = @"您尚未报名！";
                    break;
                    
                default:
                    break;
            }
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:errorMessage delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }
    }
}


-(void)layoutDetailView
{
//    if (activityModel.picture != nil&&[activityModel.picture isKindOfClass:[NSString class]] ) {
//    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:activityModel.picture]];
//    pictureView.image = [UIImage imageWithData:data];
//    }
    
    title= activityModel.title;
    
    content = activityModel.content;
    //releaseUserLabel.text = [NSString stringWithFormat:@"发布者：%@",activityModel.releaseUserModel.userName];
    publisher = [NSString stringWithFormat:@"发布者：管理员"]; //测试阶段先写死
    starttime= activityModel.startTime;
    
   endtime = activityModel.expireTime;
    location = activityModel.location;
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
                          "<h6 align='center'>时间：%@&nbsp-&nbsp%@&nbsp&nbsp&nbsp地点：%@&nbsp&nbsp</h6>"
                          "%@</body> \n"
                          "</html>", fontSize,title,starttime,endtime,location,content];
    
    
    [webView loadHTMLString:jsString baseURL:nil];//加载html源代码
    
    [self firstLoadParticipatedButton];
    
    
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
    if(nil == backToControllerData)
        return;

    else
    {
        switch (method) {
            case SAMECITY_ACTIVITY_DETAIL:
                if (activityModel == nil)
                {
                    activityModel = [[ISSTActivityModel alloc] init];
                }
                activityModel = backToControllerData;
                [self layoutDetailView];
                break;
            case SAMECITY_PATICIPATE:
                if(activityStatus ==nil )
                {
                    activityStatus = [[ISSTActivityStatusModel alloc] init];
                }
                activityStatus = backToControllerData;
                [self loadParticipatedButton];
                break;
            case SAMECITY_CANCEL_PATICIPATE:
                if(activityStatus ==nil )
                {
                    activityStatus = [[ISSTActivityStatusModel alloc] init];
                }
                activityStatus = backToControllerData;
                [self loadParticipatedButton];
                break;
            default:
                break;
        }
    }
    
}
-(void)requestDataOnFail:(NSString *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您好:" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
        
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)participatedAction:(id)sender
{
    if (!activityModel.participated)
    {
        method = SAMECITY_PATICIPATE;
     [requestApi requsetSameCityActivityRegistration:cityId andActivityId:activityId];
    }
    else
    {
        method = SAMECITY_CANCEL_PATICIPATE;
    [requestApi requsetSameCityActivityCancelRegistration:cityId andActivityId:activityId];
    }
}
@end
