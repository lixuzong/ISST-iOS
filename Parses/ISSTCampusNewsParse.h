//
//  ISSTCampusNewsParse.h
//  ISST
//
//  Created by XSZHAO on 14-3-31.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISSTCampusNewsParse : NSObject


//解析快讯信息
-(id)campusNewsInfoParse;
//:(NSData *)datas;
//返回登陆成功或失败
- (BOOL)getStatus:(NSData *)datas;
-(id)newsDetailsParse;

- (id)campusNewsSerialization:(NSData*)datas;
@end
