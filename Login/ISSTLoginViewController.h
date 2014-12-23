//
//  ISSTLogin.h
//  ISST
//
//  Created by XSZHAO on 14-3-22.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTWebApiDelegate.h"
#import "passValue.h"
#import "RESideMenu.h"
#import "AppDelegate.h"

@interface ISSTLoginViewController : UIViewController<ISSTWebApiDelegate,UITextFieldDelegate,RESideMenuDelegate>

@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (retain,nonatomic) passValue *passvalue;
- (IBAction)login:(id)sender;
-(void) showMenu;

@end
