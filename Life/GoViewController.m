//
//  GoViewController.m
//  ISST
//
//  Created by XSZHAO on 14-3-20.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//
#import "GogoViewController.h"
#import "GoViewController.h"

@interface GoViewController ()

@end

@implementation GoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //self.navigationItem.title =@"Gogo";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    GogoViewController *vc = [[GogoViewController alloc] initWithTitle:vcTitle];
   // [self.navigationController removeFromParentViewController];
  //  [self.navigationController popToRootViewControllerAnimated:YES];
  //  [self.navigationController popToViewController:self.navigationController.rotatingFooterView animated:YES];
    [self.navigationController setNavigationBarHidden:NO];
//	[self.navigationController pushViewController:vc animated:YES];
    
    
}


@end
