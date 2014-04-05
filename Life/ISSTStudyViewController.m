//
//  ISSTStudyViewController.m
//  ISST
//
//  Created by XSZHAO on 14-4-2.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTStudyViewController.h"
#import "ISSTLifeApi.h"
#import "ISSTRestaurantsModel.h"
#import "ISSTRestaurantsApi.h"
#import "ISSTRestaurantsMenusModel.h"
@interface ISSTStudyViewController ()
@property (nonatomic,strong)ISSTRestaurantsApi      *restaurantsApi;
- (IBAction)go:(id)sender;

@end

@implementation ISSTStudyViewController

@synthesize restaurantsApi;

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
    
    self.restaurantsApi = [[ISSTRestaurantsApi alloc]init];
    
    self.restaurantsApi.webApiDelegate =self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)go:(id)sender {
   
    [self.restaurantsApi requestMenusListsWithId:1];
    //[self.restaurantsApi requestDetailInfoWithId:1];
    //[self.restaurantsApi requestResturantsLists:1 andPageSize:20 andKeywords:@"string"];
//    ISSTLoginViewController *slider =[[ISSTLoginViewController alloc]init];
//    [self.navigationController setNavigationBarHidden:YES];    //set system navigationbar hidden
//   [self.navigationController pushViewController:slider animated: NO];
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
   NSArray *rArray =(NSArray*)backToControllerData;
   ISSTRestaurantsMenusModel *detailModel =[rArray objectAtIndex:0];
    
    NSLog(@"self=\n content =%@",rArray);
  //  NSLog
   // (@"count=%d",[rArray count]);
    NSLog(@"self=%@\n name=%@\n picture=%@ \n description=%@ \n price =%f",self,detailModel.name,detailModel.picture,detailModel.description,detailModel.price);
}

- (void)requestDataOnFail:(NSString *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您好:" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    
    
    
}

@end
