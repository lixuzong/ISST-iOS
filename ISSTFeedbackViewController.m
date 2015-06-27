//
//  ISSTFeedbackViewController.m
//  ISST
//
//  Created by rth on 14/12/1.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTFeedbackViewController.h"
#import "AJComboBox.h"
#import "AppCache.h"
#import "ISSTUserModel.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"

@interface ISSTFeedbackViewController ()<MBProgressHUDDelegate,UITextViewDelegate>{
    AJComboBox *fdTypeBox;
    NSMutableDictionary *listdata;
    ISSTUserModel *userModel;
    MBProgressHUD *HUD;
}
@property (strong, nonatomic) IBOutlet UITextView *textView;
@end

@implementation ISSTFeedbackViewController
@synthesize textView;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initialUserModel]; //打开userModel缓存
    
    self.title=@"意见反馈";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStyleBordered target:self action:@selector(sendFeedback)];
    self.navigationItem.rightBarButtonItem.enabled =NO;
   
    self.automaticallyAdjustsScrollViewInsets = NO;   //用导航栏跳转过来会有64像素的下移（textveiw会显示出问题），为了防止产生这个效果，加上这个代码
    self.textView.layer.borderWidth = 1;   //设置边框
    self.textView.layer.cornerRadius = 6;
    self.textView.layer.borderColor =[UIColor grayColor].CGColor;
    textView.delegate = self;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initialUserModel
{
    userModel = [AppCache getCache];
    if (userModel) {
        listdata = [[NSMutableDictionary alloc]init];
        //[listdata setValue:userModel.name forKey:@"name"];
        [listdata setValue:userModel.userName forKey:@"username"];
        [listdata setValue:userModel.email forKey:@"email"];
        
    }
    
}

-(void)sendFeedback{
    
    //MBprogress
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"发送中...";
    [HUD show:YES];
    [HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    
    //获取手机版本号，APP版本号
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"]; //version号
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion]; //手机版本号
    
    NSString *feedbacktype =@"1";
    NSString *os= [NSString stringWithFormat:@"IOS %@",phoneVersion];
    
    [listdata setValue:feedbacktype forKey:@"feedbacktype"];
    [listdata setValue:os forKey:@"os"];
    [listdata setValue:appVersion forKey:@"appversion"];
    [listdata setValue:textView.text forKey:@"content"];
    
    //传送数据到后台
      NSString *url=@"http://10.82.60.35/feedback/app_feedbacks.json";
//    NSString *url=@"http://10.82.60.35/feedback/app_feedbacks.json";
    AFHTTPRequestOperationManager *httpRequestOperationManager=[AFHTTPRequestOperationManager manager]; // 创建
    httpRequestOperationManager.requestSerializer = [AFJSONRequestSerializer serializer]; // 声明请求的数据是JSON类型
    httpRequestOperationManager.responseSerializer = [AFJSONResponseSerializer serializer]; //声明返回的数据是JSON类型
 
    
    [httpRequestOperationManager POST:url parameters:listdata
     
                              success:^(AFHTTPRequestOperation *operation, id responseObject){
                                  
                                  [HUD hide:YES];
                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"已收入，感谢您的参与！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
                                  alert.delegate = self;
                                  [alert show];
                                  
                                  textView.text =@"";
                                 self.navigationItem.rightBarButtonItem.enabled =NO;
                              }failure:^(AFHTTPRequestOperation *operation, NSError *error){
                                  
                                  [HUD hide:YES];
                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"发送失败！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
                                  alert.delegate = self;
                                  [alert show];
                                  
                                  NSLog(@"%@",error);
                                  
                              }];
    

    
    
    
    
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSString *newText = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (newText.length>0) {
        self.navigationItem.rightBarButtonItem.enabled =YES;
    }else{
        self.navigationItem.rightBarButtonItem.enabled =NO;
    }
    return YES;
}



#pragma mark - Execution code（MBProgressHUD）
- (void)myTask {
    // Do something usefull in here instead of sleeping ...可以增加一些逻辑代码
    sleep(3);
}


#pragma mark - MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    HUD = nil;
}



@end
