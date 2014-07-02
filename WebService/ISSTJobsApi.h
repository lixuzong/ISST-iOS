//
//  ISSTJobsApi.h
//  ISST
//
//  Created by zhukang on 14-4-14.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTApi.h"
#import  "ISSTWebApiDelegate.h"
@interface ISSTJobsApi : ISSTApi<ISSTWebApiDelegate,NSURLConnectionDataDelegate>
/*****
 2014.04.14
 创建： zhu
 方法名，区分不同的请求数据的标记
 *****/
@property (nonatomic,assign)int methodId;
/*****
 2014.04.14
 创建： zhu
 获取就业信息列表
 参数： 第几页、每页大小、关键字
 *****/
- (void)requestEmploymentLists:(int)page andPageSize:(int)pageSize andKeywords:(NSString *)keywords;
/*****
 2014.04.14
 创建： zhu
 获取实习信息列表
 参数： 第几页、每页大小、关键字
 *****/
- (void)requestInternshipLists:(int)page andPageSize:(int)pageSize andKeywords:(NSString *)keywords;
/*****
 2014.04.14
 创建： zhu
 获取内推信息列表
 参数： 第几页、每页大小、关键字
 *****/
- (void)requestRecommendLists:(int)page andPageSize:(int)pageSize andKeywords:(NSString *)keywords;
/*****
 2014.04.14
 创建： zhu
 获取信息详情
 参数： 第几页、每页大小、关键字
 *****/
- (void)requestDetailInfoWithId:(int)detailId;
/*****
 2014.04.19
 创建： zhao
 获取内推评论信息列表
 参数： 第几页、每页大小、内推信息编号
 *****/
- (void)requestRCLists:(int)page andPageSize:(int)pageSize andJobId:(int)jobId;
/*****
 2014.04.19
 创建： zhao
 发表评论信息
 参数：内推编号、内容
 *****/
- (void)requestPostComments:(int)jobId content:(NSString*)content;
@end
