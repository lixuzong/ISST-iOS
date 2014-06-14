//
//  ISSTContactsApi.h
//  ISST
//
//  Created by XSZHAO on 14-4-8.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTApi.h"
#import "ISSTWebApiDelegate.h"
@interface ISSTContactsApi : ISSTApi<
ISSTWebApiDelegate,NSURLConnectionDataDelegate>
/*****
 2014.04.08
 创建： zhao
 方法名，区分不同的请求数据的标记
 *****/
@property (nonatomic,assign)int methodId;
/*****
 2014.04.08
 创建： zhao
 获取城市信息列表
 参数： 第几页、每页大小
 *****/
- (void)requestCityLists:(int)page andPageSize:(int)pageSize;
/*****
 2014.04.08
 创建： zhao
 获取同城活动列表
  参数： 第几页、每页大小、关键字
 *****/
- (void)requestSameCityActivityLists:(int)page andPageSize:(int)pageSize andKeywords:(NSString *)keywords;
/*****
 2014.04.08
 创建： zhao
 获取同城活动待审核列表SCA= Same city activity
 参数： 第几页、每页大小
 *****/
- (void)requestSCAUnverifyLists:(int)page andPageSize:(int)pageSize;
/*****
 2014.04.08
 创建： zhao
 获取同城活动详情
 *****/
- (void)requestSameActivityDetail:(int)cityId;
/*****
 2014.04.08
 创建： zhao
 获取同城活动待审核列表     SCA= Same city activity
 *****/
- (void)requestSCAVerify:(int)cityId;
/*****
 2014.04.08
 创建： zhao
 获取同城活动报名     SCA= Same city activity
 *****/
- (void)requestSCAParticipate:(int)cityId;
/*****
 2014.04.08
 创建： zhao
 获取通讯录列表
 *****/

- (void)requestContactsLists:(int)contactId name:(NSString*)name gender:(int)gender grade:(int)gradeId  classId:(int)classId className:(NSString*)className  majorId:(int)majorId majorName:(NSString *)majorName cityId:(int)cityId cityName:(NSString*)cityName company:(NSString *) company ;
/*****
 2014.04.08
 创建： zhao
 获取校友详情
 参数： 联系人id
 *****/
- (void)requestContactDetail:(int)contactId;
/*****
 2014.04.08
 创建： zhao
 获取班级列表
 *****/
- (void)requestClassesLists;
/*****
 2014.04.08
 创建： zhao
 获取专业方向列表
 *****/
- (void)requestMajorsLists;
@end
