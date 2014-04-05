//
//  ISSTRestaurantsMenusParse.h
//  ISST
//
//  Created by XSZHAO on 14-4-5.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "BaseParse.h"

@interface ISSTRestaurantsMenusParse : BaseParse
/*****
 2014.04.05
 创建： zhao
 解析商家信息列表
 *****/
-(id)restaurantsMenusInfoParse;

/*****
 2014.04.05
 创建： zhao
 获取返回信息的status，0标记成功，其他不成功
 *****/
- (int)getStatus;



/*****
 2014.04.05
 创建： zhao
 对数据进行序列化
 *****/
- (id)restaurantsMenusSerialization:(NSData*)datas;
@end
