//
//  LoginErrors.m
//  ISST
//
//  Created by XSZHAO on 14-3-31.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "LoginErrors.h"

@implementation LoginErrors
+ (NSString *)getStatusMessage:(int )status
{
    NSString *errorMessage ;
    switch (status) {
        case 10:
            errorMessage = @"用户不存在";
          
         break;
        case 11:
             errorMessage = @"密码错误";
            break;
            
        case 12:
              errorMessage = @"认证失效";
            break;
        case 13:
              errorMessage = @"认证失败";
            break;
        case 70:
            errorMessage = @"评论内容不能为空";
            break;
        case 71:
            errorMessage = @"评论内容的长度不能超过80个字符";
            break;
        default:
            errorMessage = @"网络错误";
            break;
    }
    return errorMessage;
}


+ (NSString *)getNetworkProblem
{
    return  @"网络连接出现问题";
}

+ (NSString *)checkNetworkConnection
{
    return @"查看网络连接";
}
+ (NSString *)getUnLoginMessage
{
    return @"用户为登录";
}

@end
