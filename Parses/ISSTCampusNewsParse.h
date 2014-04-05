//
//  ISSTCampusNewsParse.h
//  ISST
//
//  Created by XSZHAO on 14-3-31.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseParse.h"
@interface ISSTCampusNewsParse :BaseParse

/*****
 2014.04.02
 创建： zhao
 解析快讯信息列表
 *****/
-(id)campusNewsInfoParse;

/*****
 2014.04.02
 创建： zhao
 获取返回信息的status，0标记成功，其他不成功
 *****/
- (int)getStatus;

/*****
 2014.04.02
 创建： zhao
 解析信息详情
 *****/
-(id)newsDetailsParse;

/*****
 2014.04.02
 创建： zhao
 对数据进行序列化
 *****/
- (id)campusNewsSerialization:(NSData*)datas;
@end
