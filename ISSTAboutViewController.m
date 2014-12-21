//
//  ISSTAboutViewController.m
//  ISST
//
//  Created by rth on 14/12/21.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTAboutViewController.h"

@interface ISSTAboutViewController ()
@property (strong, nonatomic) IBOutlet UILabel *VersionLabel;

@end

@implementation ISSTAboutViewController
@synthesize VersionLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"]; //version号
    VersionLabel.text =appVersion;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
