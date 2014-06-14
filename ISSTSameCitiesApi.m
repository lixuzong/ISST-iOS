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
@interface ISSTSameCitiesApi()
- (void)handleConnectionUnAvailable;
@end
@implementation ISSTSameCitiesApi
@synthesize webApiDelegate;
@synthesize datas;
@synthesize methodId;
const static int SAMECITIES=1;
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
    NSDictionary *dics   = [citiesParse infoSerialization:datas];;
    NSArray *array ;
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
        default:
            break;
    }
    
    
    
    
}

@end
