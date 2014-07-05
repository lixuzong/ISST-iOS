//
//  ISSTTasksParse.m
//  ISST
//
//  Created by xszhao on 14-7-2.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTTasksParse.h"
#import "ISSTTasksModel.h"
#import "ISSTExperienceModel.h"
#import "ISSTSurveyModel.h"
@interface ISSTTasksParse()
{
    NSMutableArray      *_tasksArray;

}

@property (nonatomic,strong)NSMutableArray         *tasksArray;
@property (nonatomic,strong)NSDictionary    *detailsInfo;
@end

@implementation ISSTTasksParse
- (id)init
{
    if (self = [super init]) {
        
    }
    return  self;
}

-(NSString*)tasksMessageParse
{
    return [super.dict objectForKey:@"message"];
}

-(id)experienceListsParse
{
    _tasksArray = [super.dict objectForKey:@"body"] ;
    
    NSMutableArray *array =[[NSMutableArray alloc]init];
    // int  count = [activitiesArray count];
    [_tasksArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ISSTExperienceModel *model = [[ISSTExperienceModel alloc] init];
        model.eId =[[[_tasksArray objectAtIndex:idx ] objectForKey:@"id"]  intValue];
        model.title = [[_tasksArray objectAtIndex:idx ] objectForKey:@"title"]  ;
        model.content = [[_tasksArray objectAtIndex:idx ] objectForKey:@"content"] ;
       [array addObject:model];
    }];
    return array;

}

-(id)surveyListParse
{
    _tasksArray = [super.dict objectForKey:@"body"] ;
    
    NSMutableArray *array =[[NSMutableArray alloc]init];
    // int  count = [activitiesArray count];
    [_tasksArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ISSTSurveyModel *model = [[ISSTSurveyModel alloc] init];
        model.surveyId =[[[_tasksArray objectAtIndex:idx ] objectForKey:@"id"]  intValue];
        model.label = [[_tasksArray objectAtIndex:idx ] objectForKey:@"label"]  ;
      
        [array addObject:model];
    }];
    return array;

}

-(id)taskListsParse
{
    _tasksArray = [super.dict objectForKey:@"body"] ;
    
    NSMutableArray *array =[[NSMutableArray alloc]init];
   // int  count = [activitiesArray count];
    [_tasksArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ISSTTasksModel *model = [[ISSTTasksModel alloc] init];
        model.taskId =[[[_tasksArray objectAtIndex:idx ] objectForKey:@"id"]  intValue];
        model.type = [[[_tasksArray objectAtIndex:idx ] objectForKey:@"type"]  intValue];
        model.finishId = [[[_tasksArray objectAtIndex:idx ] objectForKey:@"finishId"]  intValue];
        model.name = [[_tasksArray objectAtIndex:idx ] objectForKey:@"name"]  ;
        model.description = [[_tasksArray objectAtIndex:idx ] objectForKey:@"description"] ;
        model.updatedAt = [[[_tasksArray objectAtIndex:idx] objectForKey:@"updatedAt"]longLongValue]/1000;
        model.startTime =[[[_tasksArray objectAtIndex:idx] objectForKey:@"startTime"]  longLongValue]/1000;
        model.expireTime =[[[_tasksArray objectAtIndex:idx] objectForKey:@"expireTime"]  longLongValue]/1000;
        [array addObject:model];
    }];
    return array;
    
    

}

- (void)dealloc
{
    _tasksArray = nil;
}

@end
