//
//  ISSTTaskDetailViewController.m
//  ISST
//
//  Created by rth on 14/12/7.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTTaskDetailViewController.h"
#import "ISSTUserCenterApi.h"
#import "ISSTTasksModel.h"


@interface ISSTTaskDetailViewController ()
@property (strong, nonatomic) IBOutlet UITextView *TaskDetailTextView;
@property(nonatomic,strong)ISSTUserCenterApi *taskDetailApi;
@property(nonatomic,strong)ISSTTasksModel  *taskDetailModel;
@property (strong, nonatomic) IBOutlet UILabel *starttimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *endtimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *TaskNameLabel;

@end

@implementation ISSTTaskDetailViewController
@synthesize taskDetailModel;
@synthesize taskDetailApi;
@synthesize TaskDetailTextView;
@synthesize detail;
@synthesize starttimeLabel;
@synthesize endtimeLabel;
@synthesize startTime;
@synthesize expireTime;
@synthesize TaskNameLabel;
@synthesize TaskName;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    TaskDetailTextView.text= detail;
    starttimeLabel.text = startTime;
    endtimeLabel.text = expireTime;
    TaskNameLabel.text =TaskName;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"登记" style:UIBarButtonItemStyleBordered target:self action:@selector(sendTask)];

   
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)sendTask{
    
}



@end
