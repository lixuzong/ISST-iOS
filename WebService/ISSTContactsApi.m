//
//  ISSTContactsApi.m
//  ISST
//
//  Created by XSZHAO on 14-4-8.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTContactsApi.h"
#import "LoginErrors.h"
#import "NetworkReachability.h"
#import "ISSTContactsParse.h"
@interface ISSTContactsApi()
- (void)handleConnectionUnAvailable;
@end

@implementation ISSTContactsApi

@synthesize webApiDelegate;
@synthesize datas;
@synthesize methodId;

const static int        CONTACTSLISTS       = 1;
const static  int       CONTACTDETAIL       = 2;
const static int        CLASSESLISTS        = 3;
const static int        MAJORSLISTS         = 4;
- (void)requestCityLists:(int)page andPageSize:(int)pageSize
{

}

- (void)requestSameCityActivityLists:(int)page andPageSize:(int)pageSize andKeywords:(NSString *)keywords
{

}

- (void)requestSCAUnverifyLists:(int)page andPageSize:(int)pageSize
{

}

- (void)requestSameActivityDetail:(int)cityId
{

}

- (void)requestSCAVerify:(int)cityId
{

}

- (void)requestSCAParticipate:(int)cityId
{

}

- (void)requestContactsLists:(int)contactId name:(NSString*)name gender:(int)gender grade:(int)gradeId  classId:(int)classId className:(NSString*)className  majorId:(int)majorId majorName:(NSString *)majorName cityId:(int)cityId cityName:(NSString*)cityName company:(NSString *) company ;
{
    if (NetworkReachability.isConnectionAvailable)
    {
        methodId  = CONTACTSLISTS;
        datas = [[NSMutableData alloc]init];
        NSMutableString *info = [[NSMutableString alloc]initWithString:[NSString stringWithFormat:@"id=%d&gender=%d&grade=%d&classId=%d&majorId=%d&cityId=%d",contactId,gender,gradeId,classId,majorId,cityId]];
//        if (contactId>=0) {
//            [info appendFormat:@"%@",[NSString stringWithFormat:@"id=%d",contactId]];
//        }
        if (name) {
//            NSString * encodingNameString = [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [info appendFormat:@"%@",[NSString stringWithFormat:@"&name=%@",name]];
        }
        if (className) {
            [info appendFormat:@"%@",[NSString stringWithFormat:@"&className=%@",className]];
        }
        if (majorName) {
            [info appendFormat:@"%@",[NSString stringWithFormat:@"&major=%@",majorName]];
        }
//        if (cityName) {
//            [info appendFormat:@"%@",[NSString stringWithFormat:@"&cityName=%@",cityName]];
//        }
        if ( company) {
            [info appendFormat:@"%@",[NSString stringWithFormat:@"&company=%@",company]];
        }
        NSString *subUrlString = [NSString stringWithFormat:@"api/alumni?%@",info];
        NSLog(@"subUrlString=%@",subUrlString);
        [super requestWithSuburl:subUrlString Method:@"GET" Delegate:self Info:nil MD5Dictionary:nil];
    }
    else
    {
        [self handleConnectionUnAvailable];
    }

}

- (void)requestContactDetail:(int)contactId
{
    if (NetworkReachability.isConnectionAvailable)
    {
        methodId  = CONTACTDETAIL ;
        datas = [[NSMutableData alloc]init];
        NSString *subUrlString = [NSString stringWithFormat:@"api/alumni/%d",contactId];
        [super requestWithSuburl:subUrlString Method:@"GET" Delegate:self Info:nil MD5Dictionary:nil];
    }
    else
    {
        [self handleConnectionUnAvailable];
    }

}

- (void)requestClassesLists
{
    if (NetworkReachability.isConnectionAvailable)
    {
        methodId  = CLASSESLISTS;
        datas = [[NSMutableData alloc]init];
        // NSString *info = [NSString stringWithFormat:@"page=%d&pageSize=%d",page,pageSize];
        NSString *subUrlString = [NSString stringWithFormat:@"api/classes"];
        [super requestWithSuburl:subUrlString Method:@"GET" Delegate:self Info:nil MD5Dictionary:nil];
    }
    else
    {
        [self handleConnectionUnAvailable];
    }

}

- (void)requestMajorsLists
{
    if (NetworkReachability.isConnectionAvailable)
    {
        methodId  = MAJORSLISTS;
        datas = [[NSMutableData alloc]init];
        // NSString *info = [NSString stringWithFormat:@"page=%d&pageSize=%d",page,pageSize];
        NSString *subUrlString = [NSString stringWithFormat:@"api/majors"];
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
    ISSTContactsParse *contactsParse=[[ISSTContactsParse alloc]init];
    NSDictionary *dics   = [contactsParse infoSerialization:datas];
    NSArray *array ;
    id backData;
    
    switch (methodId) {
        case CONTACTSLISTS:
            if (dics&&[dics count]>0)
            {
                if (0 == [contactsParse getStatus])//登录成功
                {
                    array = [contactsParse contactsInfoParse];
                    NSLog(@"%d",[array count]);
                    if ([self.webApiDelegate respondsToSelector:@selector(requestDataOnSuccess:)])
                    {
                        [self.webApiDelegate requestDataOnSuccess:array];
                    }
                }
                else if(1 == [contactsParse getStatus])
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
        case CONTACTDETAIL:
            if (dics&&[dics count]>0)
            {
                if (0 == [contactsParse getStatus])//登录成功
                {
                    backData = [contactsParse contactDetailsParse];
                    if ([self.webApiDelegate respondsToSelector:@selector(requestDataOnSuccess:)])
                    {
                        [self.webApiDelegate requestDataOnSuccess:backData];
                    }
                }
                else if(1 == [contactsParse getStatus])
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
        case CLASSESLISTS:
            if (dics&&[dics count]>0)
            {
                if (0 == [contactsParse getStatus])//登录成功
                {
                    array = [contactsParse classesInfoParse];
                    if ([self.webApiDelegate respondsToSelector:@selector(requestDataOnSuccess:)])
                    {
                        [self.webApiDelegate requestDataOnSuccess:array];
                    }
                }
                else if(1 == [contactsParse getStatus])
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
        case MAJORSLISTS:
            if (dics&&[dics count]>0)
            {
                if (0 == [contactsParse getStatus])//登录成功
                {
                    array = [contactsParse majorsInfoParse];
                    if ([self.webApiDelegate respondsToSelector:@selector(requestDataOnSuccess:)])
                    {
                        [self.webApiDelegate requestDataOnSuccess:array];
                    }
                }
                else if(1 == [contactsParse getStatus])
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
    dics= nil;
   
    
}

@end
