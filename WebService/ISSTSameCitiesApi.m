//
//  ISSTSameCitiesApi.m
//  ISST
//
//  Created by apple on 14-4-27.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTSameCitiesApi.h"
#import "LoginErrors.h"
#import "NetworkReachability.h"
#import "ISSTSameCitiesParse.h"
#import "ISSTActivityModel.h"
#import "ISSTActivityStatusModel.h"
@interface ISSTSameCitiesApi()
- (void)handleConnectionUnAvailable;
@end
@implementation ISSTSameCitiesApi
@synthesize webApiDelegate;
@synthesize datas;
@synthesize methodId;
const static int SAMECITIES                              = 1;
const static int SAMECITIES_ACTIVITY_LISTS               = 2;
const static int SAMECITIES_ACTIVITY_DETAIL              = 3;
const static int SANECITIES_ACTIVITY_REGISTRATION        = 4;
const static int SANECITIES_ACTIVITY_CANCEL_REGISTRATION = 5;

-(void)requestSameCitiesLists:(int)page andPageSize:(int)pageSize
{
    
    if (NetworkReachability.isConnectionAvailable)
    {
        methodId  = SAMECITIES ;
        datas = [[NSMutableData alloc]init];
        NSString *info = [NSString stringWithFormat:@"page=%d&pageSize=%d",page,pageSize];
        NSString *subUrlString = [NSString stringWithFormat:@"api/cities"];
        [super requestWithSuburl:subUrlString Method:@"GET" Delegate:self Info:info MD5Dictionary:nil];
    }
    else
    {
        [self handleConnectionUnAvailable];
    }

}

-(void)requestSameCityActivitiesLists:(int)cityId andpage:(int)page andPageSize:(int)pageSize andKeywords:(NSString *)keyWords
{
    if (NetworkReachability.isConnectionAvailable)
    {
        methodId  = SAMECITIES_ACTIVITY_LISTS ;
        datas = [[NSMutableData alloc]init];
        NSString *info = [NSString stringWithFormat:@"page=%d&pageSize=%d",page,pageSize];
        NSString *subUrlString = [NSString stringWithFormat:@"api/cities/%d/activities",cityId];
        [super requestWithSuburl:subUrlString Method:@"GET" Delegate:self Info:info MD5Dictionary:nil];
    }
    else
    {
        [self handleConnectionUnAvailable];
    }
    
}

-(void)requestSameCityDetailInfo:(int)cityId andActivityId:(int)activityId
{
    if (NetworkReachability.isConnectionAvailable)
    {
        methodId  = SAMECITIES_ACTIVITY_DETAIL ;
        datas = [[NSMutableData alloc]init];
        NSString *subUrlString = [NSString stringWithFormat:@"api/cities/%d/activities/%d",cityId,activityId];
        [super requestWithSuburl:subUrlString Method:@"GET" Delegate:self Info:nil MD5Dictionary:nil];
    }
    else
    {
        [self handleConnectionUnAvailable];
    }

}

-(void)requsetSameCityActivityRegistration:(int)cityId andActivityId:(int)activityId
{
    if (NetworkReachability.isConnectionAvailable)
    {
        methodId  = SANECITIES_ACTIVITY_REGISTRATION ;
        datas = [[NSMutableData alloc]init];
        NSString *subUrlString = [NSString stringWithFormat:@"/api/cities/%d/activities/%d/participate",cityId,activityId];
        [super requestWithSuburl:subUrlString Method:@"POST" Delegate:self Info:nil MD5Dictionary:nil];
    }
    else
    {
        [self handleConnectionUnAvailable];
    }
    
}

-(void)requsetSameCityActivityCancelRegistration:(int)cityId andActivityId:(int)activityId
{
    if (NetworkReachability.isConnectionAvailable)
    {
        methodId  = SANECITIES_ACTIVITY_CANCEL_REGISTRATION ;
        datas = [[NSMutableData alloc]init];
        NSString *subUrlString = [NSString stringWithFormat:@"/api/cities/%d/activities/%d/unparticipate",cityId,activityId];
        [super requestWithSuburl:subUrlString Method:@"POST" Delegate:self Info:nil MD5Dictionary:nil];
    }
    else
    {
        [self handleConnectionUnAvailable];
    }
    
}


-  (void)handleConnectionUnAvailable
{
    //数据库解析，
    if ([self.webApiDelegate respondsToSelector:@selector(requestDataOnFail:)])
    {
        [self.webApiDelegate requestDataOnFail: [LoginErrors getNetworkProblem]];
    }
}
#pragma mark -
#pragma mark NSURLConnectionDelegate  methods

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@",[error localizedDescription]);
    [self.webApiDelegate requestDataOnFail:[LoginErrors checkNetworkConnection]];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
    NSDictionary *fields = [HTTPResponse allHeaderFields];
    NSLog(@"self=%@ fields=%@",self,[fields description]);
    if ([[fields allKeys] containsObject:@"Set-Cookie"])
    {
        //  cookie =[[NSString alloc] initWithString: [[[fields valueForKey:@"Set-Cookie"] componentsSeparatedByString:@";"] objectAtIndex:0]];
        cookie = [[[fields valueForKey:@"Set-Cookie"] componentsSeparatedByString:@";"] objectAtIndex:0];
        //
        //  [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    }
    [self.datas setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [datas appendData:data];
}


//请求完成
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    ISSTSameCitiesParse *citiesParse=[[ISSTSameCitiesParse alloc]init];
    NSDictionary *dics   = [citiesParse infoSerialization:datas];
    NSArray *array ;
    NSDictionary *dict;
    id backData;
    switch (methodId) {
        case SAMECITIES:
            if (dics&&[dics count]>0)
            {
                if (0 == [citiesParse getStatus])//登录成功
                {
                    array = [citiesParse citiesInfoParse];
                    if ([self.webApiDelegate respondsToSelector:@selector(requestDataOnSuccess:)])
                    {
                        [self.webApiDelegate requestDataOnSuccess:array];
                    }
                }
                
                else if(1 == [citiesParse getStatus])
                {
                    if ([self.webApiDelegate respondsToSelector:@selector(requestDataOnFail:)])
                    {
                        [self.webApiDelegate requestDataOnFail:[LoginErrors getUnLoginMessage]];
                    }
                    
                }
            }
            else//可能服务器宕掉
            {
                [self handleConnectionUnAvailable];
            }
            break;
        case SAMECITIES_ACTIVITY_LISTS:
            if (dics&&[dics count]>0)
            {
                if (0 == [citiesParse getStatus])//登录成功
                {
                    array = [citiesParse activiesInfoParse];
                    if ([self.webApiDelegate respondsToSelector:@selector(requestDataOnSuccess:)])
                    {
                        [self.webApiDelegate requestDataOnSuccess:array];
                    }
                }
                
                else if(1 == [citiesParse getStatus])
                {
                    if ([self.webApiDelegate respondsToSelector:@selector(requestDataOnFail:)])
                    {
                        [self.webApiDelegate requestDataOnFail:[LoginErrors getUnLoginMessage]];
                    }
                    
                }
            }
            else//可能服务器宕掉
            {
                [self handleConnectionUnAvailable];
            }

            break;
        case SAMECITIES_ACTIVITY_DETAIL:
        {
            if (dics&&[dics count]>0)
            {
                if (0 == [citiesParse getStatus])//登录成功
                {
                    ISSTActivityModel *tempModel = [citiesParse activityDetailInfoParse];
                    if ([self.webApiDelegate respondsToSelector:@selector(requestDataOnSuccess:)])
                    {
                        [self.webApiDelegate requestDataOnSuccess:tempModel];
                    }
                }
                
                else if(1 == [citiesParse getStatus])
                {
                    if ([self.webApiDelegate respondsToSelector:@selector(requestDataOnFail:)])
                    {
                        [self.webApiDelegate requestDataOnFail:[LoginErrors getUnLoginMessage]];
                    }
                    
                }
            }
            else//可能服务器宕掉
            {
                [self handleConnectionUnAvailable];
            }

        }
            break;
        case SANECITIES_ACTIVITY_REGISTRATION:
        {
            if (dics&&[dics count]>0)
            {
                if (1 != [citiesParse getStatus])//登录成功
                {
                    ISSTActivityStatusModel *tempStatus = [citiesParse activityStatusInfoParse];
                    if ([self.webApiDelegate respondsToSelector:@selector(requestDataOnSuccess:)])
                    {
                        [self.webApiDelegate requestDataOnSuccess:tempStatus];
                    }
                }
                
                else if(1 == [citiesParse getStatus])
                {
                    if ([self.webApiDelegate respondsToSelector:@selector(requestDataOnFail:)])
                    {
                        [self.webApiDelegate requestDataOnFail:[LoginErrors getUnLoginMessage]];
                    }
                    
                }
            }
            else//可能服务器宕掉
            {
                [self handleConnectionUnAvailable];
            }

        }
            break;
        case SANECITIES_ACTIVITY_CANCEL_REGISTRATION:
        {
            if (dics&&[dics count]>0)
            {
                if (1 != [citiesParse getStatus])//登录成功
                {
                    ISSTActivityStatusModel *tempStatus = [citiesParse activityStatusInfoParse];
                    if ([self.webApiDelegate respondsToSelector:@selector(requestDataOnSuccess:)])
                    {
                        [self.webApiDelegate requestDataOnSuccess:tempStatus];
                    }
                }
                
                else if(1 == [citiesParse getStatus])
                {
                    if ([self.webApiDelegate respondsToSelector:@selector(requestDataOnFail:)])
                    {
                        [self.webApiDelegate requestDataOnFail:[LoginErrors getUnLoginMessage]];
                    }
                    
                }
            }
            else//可能服务器宕掉
            {
                [self handleConnectionUnAvailable];
            }

        }
            break;
        default:
            break;
    }
    
    
    
    
}

@end
