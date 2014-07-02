//
//  ISSTActivityApi.h
//  ISST
//
//  Created by XSZHAO on 14-4-7.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTApi.h"

@interface ISSTActivityApi : ISSTApi<ISSTWebApiDelegate,NSURLConnectionDataDelegate>
/*****
 2014.04.07
 创建： zhao
 方法名，区分不同的请求数据的标记
 *****/
@property (nonatomic,assign)int methodId;
/*****
 2014.04.07
 创建： zhao
 获取商家信息列表
 *****/
- (void)requestActivitiesLists:(int)page andPageSize:(int)pageSize andKeywords:(NSString *)keywords;
/*****
 2014.04.07
 创建： zhao
 获取商家信息详情
 *****/
- (void)requestActivityDetailWithId:(int)restaurantsId;

@end
