//
//  ISSTTasksParse.m
//  ISST
//
//  Created by rth on 14-12-6.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTTasksParse.h"
#import "ISSTTasksModel.h"
#import "ISSTExperienceModel.h"
#import "ISSTSurveyModel.h"
#import "ISSTRecommendModel.h"
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
        model.status = [[[_tasksArray objectAtIndex:idx ] objectForKey:@"status"]  intValue];
        model.description =[[_tasksArray objectAtIndex:idx ] objectForKey:@"description"] ;;
        
        long long updatedAt = [[[_tasksArray objectAtIndex:idx] objectForKey:@"updatedAt"]longLongValue]/1000;
        NSDate  *datePT1 = [NSDate dateWithTimeIntervalSince1970:updatedAt];
        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
        [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
        model.updatedAt  = [dateFormatter1 stringFromDate:datePT1];
       [array addObject:model];
    }];
    return array;

}

-(id)myRecommendListParse{
    _tasksArray=[super.dict objectForKey:@"body"];
    NSLog(@"#####################taskarry##########################%@",_tasksArray);
    NSMutableArray *array=[NSMutableArray new];
    [_tasksArray enumerateObjectsUsingBlock:^(id obj,NSUInteger idx,BOOL *stop){
        ISSTRecommendModel *model=[[ISSTRecommendModel alloc] init];
        model.rId=[[[_tasksArray objectAtIndex:idx] objectForKey:@"id"] floatValue];
        model.title=[[_tasksArray objectAtIndex:idx] objectForKey:@"title"];
        model.company=[[_tasksArray objectAtIndex:idx] objectForKey:@"company"];
        model.position=[[_tasksArray objectAtIndex:idx] objectForKey:@"position"];
        model.updatedAt=[[[_tasksArray objectAtIndex:idx] objectForKey:@"updateAt"] floatValue];
        model.cityId=[[[_tasksArray objectAtIndex:idx] objectForKey:@"cityId"] floatValue];
        model.content=[[_tasksArray objectAtIndex:idx] objectForKey:@"content"];
        model.rDescription=[[_tasksArray objectAtIndex:idx] objectForKey:@"description"];
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
       
        long long updatedAt = [[[_tasksArray objectAtIndex:idx] objectForKey:@"updatedAt"]longLongValue]/1000;
        NSDate  *datePT1 = [NSDate dateWithTimeIntervalSince1970:updatedAt];
        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
        [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
        model.updatedAt  = [dateFormatter1 stringFromDate:datePT1];
        
        
        long long startTime =[[[_tasksArray objectAtIndex:idx] objectForKey:@"startTime"]longLongValue]/1000;
        NSDate  *datePT2 = [NSDate dateWithTimeIntervalSince1970:startTime];
        NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
        [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
        model.startTime  = [dateFormatter1 stringFromDate:datePT2];
        
        long long expireTime =[[[_tasksArray objectAtIndex:idx] objectForKey:@"expireTime"]  longLongValue]/1000;
        NSDate  *datePT3 = [NSDate dateWithTimeIntervalSince1970:expireTime];
        NSDateFormatter *dateFormatter3 = [[NSDateFormatter alloc] init];
        [dateFormatter3 setDateFormat:@"yyyy-MM-dd"];
        model.expireTime  = [dateFormatter1 stringFromDate:datePT3];
        
        [array addObject:model];
    }];
    return array;
    
    

}

- (void)dealloc
{
    _tasksArray = nil;
}

@end
