//
//  ISSTNewsApi.m
//  ISST
//
//  Created by XSZHAO on 14-3-25.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTNewsApi.h"
#import "ISSTCampusNewsParse.h"
#import "LoginErrors.h"
@implementation ISSTNewsApi

@synthesize webApiDelegate;
@synthesize datas;
@synthesize methodId;
const    static  int  CAMPUSNEWS = 1;
const    static  int   DETAILS   = 2;
const    static  int   WIKIS=3;
const    static  int   Experence=4;


- (void)requestCampusNews:(int)page andPageSize:(int)pageSize andKeywords:(NSString *)keywords
{
    methodId = CAMPUSNEWS;
    datas = [[NSMutableData alloc]init];
    NSString *info = [NSString stringWithFormat:@"page=%d&pageSize=%d",page,pageSize];
    NSString *subUrlString = [NSString stringWithFormat:@"api/archives/categories/campus"];
    [super requestWithSuburl:subUrlString Method:@"GET" Delegate:self Info:info MD5Dictionary:nil];

}

- (void)requestWikis:(int)page andPageSize:(int)pageSize andKeywords:(NSString *)keywords
{
    methodId = WIKIS;
    datas = [[NSMutableData alloc]init];
    NSString *info = [NSString stringWithFormat:@"page=%d&pageSize=%d",page,pageSize];
    NSString *subUrlString = [NSString stringWithFormat:@"api/archives/categories/encyclopedia"];
    [super requestWithSuburl:subUrlString Method:@"GET" Delegate:self Info:info MD5Dictionary:nil];


}

- (void)requestExperence:(int)page andPageSize:(int)pageSize andKeywords:(NSString *)keywords
{
    methodId = Experence;
    datas = [[NSMutableData alloc]init];
    NSString *info = [NSString stringWithFormat:@"page=%d&pageSize=%d",page,pageSize];
    NSString *subUrlString = [NSString stringWithFormat:@"api/archives/categories/experience"];
    [super requestWithSuburl:subUrlString Method:@"GET" Delegate:self Info:info MD5Dictionary:nil];
    

}
- (void)requestDetailInfoWithId:(int)detailId
{
    methodId = DETAILS;
    datas = [[NSMutableData alloc]init];
   // NSString *info = [NSString stringWithFormat:@"",page,pageSize];
    NSString *subUrlString = [NSString stringWithFormat:@"api/archives/%d",detailId];
    [super requestWithSuburl:subUrlString Method:@"GET" Delegate:self Info:nil MD5Dictionary:nil];
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
    [self.webApiDelegate requestDataOnFail:@"请查看网络连接"];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.datas setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [datas appendData:data];
}
//请求完成
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
     ISSTCampusNewsParse *news  = [[ISSTCampusNewsParse alloc]init];
    NSDictionary *dics =[news campusNewsSerialization:datas];
   
    NSArray *array ;
    id backData;
    switch (methodId) {
        case CAMPUSNEWS:
        case WIKIS:
        case Experence:
           // dics=  [news campusNewsSerialization:datas];
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
                if (0 == [news getStatus])//登录成功
                {
                    backData = [news newsDetailsParse];
                    if ([self.webApiDelegate respondsToSelector:@selector(requestDataOnSuccess:)])
                    {
                        [self.webApiDelegate requestDataOnSuccess:backData];
                    }
                }
                
                else if(1 == [news getStatus])
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
               default:
            break;
    }
    
   
    
   
}


@end
