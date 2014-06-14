//
//  ISSTSameCitiesApi.h
//  ISST
//
//  Created by apple on 14-4-27.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTApi.h"
#import "ISSTWebApiDelegate.h"
@interface ISSTSameCitiesApi : ISSTApi<ISSTWebApiDelegate,NSURLConnectionDataDelegate>
/*****
 2014.04.27
 创建： zhu
 方法名，区分不同的请求数据的标记
 *****/
@property (nonatomic,assign)int methodId;
/*****
 2014.04.27
 创建： zhu
 获取同城信息列表
 参数： 第几页、每页大小
 *****/
- (void)requestSameCitiesLists:(int)page andPageSize:(int)pageSize;
@end
