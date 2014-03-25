//
//  GoViewController.m
//  ISST
//
//  Created by XSZHAO on 14-3-20.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//
#import "ISSTNewsDetailViewController.h"
#import "ISSTNewsViewController.h"

@interface ISSTNewsViewController ()

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
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem.image=[UIImage imageNamed:@"user.png"];
	self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
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
   // [self.navigationController removeFromParentViewController];
  //  [self.navigationController popToRootViewControllerAnimated:YES];
  //  [self.navigationController popToViewController:self.navigationController.rotatingFooterView animated:YES];
  //  [self.navigationController setNavigationBarHidden:NO];
	[self.navigationController pushViewController:vc animated:YES];
    
    
}


@end
