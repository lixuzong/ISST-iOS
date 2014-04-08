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

- (void)requestContactsLists:(int)contactId name:(NSString*)name gender:(int)gender grade:(int)gradeId  classId:(int)classId majorId:(int)majorId cityId:(int)cityId company:(NSString *) company ;
{
    if (NetworkReachability.isConnectionAvailable)
    {
        methodId  = CONTACTSLISTS;
        datas = [[NSMutableData alloc]init];
        NSString *info = [NSString stringWithFormat:@"id=%d&name=%@&gender=%d&grade=%d&classId=%d&majorId=%d&cityId=%d&company=%@",contactId,name,gender,gradeId,classId,majorId,cityId,company];
        NSString *subUrlString = [NSString stringWithFormat:@"api/alumni"];
        [super requestWithSuburl:subUrlString Method:@"GET" Delegate:self Info:info MD5Dictionary:nil];
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
        methodId  = CONTACTSLISTS;
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
    [self.datas setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [datas appendData:data];
}


//请求完成
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    
    
}

@end
