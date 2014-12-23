//
//  ISSTUpdateLogin.m
//  ISST
//
//  Created by apple on 14/12/11.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTUpdateLogin.h"
#import "AppCache.h"

@implementation ISSTUpdateLogin
@synthesize userModel;


-(void)update
{
    self.userModel = [AppCache getCache];
    NSLog(@"update=%@",userModel.userName);
    NSLog(@"upadte=%@",userModel.password);
}

@end