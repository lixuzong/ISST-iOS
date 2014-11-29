//
//  ISSTTasksParse.h
//  ISST
//
//  Created by xszhao on 14-7-2.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "BaseParse.h"

@interface ISSTTasksParse : BaseParse
/*****
 2014.07.02
 创建： zhao
 解析任务列表
 *****/
-(id)taskListsParse;

-(id)experienceListsParse;

-(id)surveyListParse;
-(NSString*)tasksMessageParse;



@end
