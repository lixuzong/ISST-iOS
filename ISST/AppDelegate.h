//
//  AppDelegate.h
//  ISST
//
//  Created by XSZHAO on 14-3-20.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISSTWebApiDelegate.h"
#import "ISSTUserModel.h"
#import "RESideMenu.h"
#import "ISSTLoginApi.h"

int pushtag;
int login;
int netok;
NSString *bpuserid;
NSString *bpchannelid;
@interface AppDelegate : UIResponder <UIApplicationDelegate,ISSTWebApiDelegate,RESideMenuDelegate,UIAlertViewDelegate>
@property(nonatomic,assign)int foreground;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (nonatomic,strong)ISSTUserModel  *userModel;
@property(nonatomic,strong)ISSTLoginApi *userApi;
@end
