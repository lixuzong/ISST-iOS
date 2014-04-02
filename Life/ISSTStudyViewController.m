//
//  ISSTStudyViewController.m
//  ISST
//
//  Created by XSZHAO on 14-4-2.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTStudyViewController.h"
#import "ISSTNewsApi.h"
#import "ISSTNewsDetailsModel.h"

@interface ISSTStudyViewController ()
@property (nonatomic,strong)ISSTNewsApi  *newsApi;
- (IBAction)go:(id)sender;

@end

@implementation ISSTStudyViewController

@synthesize newsApi;

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
    self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	self.view.backgroundColor = [UIColor lightGrayColor];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [super viewDidLoad];
    self.newsApi = [[ISSTNewsApi alloc]init];
    
    self.newsApi.webApiDelegate =self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)go:(id)sender {
    [newsApi requestDetailInfoWithId:584];
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
    ISSTNewsDetailsModel *detailModel = (ISSTNewsDetailsModel*)backToControllerData;
    NSLog(@"self=%@ \n htmls=%@",self,backToControllerData);
    NSLog(@"self=%@\n content=%@\n title=%@ \ndescription=%@",self,detailModel.content,detailModel.title,detailModel.description);
}

- (void)requestDataOnFail:(NSString *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您好:" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    
    
    
}

@end
