//
//  ISSTActivityApi.m
//  ISST
//
//  Created by XSZHAO on 14-4-7.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTActivityApi.h"
#import "LoginErrors.h"
#import "ISSTActivityParse.h"
#import "NetworkReachability.h"
@interface ISSTActivityApi()
- (void)handleConnectionUnAvailable;
@end
@implementation ISSTActivityApi
@synthesize webApiDelegate;
@synthesize datas;
@synthesize methodId;

const static int ACTITITIES =1;
const    static  int   DETAILS   = 2;

- (void)requestActivitiesLists:(int)page andPageSize:(int)pageSize andKeywords:(NSString *)keywords
{
    if (NetworkReachability.isConnectionAvailable)
    {
        methodId  = ACTITITIES;
        datas = [[NSMutableData alloc]init];
        NSString *info = [NSString stringWithFormat:@"page=%d&pageSize=%d",page,pageSize];
        NSString *subUrlString = [NSString stringWithFormat:@"api/campus/activities"];
        [super requestWithSuburl:subUrlString Method:@"GET" Delegate:self Info:info MD5Dictionary:nil];
    }
    else
    {
        [self handleConnectionUnAvailable];
    }

}

- (void)requestActivityDetailWithId:(int)restaurantsId
{
    if (NetworkReachability.isConnectionAvailable)
    {
        methodId = DETAILS;
        datas = [[NSMutableData alloc]init];
        NSString *subUrlString = [NSString stringWithFormat:@"api/campus/activities/%d",restaurantsId];
        [super requestWithSuburl:subUrlString Method:@"GET" Delegate:self Info:nil MD5Dictionary:nil];
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
    ISSTActivityParse *activitiesParse=[[ISSTActivityParse alloc]init];
    NSDictionary *dics   = [activitiesParse infoSerialization:datas];;
    NSArray *array ;
    id backData;
    
    switch (methodId) {
        case ACTITITIES:
            if (dics&&[dics count]>0)
            {
                if (0 == [activitiesParse getStatus])//登录成功
                {
                    array = [activitiesParse activityInfoParse];
                    if ([self.webApiDelegate respondsToSelector:@selector(requestDataOnSuccess:)])
                    {
                        [self.webApiDelegate requestDataOnSuccess:array];
                    }
                }
                
                else if(1 == [activitiesParse getStatus])
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
        case DETAILS:
            if (dics&&[dics count]>0)
            {
                if (0 == [activitiesParse getStatus])//登录成功
                {
                    backData = [activitiesParse activityDetailsParse];
                    if ([self.webApiDelegate respondsToSelector:@selector(requestDataOnSuccess:)])
                    {
                        [self.webApiDelegate requestDataOnSuccess:backData];
                    }
                }
                
                else if(1 == [activitiesParse getStatus])
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
            default:
            break;
    }
    
    
    
    
}


@end
