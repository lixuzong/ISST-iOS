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
/*****
 2014.06.20
 创建： zhu
 获取同城活动列表
 参数： 第几页、每页大小
 *****/
- (void)requestSameCityActivitiesLists:(int)cityId andpage:(int)page andPageSize:(int)pageSize andKeywords:(NSString *)keyWords;
/*****
 2014.06.20
 创建： zhu
 获取活动详细信息
 参数： 城市id、活动id
 *****/
- (void)requestSameCityDetailInfo:(int)cityId andActivityId:(int)activityId;
/*****
 2014.06.20
 创建： zhu
同城活动报名
 参数： 城市id、活动id
 *****/
-(void)requsetSameCityActivityRegistration:(int)cityId andActivityId:(int)activityId;
/*****
 2014.06.20
 创建： zhu
 同城活动取消报名
 参数： 城市id、活动id
 *****/
-(void)requsetSameCityActivityCancelRegistration:(int)cityId andActivityId:(int)activityId;
@end
