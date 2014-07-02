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
@property (nonatomic,strong)ISSTActivityApi  *activityApi;
@property(nonatomic,strong)ISSTActivityModel *detailModel;
@end

@implementation ISSTActivityDetailViewController

@synthesize activityId;
@synthesize titleLabel;
@synthesize contentLabel;
@synthesize activityApi;
@synthesize detailModel;

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
    activityApi = [[ISSTActivityApi alloc]init];
    activityApi.webApiDelegate = self;
    [activityApi requestActivityDetailWithId:activityId];
   
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
#pragma mark - ISSTWebApiDelegate Methods
- (void)requestDataOnSuccess:(id)backToControllerData
{
    if(detailModel==nil)
    {
        detailModel=[[ISSTActivityModel alloc]init];
        detailModel = (ISSTActivityModel*)backToControllerData;
    }
    self.titleLabel.text=detailModel.title;
    self.contentLabel.text =detailModel.content;
    NSLog(@"self=%@\n content=%@\n title=%@ \ndescription=%@",self,detailModel.content,detailModel.title,detailModel.description);
}

- (void)requestDataOnFail:(NSString *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您好:" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    
}

@end
