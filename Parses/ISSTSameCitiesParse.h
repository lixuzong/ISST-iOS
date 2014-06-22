//
//  ISSTSameCitiesParse.h
//  ISST
//
//  Created by zhukang on 14-4-27.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "BaseParse.h"

@interface ISSTSameCitiesParse : BaseParse
/*****
 2014.04.27
 创建： zhu
 解析成主列表
 *****/
-(id)citiesInfoParse;
/*****
 2014.06.20
 创建： zhu
 解析活动列表
 *****/
-(id)activiesInfoParse;
/*****
 2014.06.20
 创建： zhu
 解析活动详情
 *****/
-(id)activityDetailInfoParse;
/*****
 2014.06.20
 创建： zhu
 解析活动报名状态信息
 *****/
-(id)activityStatusInfoParse;

@end
