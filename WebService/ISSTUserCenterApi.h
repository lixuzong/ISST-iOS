//
//  ISSTUserCenter.h
//  ISST
//
//  Created by zhaoxs on 6/21/14.
//  Copyright (c) 2014 MSE.ZJU. All rights reserved.
//

#import "ISSTApi.h"
#import "ISSTWebApiDelegate.h"

typedef NS_ENUM(NSInteger, MethodType)
{
    ChangeUserInfo= 1,
    TasksList= 2,
    Survey= 3,
    Experience= 4,
    SurveyResult= 5,
    PostedSurvey= 6,
    PostExperience= 7
};
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

-(void)requestSurveyLists:(int)taskId;

- (void)requestExperienceLists:(int)page pageSize:(int)pageSize keywords:(NSString*) keywords;

-(void)requestSurveyResult:(int)taskId optionId:(int)optionId optionOther:(NSString*)optionOther remarks:(NSString*)remarks;

-(void) requestPostedSurvey:(int)taskId optionId:(int)optionId;


-(void) requestPostExperience:(int)typeId title:(NSString*)title content:(NSString*)content;
@end
