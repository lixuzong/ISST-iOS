//
//  ISSTUserCenter.h
//  ISST
//
//  Created by zhaoxs on 6/21/14.
//  Copyright (c) 2014 MSE.ZJU. All rights reserved.
//

#import "ISSTApi.h"
#import "ISSTWebApiDelegate.h"
@interface ISSTUserCenterApi : ISSTApi <
ISSTWebApiDelegate,NSURLConnectionDataDelegate>
/*****
 2014.04.08
 创建： zhao
 方法名，区分不同的请求数据的标记
 *****/
@property (nonatomic,assign)int methodId;
/*****
 2014.06.21
 创建： zhao
 更新个人信息
 参数：
 *****/
- (void)requestChangeUserInfo:(NSMutableDictionary*)dict;

/*****
 2014.07.02
 创建： zhao
 获取任务列表
 参数：page ：pageSize
 *****/
- (void)requestTasksLists:(int)page pageSize:(int)pageSize keywords:(NSString*) keywords;

-(void)requestSurveyLists;

- (void)requestExperienceLists:(int)page pageSize:(int)pageSize keywords:(NSString*) keywords;



@end
