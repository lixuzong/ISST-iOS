//
//  AppDelegate.h
//  ISST
//
//  Created by XSZHAO on 14-3-20.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import <UIKit/UIKit.h>

int pushtag;
int login;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property(nonatomic,assign)int foreground;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;
-(void)showmenu;
@end
