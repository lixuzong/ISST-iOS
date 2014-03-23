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
    [self.navigationController setNavigationBarHidden:YES];//set system navigationbar hidden

    if ([[[UIDevice currentDevice]systemVersion] doubleValue] >= 7.0) {
        self.edgesForExtendedLayout =UIRectEdgeNone;
    }
    
    [self.passwordField setSecureTextEntry:YES];//set password ......
    self.userApi =[[[ISSTLoginApi alloc]init]autorelease];
    self.userApi.webApiDelegate = self;
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(id)sender {
    
    [self.userApi requestLoginName:self.nameField andPassword:self.passwordField];


}

- (void)dealloc
{
    self.nameField = nil;
    self.passwordField =nil;
    [super dealloc];
}

#pragma mark -
#pragma mark  ISSTWebApiDelegate Methods
- (void)requestDataOnSuccess:(NSMutableArray *)array
{
      ISSTSlidebarNavController *slider =[[[ISSTSlidebarNavController alloc]init]autorelease];
   // [self.navigationController pushViewController:[[ISSTSlidebarNavController alloc]init] animated:YES ];
       [self.navigationController pushViewController:slider animated: NO];
}

- (void)requestDataOnFail:(NSString *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您好:" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
  
    self.nameField.text = @"";
    self.passwordField.text = @"";

}




@end
