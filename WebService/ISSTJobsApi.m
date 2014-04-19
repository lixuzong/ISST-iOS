//
//  ISSTJobsApi.m
//  ISST
//
//  Created by zhukang on 14-4-14.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTJobsApi.h"
#import "LoginErrors.h"
#import "NetworkReachability.h"
#import "ISSTJobsParse.h"

@interface ISSTJobsApi()
- (void)handleConnectionUnAvailable;
@end
@implementation ISSTJobsApi
@synthesize webApiDelegate;
@synthesize datas;
@synthesize methodId;
const static int EMPLOYMENT     =1;
const static int INTERNSHIP     =2;
const static int RECOMMEND      =3;
const static int DETAILS        =4;
const static int COMMENTS       =5;
const static int POSTCOMMENTS   =6;
-(void)dealloc
{
    webApiDelegate=nil;
    datas=nil;
    // [super dealloc];
}

-(void)requestEmploymentLists:(int)page andPageSize:(int)pageSize andKeywords:(NSString *)keywords
{
    if (NetworkReachability.isConnectionAvailable)
    {
        methodId = EMPLOYMENT;
        datas = [[NSMutableData alloc]init];
        NSString *info = [NSString stringWithFormat:@"page=%d&pageSize=%d",page,pageSize];
        NSString *subUrlString = [NSString stringWithFormat:@"api/jobs/categories/employment"];
        [super requestWithSuburl:subUrlString Method:@"GET" Delegate:self Info:info MD5Dictionary:nil];
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
-(void)requestInternshipLists:(int)page andPageSize:(int)pageSize andKeywords:(NSString *)keywords
{
    if (NetworkReachability.isConnectionAvailable)
    {
        methodId = INTERNSHIP;
        datas = [[NSMutableData alloc]init];
        NSString *info = [NSString stringWithFormat:@"page=%d&pageSize=%d",page,pageSize];
        NSString *subUrlString = [NSString stringWithFormat:@"api/jobs/categories/internship"];
        [super requestWithSuburl:subUrlString Method:@"GET" Delegate:self Info:info MD5Dictionary:nil];
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
-(void)requestRecommendLists:(int)page andPageSize:(int)pageSize andKeywords:(NSString *)keywords
{
    if (NetworkReachability.isConnectionAvailable)
    {
        methodId = RECOMMEND;
        datas = [[NSMutableData alloc]init];
        NSString *info = [NSString stringWithFormat:@"page=%d&pageSize=%d",page,pageSize];
        NSString *subUrlString = [NSString stringWithFormat:@"api/jobs/categories/recommend"];
        [super requestWithSuburl:subUrlString Method:@"GET" Delegate:self Info:info MD5Dictionary:nil];
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
- (void)requestDetailInfoWithId:(int)detailId
{
    if (NetworkReachability.isConnectionAvailable)
    {
        methodId = DETAILS;
        datas = [[NSMutableData alloc]init];
        // NSString *info = [NSString stringWithFormat:@"",page,pageSize];
        NSString *subUrlString = [NSString stringWithFormat:@"api/jobs/%d",detailId];
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

- (void)requestRCLists:(int)page andPageSize:(int)pageSize andJobId:(int)jobId
{
    if (NetworkReachability.isConnectionAvailable)
    {
        methodId = COMMENTS;
        datas = [[NSMutableData alloc]init];
        NSString *info = [NSString stringWithFormat:@"page=%d&pageSize=%d",page,pageSize];
        NSString *subUrlString = [NSString stringWithFormat:@"api/jobs/%d/comments?%@",jobId,info];
        [super requestWithSuburl:subUrlString Method:@"GET" Delegate:self Info:nil MD5Dictionary:nil];
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

- (void)requestPostComments:(int)jobId content:(NSString*)content
{
    if (NetworkReachability.isConnectionAvailable)
    {
        methodId = POSTCOMMENTS;
        datas = [[NSMutableData alloc]init];
        NSString *info = [NSString stringWithFormat:@"content=%@",content];
        NSString *subUrlString = [NSString stringWithFormat:@"api/jobs/%d/comments",jobId];
        [super requestWithSuburl:subUrlString Method:@"POST" Delegate:self Info:info MD5Dictionary:nil];
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
    ISSTJobsParse *jobs  = [[ISSTJobsParse alloc]init];
    NSDictionary *dics =[jobs infoSerialization:datas];
    NSArray *array ;
    id backData;
    
    switch (methodId) {
        case EMPLOYMENT:
        case INTERNSHIP:
        case RECOMMEND:
            // dics=  [news campusNewsSerialization:datas];
            if (dics&&[dics count]>0)
            {
                if (0 == [jobs getStatus])//登录成功
                {
                    array = [jobs jobsInfoParse];
                    if ([self.webApiDelegate respondsToSelector:@selector(requestDataOnSuccess:)])
                    {
                        [self.webApiDelegate requestDataOnSuccess:array];
                    }
                }
                
                else if(1 == [jobs getStatus])
                {
                    if ([self.webApiDelegate respondsToSelector:@selector(requestDataOnFail:)])
                    {
                        [self.webApiDelegate requestDataOnFail:[LoginErrors getUnLoginMessage]];
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
                if (0 == [jobs getStatus])//登录成功
                {
                    backData = [jobs jobsDetailInfoParse];
                    if ([self.webApiDelegate respondsToSelector:@selector(requestDataOnSuccess:)])
                    {
                        [self.webApiDelegate requestDataOnSuccess:backData];
                    }
                }
                
                else if(1 == [jobs getStatus])
                {
                    if ([self.webApiDelegate respondsToSelector:@selector(requestDataOnFail:)])
                    {
                        [self.webApiDelegate requestDataOnFail:[LoginErrors getUnLoginMessage]];
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
        case COMMENTS:
            if (dics&&[dics count]>0)
            {
                if (0 == [jobs getStatus])//登录成功
                {
                    backData = [jobs rcListsParse];
                    NSLog(@"%@",backData);
                    if ([self.webApiDelegate respondsToSelector:@selector(requestDataOnSuccess:)])
                    {
                        [self.webApiDelegate requestDataOnSuccess:backData];
                    }
                }
                else if(1 == [jobs getStatus])
                {
                    if ([self.webApiDelegate respondsToSelector:@selector(requestDataOnFail:)])
                    {
                        [self.webApiDelegate requestDataOnFail:[LoginErrors getUnLoginMessage]];
                    }
                }
            }
            else//可能服务器宕掉
            {
                if ([self.webApiDelegate respondsToSelector:@selector(requestDataOnFail:)])
                {
                    [self.webApiDelegate requestDataOnFail:[LoginErrors getNetworkProblem]];
                }
            }
            break;
        case POSTCOMMENTS:
            if (dics&&[dics count]>0)
            {
                if (0 == [jobs getStatus])//登录成功
                {
                    backData = [jobs recommendCommentsParse];
                    NSLog(@"%@",backData);
                    if ([self.webApiDelegate respondsToSelector:@selector(requestDataOnSuccess:)])
                    {
                        [self.webApiDelegate requestDataOnSuccess:backData];
                    }
                }
                else if(1 == [jobs getStatus])
                {
                    if ([self.webApiDelegate respondsToSelector:@selector(requestDataOnFail:)])
                    {
                        [self.webApiDelegate requestDataOnFail:[LoginErrors getUnLoginMessage]];
                    }
                }
                else
                {
                    if ([self.webApiDelegate respondsToSelector:@selector(requestDataOnFail:)])
                    {
                        [self.webApiDelegate requestDataOnFail:[LoginErrors getStatusMessage:[jobs getStatus]]];
                    }
                }

            }
            else//可能服务器宕掉
            {
                if ([self.webApiDelegate respondsToSelector:@selector(requestDataOnFail:)])
                {
                    [self.webApiDelegate requestDataOnFail:[LoginErrors getNetworkProblem]];
                }
            }
            break;

            break;
        default:
            break;
    }
    
    
    
    
}

@end
