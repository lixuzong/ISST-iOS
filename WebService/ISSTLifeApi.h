//
//  ISSTNewsApi.h
//  ISST
//
//  Created by XSZHAO on 14-3-25.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTApi.h"
#import  "ISSTWebApiDelegate.h"

@interface ISSTLifeApi : ISSTApi<ISSTWebApiDelegate,NSURLConnectionDataDelegate>

/*****
 2014.04.02
 创建： zhao
 方法名，区分不同的请求数据的标记
 *****/
@property (nonatomic,assign)int methodId;

/*****
 2014.04.01
 创建： zhao
 获取news信息列表
 *****/
- (void)requestCampusNewsLists:(int)page andPageSize:(int)pageSize andKeywords:(NSString *)keywords;
/*****
 2014.04.01
 创建： zhao
 获取wiki信息列表
 *****/
- (void)requestWikisLists:(int)page andPageSize:(int)pageSize andKeywords:(NSString *)keywords;
/*****
 2014.04.01
 创建： zhao
 获取Experence信息列表
 *****/
- (void)requestExperienceLists:(int)page andPageSize:(int)pageSize andKeywords:(NSString *)keywords;
/*****
 2014.04.01
 创建： zhao
 获取Study信息列表
 *****/
- (void)requestStudyingLists:(int)page andPageSize:(int)pageSize andKeywords:(NSString *)keywords;

/*****
 2014.04.01
 创建： zhao
 获取信息详情
 *****/

- (void)requestDetailInfoWithId:(int)detailId;
@end
