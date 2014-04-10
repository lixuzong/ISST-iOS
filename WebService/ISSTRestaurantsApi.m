//
//  ISSTRestaurantsApi.m
//  ISST
//
//  Created by XSZHAO on 14-4-5.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTRestaurantsApi.h"
#import "NetworkReachability.h"
#import "LoginErrors.h"
#import "ISSTRestaurantsParse.h"
#import "ISSTRestaurantsMenusParse.h"
@interface ISSTRestaurantsApi()
- (void)handleConnectionUnAvailable;
@end
@implementation ISSTRestaurantsApi

@synthesize webApiDelegate;
@synthesize datas;
@synthesize methodId;

const static int RESTAURANTS =1;
const    static  int   DETAILS   = 2;
const    static  int   MENUS   = 3;
- (void)requestResturantsLists:(int)page andPageSize:(int)pageSize andKeywords:(NSString *)keywords
{
    if (NetworkReachability.isConnectionAvailable)
    {
        methodId  = RESTAURANTS;
        datas = [[NSMutableData alloc]init];
        NSString *info = [NSString stringWithFormat:@"page=%d&pageSize=%d",page,pageSize];
        NSString *subUrlString = [NSString stringWithFormat:@"api/restaurants"];
        [super requestWithSuburl:subUrlString Method:@"GET" Delegate:self Info:info MD5Dictionary:nil];
    }
    else
    {
        [self handleConnectionUnAvailable];
    }
}

- (void)requestDetailInfoWithId:(int)restaurantsId
{
    
    if (NetworkReachability.isConnectionAvailable)
    {
        methodId = DETAILS;
        datas = [[NSMutableData alloc]init];
        // NSString *info = [NSString stringWithFormat:@"",page,pageSize];
        NSString *subUrlString = [NSString stringWithFormat:@"api/restaurants/%d",restaurantsId];
        [super requestWithSuburl:subUrlString Method:@"GET" Delegate:self Info:nil MD5Dictionary:nil];
    }
    else
    {
        [self handleConnectionUnAvailable];
    }
}

- (void)requestMenusListsWithId:(int)restaurantsId
{
    if (NetworkReachability.isConnectionAvailable)
    {
        methodId = MENUS;
        datas = [[NSMutableData alloc]init];
        // NSString *info = [NSString stringWithFormat:@"",page,pageSize];
        NSString *subUrlString = [NSString stringWithFormat:@"api/restaurants/%d/menus",restaurantsId];
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
    ISSTRestaurantsParse *restaurantsParse ;// = [[ISSTRestaurantsParse alloc]init];
    ISSTRestaurantsMenusParse *restaurantsMenusParse;
    NSDictionary *dics ;//=[restuatantsParse restaurantsSerialization:datas];
    NSArray *array ;
    id backData;
    
    switch (methodId) {
        case RESTAURANTS:
           restaurantsParse = [[ISSTRestaurantsParse alloc]init];
            dics            = [restaurantsParse infoSerialization:datas];
            if (dics&&[dics count]>0)
            {
                if (0 == [restaurantsParse getStatus])//登录成功
                {
                    array = [restaurantsParse restaurantsInfoParse];
                    if ([self.webApiDelegate respondsToSelector:@selector(requestDataOnSuccess:)])
                    {
                        [self.webApiDelegate requestDataOnSuccess:array];
                    }
                }
                
                else if(1 == [restaurantsParse getStatus])
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
            restaurantsParse = [[ISSTRestaurantsParse alloc]init];
            dics             = [restaurantsParse infoSerialization:datas];
            if (dics&&[dics count]>0)
            {
                if (0 == [restaurantsParse getStatus])//登录成功
                {
                    backData = [restaurantsParse restaurantsDetailsParse];
                    if ([self.webApiDelegate respondsToSelector:@selector(requestDataOnSuccess:)])
                    {
                        [self.webApiDelegate requestDataOnSuccess:backData];
                    }
                }
                
                else if(1 == [restaurantsParse getStatus])
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
            case MENUS:
            restaurantsMenusParse =[[ISSTRestaurantsMenusParse alloc]init];
            dics = [restaurantsMenusParse infoSerialization:datas];
            if (dics&&[dics count]>0)
            {
                if (0 == [restaurantsMenusParse getStatus])//登录成功
                {
                    array = [restaurantsMenusParse restaurantsMenusInfoParse];
                    if ([self.webApiDelegate respondsToSelector:@selector(requestDataOnSuccess:)])
                    {
                        [self.webApiDelegate requestDataOnSuccess:array];
                    }
                }
                
                else if(1 == [restaurantsMenusParse getStatus])
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
