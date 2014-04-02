//
//  UserLoginParse.h
//  ISST
//
//  Created by XSZHAO on 14-3-25.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserLoginParse : NSObject

- (int)getStatus;

//解析用户信息
-(id)userInfoParse;
//:(NSData *)datas;
//返回登陆成功或失败
- (BOOL)loginSuccessOrNot:(NSData *)datas;


- (NSDictionary *)loginSerialization:(NSData*)datas;
@end

