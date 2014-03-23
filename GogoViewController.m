//
//  GogoViewController.m
//  ISST
//
//  Created by XSZHAO on 14-3-20.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "GogoViewController.h"

@interface GogoViewController ()

@end

@implementation GogoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
             self.navigationItem.title =@"Gogo";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"title";
    self.navigationItem.title =@"Gogo";

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
