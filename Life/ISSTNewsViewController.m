//
//  GoViewController.m
//  ISST
//
//  Created by XSZHAO on 14-3-20.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//
#import "ISSTNewsDetailViewController.h"
#import "ISSTNewsViewController.h"
#import "ISSTNewsApi.h"
@interface ISSTNewsViewController ()
@property (nonatomic,strong)ISSTNewsApi  *newsApi;
@end

@implementation ISSTNewsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //self.navigationItem.title =@"Gogo";
         self.navigationItem.rightBarButtonItem.image=[UIImage imageNamed:@"user.png"];
        
    }
    return self;
}

- (void)viewDidLoad
{
    self.newsApi = [[ISSTNewsApi alloc]init];
    [super viewDidLoad];
    self.newsApi.webApiDelegate = self;
 
	self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [self.newsApi requestCampusNews:1 andPageSize:20 andKeywords:@"string"];
	//self.view.backgroundColor = [UIColor lightGrayColor];
    /*	UIButton *pushButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
     [pushButton setTitle:@"Push" forState:UIControlStateNormal];
     [pushButton addTarget:self action:@selector(pushViewController) forControlEvents:UIControlEventTouchUpInside];
     [pushButton sizeToFit];
     [self.view addSubview:pushButton];
     */
//    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
//        self.edgesForExtendedLayout = UIRectEdgeNone;}
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)go:(id)sender {
    NSString *vcTitle = [self.title stringByAppendingString:@" - Pushed"];
    ISSTNewsDetailViewController *vc = [[ISSTNewsDetailViewController alloc] initWithTitle:vcTitle];
  	[self.navigationController pushViewController:vc animated:YES];
    
    
}


#pragma mark -
#pragma mark  ISSTWebApiDelegate Methods
- (void)requestDataOnSuccess:(NSMutableArray *)array
{
    NSLog(@"123test");
}

- (void)requestDataOnFail:(NSString *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您好:" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    
    
    
}





@end
