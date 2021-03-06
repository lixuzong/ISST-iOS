//
//  ISSTNewsApi.m
//  ISST
//
//  Created by XSZHAO on 14-3-25.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTLifeApi.h"
#import "ISSTCampusNewsParse.h"
#import "LoginErrors.h"
#import "NetworkReachability.h"
#import "ISSTRestaurantsParse.h"
@implementation ISSTLifeApi

@synthesize webApiDelegate;
@synthesize datas;
@synthesize methodId;
const    static  int  CAMPUSNEWS = 1;
const    static  int   DETAILS   = 2;
const    static  int   WIKIS     = 3;
const    static  int   STUDYING=4;
const    static  int   EXPERIENCE  =5;

- (void)requestCampusNewsLists:(int)page andPageSize:(int)pageSize andKeywords:(NSString *)keywords
{
      if (NetworkReachability.isConnectionAvailable)
      {
        methodId = CAMPUSNEWS;
        datas = [[NSMutableData alloc]init];
        NSString *info = [NSString stringWithFormat:@"page=%d&pageSize=%d",page,pageSize];
        NSString *subUrlString = [NSString stringWithFormat:@"api/archives/categories/campus"];
        [super requestWithSuburl:subUrlString Method:@"GET2" Delegate:self Info:info MD5Dictionary:nil];
      }
      else
      {
        //数据库解析，
        if ([self.webApiDelegate respondsToSelector:@selector(requestDataOnFail:)])
        {
            [self.webApiDelegate requestDataOnFail:[LoginErrors getNetworkProblem]];
        }
      }
}

- (void)requestWikisLists:(int)page andPageSize:(int)pageSize andKeywords:(NSString *)keywords
{
    if (NetworkReachability.isConnectionAvailable) {
        methodId = WIKIS;
        datas = [[NSMutableData alloc]init];
        NSString *info = [NSString stringWithFormat:@"page=%d&pageSize=%d",page,pageSize];
        NSString *subUrlString = [NSString stringWithFormat:@"api/archives/categories/encyclopedia"];
        [super requestWithSuburl:subUrlString Method:@"GET" Delegate:self Info:info MD5Dictionary:nil];
    }
    else
    {
        //数据库解析，
        if ([self.webApiDelegate respondsToSelector:@selector(requestDataOnFail:)])
        {
            [self.webApiDelegate requestDataOnFail: [LoginErrors getNetworkProblem]];
        }
    }
}
- (void)requestStudyingLists:(int)page andPageSize:(int)pageSize andKeywords:(NSString *)keywords
{
    methodId = STUDYING;
    datas = [[NSMutableData alloc]init];
    NSString *info = [NSString stringWithFormat:@"page=%d&pageSize=%d",page,pageSize];
    NSString *subUrlString = [NSString stringWithFormat:@"api/archives/categories/studying"];
    [super requestWithSuburl:subUrlString Method:@"GET2" Delegate:self Info:info MD5Dictionary:nil];
    
}


- (void)requestExperienceLists:(int)page andPageSize:(int)pageSize andKeywords:(NSString *)keywords
{
    if (NetworkReachability.isConnectionAvailable)
    {
        methodId = EXPERIENCE;
        datas = [[NSMutableData alloc]init];
        NSString *info = [NSString stringWithFormat:@"page=%d&pageSize=%d",page,pageSize];
        NSString *subUrlString = [NSString stringWithFormat:@"api/archives/categories/experience"];
        [super requestWithSuburl:subUrlString Method:@"GET2" Delegate:self Info:info MD5Dictionary:nil];
    }
    else
    {
        //数据库解析，
        if ([self.webApiDelegate respondsToSelector:@selector(requestDataOnFail:)])
        {
            [self.webApiDelegate requestDataOnFail: [LoginErrors getNetworkProblem]];
        }
    }
}



- (void)requestDetailInfoWithId:(int)detailId
{
    if (NetworkReachability.isConnectionAvailable)
    {
        methodId = DETAILS;
        datas = [[NSMutableData alloc]init];
        // NSString *info = [NSString stringWithFormat:@"",page,pageSize];
        NSString *subUrlString = [NSString stringWithFormat:@"api/archives/%d",detailId];
        [super requestWithSuburl:subUrlString Method:@"GET" Delegate:self Info:nil MD5Dictionary:nil];
    }
    else
    {
        //数据库解析，
        if ([self.webApiDelegate respondsToSelector:@selector(requestDataOnFail:)])
        {
            [self.webApiDelegate requestDataOnFail: [LoginErrors getNetworkProblem]];
        }
    }
}


-(void)dealloc
{
    webApiDelegate=nil;
    datas=nil;
    // [super dealloc];
}


#pragma mark -
#pragma mark NSURLConnectionDelegate  methods

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@",[error localizedDescription]);
    [self.webApiDelegate requestDataOnFail:[LoginErrors checkNetworkConnection]];
}

- (NSURLRequest *)connection:(NSURLConnection *)connection
             willSendRequest:(NSURLRequest *)request
            redirectResponse:(NSURLResponse *)redirectResponse{
    NSLog(@"即将发送请求");
    return(request);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
    NSDictionary *fields = [HTTPResponse allHeaderFields];
    NSLog(@"获取返回（状态，包头）信息");
    NSLog(@"self=%@ fields=%@",self,[fields description]);
//    NSLog(@"11111111111111-----------------");
//    NSLog(@"self=%@ fields=%@",self,fields);
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
    NSLog(@"获取数据");
    NSLog(@"数据长度为 = %lu", (unsigned long)[data length]);
    [datas appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse *)cachedResponse{
    NSLog(@"将缓存输出");
    return(cachedResponse);
}


//请求完成
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    ISSTCampusNewsParse *news  = [[ISSTCampusNewsParse alloc]init];
 
    NSDictionary *dics =[news infoSerialization:datas];
    NSArray *array ;
    id backData;
    NSLog(@"self=%@,解析life数据为dictionary",self);
     NSLog(@"dictionary =%lu",(unsigned long)[dics count]);
    switch (methodId) {
        case CAMPUSNEWS:
        case WIKIS:
        case STUDYING:
        case EXPERIENCE:
            // dics=  [news campusNewsSerialization:datas];
//            NSLog(@"dictionary =%lu,dics=%@",(unsigned long)[dics count],dics);
            if (dics&&[dics count]>0)
            {
                if (0 == [news getStatus])//登录成功
                {
                    array = [news campusNewsInfoParse];
                    if ([self.webApiDelegate respondsToSelector:@selector(requestDataOnSuccess:)])
                    {
                        [self.webApiDelegate requestDataOnSuccess:array];
                    }
                }
                
                else if(1 == [news getStatus])
                {
                    NSLog(@" login failed");
                    if ([self.webApiDelegate respondsToSelector:@selector(updateUserLogin)])
                    {
                        [self.webApiDelegate updateUserLogin];
                    }
                    
                }
            }
            else//可能服务器荡掉
            {
                if ([self.webApiDelegate respondsToSelector:@selector(requestDataOnFail:)])
                {
                    [self.webApiDelegate requestDataOnFail:[LoginErrors getNetworkProblem]];
                }
            }
            
            break;
           case DETAILS:
            if (dics&&[dics count]>0)
            {
                if (0 == [news getStatus])//登录成功
                {
                    backData = [news newsDetailsParse];
                    if ([self.webApiDelegate respondsToSelector:@selector(requestDataOnSuccess:)])
                    {
                        [self.webApiDelegate requestDataOnSuccess:backData];
                    }
                    backData = nil;
                }
                
                else if(1 == [news getStatus])
                {
                    if ([self.webApiDelegate respondsToSelector:@selector(updateUserLogin)])
                    {
                        [self.webApiDelegate updateUserLogin];
                    }
                    
                }
            }
            else//可能服务器荡掉
            {
                if ([self.webApiDelegate respondsToSelector:@selector(requestDataOnFail:)])
                {
                    [self.webApiDelegate requestDataOnFail:[LoginErrors getNetworkProblem]];
                }
            }
            break;
        default:
            break;
    }
    
    
    
    
}


@end
