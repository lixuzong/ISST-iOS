//
//  ISSTLoginApi.h
//  ISST
//
//  Created by XSZHAO on 14-3-23.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTApi.h"
#import "ISSTWebApiDelegate.h"
@class ISSTApi;


@interface ISSTLoginApi :ISSTApi<NSURLConnectionDataDelegate>

/*****
 2014.04.08
 创建： zhao
 方法名，区分不同的请求数据的标记
 *****/
@property (nonatomic,assign)int methodId;
/*****
 2014.04.08
 创建： zhao
 方法名，用户登录
 参数，用户名、密码
 *****/
- (void)requestLoginName:(NSString *)name andPassword:(NSString *)password;
/*****
 2014.04.08
 创建： zhao
 方法名，获取用户信息
 *****/
- (void)requestUserInfo;
/*****
 2014.04.08
 创建： zhao
 方法名，用户登录
 参数，无
 *****/
- (void)updateLogin;



@end
