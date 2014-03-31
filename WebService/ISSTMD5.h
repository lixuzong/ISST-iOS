//
//  ISSTMD5.h
//  ISST
//
//  Created by XSZHAO on 14-3-31.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISSTMD5 : NSObject

/*****
 2014.03.31
 创建： zhao
 MD5 加密
 *****/
+(NSString *) md5: (NSString *) inPutText ;

/*****
 2014.03.31
 创建： zhao
 生成时间戳
 *****/
+(long long) getTimestamp;

/*****
 2014.03.31
 创建： zhao
 生成token
 ****/
+ (NSString *) tokenWithDic:(NSDictionary *)md5Dic andTimestamp:(long long)timestamp;

@end
