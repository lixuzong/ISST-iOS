//
//  ISSTTasksParse.h
//  ISST
//
//  Created by rth on 14-12-6.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "BaseParse.h"

@interface ISSTTasksParse : BaseParse
/*****
 2014.12.06
 创建： rth
 解析任务列表
 *****/
-(id)taskListsParse;

-(id)experienceListsParse;

-(id)surveyListParse;
-(NSString*)tasksMessageParse;

-(id)myRecommendListParse;
-(id)pushListParse;

@end
