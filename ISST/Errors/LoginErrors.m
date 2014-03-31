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

        default:
            errorMessage = @"网络错误";
            break;
    }
    return errorMessage;
}
@end
