//
//  ISSTSameCitiesParse.m
//  ISST
//
//  Created by zhukang on 14-4-27.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTSameCitiesParse.h"
#import "ISSTUserModel.h"
#import "ISSTSameCitiesModel.h"
#import "ISSTActivityStatusModel.h"
#import "ISSTActivityModel.h"
#import "ISSTJobsModel.h"

@interface ISSTSameCitiesParse()
{
    NSArray      *_citiesArray;
}
@property (nonatomic,strong)NSMutableArray          *citiesArray;
@property (nonatomic,strong)NSMutableDictionary     *userInfo;
@property (nonatomic,strong)NSMutableArray          *activityArray;
@property (nonatomic,strong)NSDictionary            *activityDetail;

@end

@implementation ISSTSameCitiesParse
@synthesize citiesArray,userInfo,activityArray,activityDetail;
- (id)init
{
    if (self = [super init]) {
        
    }
    return  self;
}

-(id)citiesInfoParse
{
    NSMutableArray *tmpArray =[[[NSMutableArray alloc]init] autorelease];
    citiesArray = [super.dict objectForKey:@"body"];
    int  count = [citiesArray count];
    NSLog(@"count=%d",count);
    for (int i=0; i<count; i++)
    {
        ISSTUserModel *user=[[ISSTUserModel alloc] init];
        ISSTSameCitiesModel *citiesModel = [[[ISSTSameCitiesModel alloc]init] autorelease];
        citiesModel.cityId = [[[citiesArray objectAtIndex:i ] objectForKey:@"id"] intValue];
        citiesModel.cityName = [[citiesArray objectAtIndex:i] objectForKey:@"name"];
        citiesModel.userId=[[citiesArray objectAtIndex:i]objectForKey:@"userId"];
        userInfo=[[citiesArray objectAtIndex:i]objectForKey:@"user"];
        user.userId     = [[userInfo objectForKey:@"id"] intValue];
        user.name       = [userInfo objectForKey:@"name"];
        user.email      = [userInfo objectForKey:@"email"];
        user.qq         = [userInfo objectForKey:@"qq"];
        user.company   = [userInfo objectForKey:@"company"];
        user.position  = [userInfo objectForKey:@"position"];
        citiesModel.userModel=user;
        [tmpArray addObject:citiesModel];
        [user release];
    }
    return tmpArray ;
}

-(id)activiesInfoParse
{
    NSMutableArray *tempArray = [[[NSMutableArray alloc] init] autorelease];
    activityArray = [super.dict objectForKey:@"body"];
    int count = [activityArray count];
    for( int i=0; i<count; i++)
    {
        ISSTJobsModel *activityModel = [[[ISSTJobsModel alloc] init] autorelease];
        activityModel.messageId = [[[activityArray objectAtIndex:i] objectForKey:@"id"] intValue];
        activityModel.title = [[activityArray objectAtIndex:i] objectForKey:@"title"];
        activityModel.cityId = [[[activityArray objectAtIndex:i] objectForKey:@"cityId"] intValue];
        activityModel.location = [[activityArray objectAtIndex:i] objectForKey:@"location"];
        activityModel.participated = [[[activityArray objectAtIndex:i] objectForKey:@"participated"] boolValue];
        activityModel.description = [[activityArray objectAtIndex:i] objectForKey:@"description"];
        
        long long  updatedAt    = [[[activityArray objectAtIndex:i] objectForKey:@"updatedAt"]longLongValue]/1000;
        NSDate  *datePT1 = [NSDate dateWithTimeIntervalSince1970:updatedAt];
        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
        [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
        activityModel .updatedAt  = [dateFormatter1 stringFromDate:datePT1];
        [dateFormatter1 release];
        
        long long  startTime    = [[[activityArray objectAtIndex:i] objectForKey:@"startTime"]longLongValue]/1000;
        NSDate  *datePT2 = [NSDate dateWithTimeIntervalSince1970:startTime];
        NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
        [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
        activityModel.startTime  = [dateFormatter2 stringFromDate:datePT2];
        [dateFormatter2 release];
        
        long long  epireTime = [[[activityArray objectAtIndex:i] objectForKey:@"expireTime"]longLongValue]/1000;
        NSDate  *datePT3 = [NSDate dateWithTimeIntervalSince1970:epireTime];
        NSDateFormatter *dateFormatter3 = [[NSDateFormatter alloc] init];
        [dateFormatter3 setDateFormat:@"yyyy-MM-dd"];
        activityModel.expireTime  = [dateFormatter3 stringFromDate:datePT3];
        [dateFormatter3 release];
    
        
        NSDictionary *tmpDic = [[activityArray objectAtIndex:i] objectForKey:@"user"];
        
        activityModel.userModel.userName = [tmpDic objectForKey:@"name"];
       
        [tempArray addObject:activityModel];
    }
    return tempArray;
}

-(id)activityDetailInfoParse
{
    ISSTActivityModel *tempModel = [[[ISSTActivityModel alloc] init] autorelease];
    activityDetail = [super.dict objectForKey:@"body"];
    if (nil == tempModel)
    {
        return nil;
    }
    tempModel.activityId = [[activityDetail objectForKey:@"id"] intValue];
    tempModel.title = [activityDetail objectForKey:@"title"];
    tempModel.picture = [activityDetail objectForKey:@"picture"];
    tempModel.cityId = [[activityDetail objectForKey:@"cityId"] intValue];
    tempModel.location = [activityDetail objectForKey:@"location"];
    tempModel.content = [activityDetail objectForKey:@"content"];
    tempModel.participated = [[activityDetail objectForKey:@"participated"] boolValue];
    userInfo = [activityDetail objectForKey:@"user"];
    ISSTUserModel *user = [[[ISSTUserModel alloc] init] autorelease];
    user.userId = [[userInfo objectForKey:@"id"] intValue];
    user.userName = [userInfo objectForKey:@"name"];
    user.phone = [userInfo objectForKey:@"phone"];
    user.qq = [userInfo objectForKey:@"qq"];
    user.email = [userInfo objectForKey:@"email"];
    user.company = [userInfo objectForKey:@"company"];
    user.position = [userInfo objectForKey:@"position"];
    
    tempModel.releaseUserModel = user;
    long long  updatedAt    = [[activityDetail objectForKey:@"updatedAt"]longLongValue]/1000;
    NSDate  *datePT1 = [NSDate dateWithTimeIntervalSince1970:updatedAt];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
    tempModel.updateAt = [dateFormatter1 stringFromDate:datePT1];
    [dateFormatter1 release];
    
    long long  startTime    = [[activityDetail objectForKey:@"startTime"]longLongValue]/1000;
    NSDate  *datePT2 = [NSDate dateWithTimeIntervalSince1970:startTime];
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
    tempModel.startTime  = [dateFormatter2 stringFromDate:datePT2];
    [dateFormatter2 release];
    
    long long  epireTime = [[activityDetail objectForKey:@"expireTime"]longLongValue]/1000;
    NSDate  *datePT3 = [NSDate dateWithTimeIntervalSince1970:epireTime];
    NSDateFormatter *dateFormatter3 = [[NSDateFormatter alloc] init];
    [dateFormatter3 setDateFormat:@"yyyy-MM-dd"];
    tempModel.expireTime  = [dateFormatter3 stringFromDate:datePT3];
    [dateFormatter3 release];
    
    return tempModel;
    
}

-(id)activityStatusInfoParse
{
    ISSTActivityStatusModel *statusModel = [[[ISSTActivityStatusModel alloc] init] autorelease];
    statusModel.statusId = [[super.dict objectForKey:@"status"] intValue];
    statusModel.statusMessage = [super.dict objectForKey:@"message"];
    return  statusModel;
}
- (void)dealloc
{
    citiesArray = nil;
    userInfo = nil;
    activityDetail = nil;
    activityArray = nil;
    [super dealloc];
}

@end
