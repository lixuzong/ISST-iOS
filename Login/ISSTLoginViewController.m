//
//  ISSTLogin.m
//  ISST
//
//  Created by XSZHAO on 14-3-22.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTLoginViewController.h"
#import "ISSTSlidebarNavController.h"
#import "ISSTLoginApi.h"

@interface ISSTLoginViewController ()

@property (nonatomic,strong)ISSTLoginApi  *userApi;
@end

@implementation ISSTLoginViewController
@synthesize nameField;
@synthesize passwordField;
@synthesize userApi;

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
    [super viewDidLoad];

    if ([[[UIDevice currentDevice]systemVersion] doubleValue] >= 7.0) {
        self.edgesForExtendedLayout =UIRectEdgeNone;
    }
    
    [self.passwordField setSecureTextEntry:YES];//set password ......
    self.userApi =[[ISSTLoginApi alloc]init];
    self.userApi.webApiDelegate = self;
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(id)sender {
    
  // ISSTSlidebarNavController *slider =[[[ISSTSlidebarNavController alloc]init]autorelease];

   //[self.navigationController pushViewController:slider animated: NO];
   [self.userApi requestLoginName:self.nameField.text andPassword:self.passwordField.text];
   


}



#pragma mark -
#pragma mark  ISSTWebApiDelegate Methods
- (void)requestDataOnSuccess:(NSMutableArray *)array
{
      ISSTSlidebarNavController *slider =[[ISSTSlidebarNavController alloc]init]
    ;
   // [self.navigationController pushViewController:[[ISSTSlidebarNavController alloc]init] animated:YES ];
    NSLog(@"navigationController=%@",self.navigationController.hash);
       [self.navigationController pushViewController:slider animated: NO];
    
     [self.navigationController setNavigationBarHidden:YES];//set system navigationbar hidden
}

- (void)requestDataOnFail:(NSString *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您好:" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
  
    self.nameField.text = @"";
    self.passwordField.text = @"";

}




@end
