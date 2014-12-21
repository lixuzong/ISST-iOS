//
//  ISSTMyExperienceDetailsViewController.m
//  ISST
//
//  Created by rth on 14/12/21.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTMyExperienceDetailsViewController.h"

@interface ISSTMyExperienceDetailsViewController ()
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UITextView *detailTextView;

@end

@implementation ISSTMyExperienceDetailsViewController
@synthesize eId,titlename,contentDetail,time;
@synthesize titleLabel,timeLabel,detailTextView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title =@"详情";
    
    titleLabel.text =titlename;
    timeLabel.text =time;
    NSString *contentDetailText =[NSString stringWithFormat:@"  %@",contentDetail];
    detailTextView.text =contentDetailText;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
