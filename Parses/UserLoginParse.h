//
//  UserLoginParse.h
//  ISST
//
//  Created by XSZHAO on 14-3-25.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseParse.h"
@interface UserLoginParse : BaseParse
/*****
 2014.04.02
 创建： zhao
 获取返回信息的status，0标记成功，其他不成功
 *****/
- (int)getStatus;

//解析用户信息
-(id)userInfoParse;
/*****
 2014.04.02
 创建： zhao
 序列化数据为dictionary
 *****/
- (NSDictionary *)loginSerialization:(NSData*)datas;
@end

