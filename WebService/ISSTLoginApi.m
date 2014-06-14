//
//  ISSTLoginApi.m
//  ISST
//
//  Created by XSZHAO on 14-3-23.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "NetworkReachability.h"
#import "ISSTMD5.h"
#import "ISSTLoginApi.h"
#import "UserLoginParse.h"
#import "LoginErrors.h"
@class ISSTUserModel;

@interface  ISSTLoginApi()
//@property (strong, nonatomic)NSMutableData *datas;
//@property (nonatomic, assign)id<ISSTWebApiDelegate> webApiDelegate;
{
    UserLoginParse *userLoginParse;
}
@end

@implementation ISSTLoginApi

const    static  int   REQUESTLOGIN = 1;
const    static  int   UPDATELOGIN   = 2;
const    static  int   REQUESTUSERINFO= 3;

@synthesize webApiDelegate;
@synthesize datas;
@synthesize methodId;
- (void)requestLoginName:(NSString *)name andPassword:(NSString *)password
{
   // /usr/include/libxml2
    if (NetworkReachability.isConnectionAvailable)
    {
        methodId = REQUESTLOGIN;
        datas = [[NSMutableData alloc]init];
        //MD5 secret
        NSDictionary *md5Dic =  @{@"username": name,@"password":password};
        long long timestamp = [ISSTMD5 getTimestamp];
        NSString *token= [ISSTMD5 tokenWithDic:md5Dic andTimestamp:timestamp];
        
        
        NSString *info = [NSString stringWithFormat:@"username=%@&password=%@&token=%@&timestamp=%llu&longitude=121.00&latitude=30.01",name,password,token,timestamp];
        NSString *subUrlString = [NSString stringWithFormat:@"api/login"];
        [super requestWithSuburl:subUrlString Method:@"POST" Delegate:self Info:info MD5Dictionary:nil];
    }//network connect
    else
    {
        //数据库解析，
        if ([self.webApiDelegate respondsToSelector:@selector(requestDataOnFail:)])
        {
            [self.webApiDelegate requestDataOnFail: [LoginErrors getNetworkProblem]];
        }
    }
  }

- (void)requestUserInfo
{
    if (NetworkReachability.isConnectionAvailable)
    {
        methodId = REQUESTUSERINFO;
        datas = [[NSMutableData alloc]init];
        NSString *subUrlString = [NSString stringWithFormat:@"api/user"];
        [super requestWithSuburl:subUrlString Method:@"GET" Delegate:self Info:nil MD5Dictionary:nil];
    }//network connect
    else
    {
        //数据库解析，
        if ([self.webApiDelegate respondsToSelector:@selector(requestDataOnFail:)])
        {
            [self.webApiDelegate requestDataOnFail: [LoginErrors getNetworkProblem]];
        }
    }

}

- (void)updateLogin
{
    if (NetworkReachability.isConnectionAvailable)
    {
        methodId = UPDATELOGIN;
        datas = [[NSMutableData alloc]init];
        //MD5 secret
        NSDictionary *md5Dic =  @{@"userId": @"714",@"password":@"111111"};
        long long timestamp = [ISSTMD5 getTimestamp];
        NSString *token= [ISSTMD5 tokenWithDic:md5Dic andTimestamp:timestamp];
        
        
        NSString *info = [NSString stringWithFormat:@"userId=%@&token=%@&timestamp=%llu&longitude=121.00&latitude=30.01",@"21351110",token,timestamp];
        NSString *subUrlString = [NSString stringWithFormat:@"api/login/update"];
        [super requestWithSuburl:subUrlString Method:@"POST" Delegate:self Info:info MD5Dictionary:nil];
    }//network connect
    else
    {
        //数据库解析，
        if ([self.webApiDelegate respondsToSelector:@selector(requestDataOnFail:)])
        {
            [self.webApiDelegate requestDataOnFail: [LoginErrors getNetworkProblem]];
        }
    }

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
    
    if (userLoginParse == nil) {
        userLoginParse =[[UserLoginParse alloc]init];
    }
      NSDictionary *dics = [userLoginParse infoSerialization:datas];
    NSLog(@"self=%@\ndics=%@",self,dics);
    switch (methodId) {
        case REQUESTLOGIN:
        case REQUESTUSERINFO:
        case UPDATELOGIN:

            if (dics&&[dics count]>0)//正常反回
            {
                if (0 == [userLoginParse getStatus])//登录成功
                {
                    if ([self.webApiDelegate respondsToSelector:@selector(requestDataOnSuccess:)])
                    {
                        [self.webApiDelegate requestDataOnSuccess:[userLoginParse userInfoParse]];
                    }
                }
                else
                {
                    if ([self.webApiDelegate respondsToSelector:@selector(requestDataOnFail:)])
                    {
                        [self.webApiDelegate requestDataOnFail:[LoginErrors getStatusMessage:[userLoginParse getStatus]]];
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
