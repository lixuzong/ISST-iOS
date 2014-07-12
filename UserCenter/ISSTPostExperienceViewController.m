//
//  ISSTPostExperienceViewController.m
//  ISST
//
//  Created by zhangran on 14-7-12.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTPostExperienceViewController.h"
#import "ISSTUserCenterApi.h"
@interface ISSTPostExperienceViewController ()
{
    ISSTUserCenterApi *_userCenterApi;
    UITextField   *_titleTextField;
    UITextView  *_contentTextView;
}
@end

@implementation ISSTPostExperienceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
     _userCenterApi = [[ISSTUserCenterApi alloc] init];
        _userCenterApi.webApiDelegate= self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"发布经验";
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStyleBordered target:self action:@selector(sendExperience)];
    [self initialize];
}

-(void)sendExperience
{
    if ([_titleTextField.text length]>0&&[_contentTextView.text length]>0) {
        [_userCenterApi requestPostExperience:1 title:_titleTextField.text content:_contentTextView.text];
    }
    else if([_titleTextField.text length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"标题不能为空" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
        [alert show];
    }
    else if([_contentTextView.text length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"内容不能为空" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
        [alert show];
    }
}
-(void)initialize
{//标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    titleLabel.text =@"标题:";
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:titleLabel];
    
    _titleTextField = [[UITextField alloc] init];
    _titleTextField.frame = CGRectMake(55, 2, 260, 35);
    [_titleTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.view addSubview:_titleTextField];
    //内容
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,titleLabel.bounds.origin.y +5+titleLabel.bounds.size.height+5, 50, 25)];
    contentLabel.text =@"内容:";
    [contentLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:contentLabel];
    
    _contentTextView = [[UITextView alloc] init ];
    _contentTextView.frame = CGRectMake(55, 45, 260, 200);
  
    [self.view addSubview:_contentTextView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)requestDataOnSuccess:(id)backToControllerData
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:backToControllerData delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
    [alert show];
}

- (void)requestDataOnFail:(NSString *)error
{

}

@end
