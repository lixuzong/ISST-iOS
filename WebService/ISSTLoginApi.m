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

@synthesize webApiDelegate;
@synthesize datas;

- (void)requestLoginName:(NSString *)name andPassword:(NSString *)password
{
    
    if (NetworkReachability.isConnectionAvailable)
    {
        datas = [[NSMutableData alloc]init];
        //MD5 secret
        NSDictionary *md5Dic =  @{@"name": name,@"password":password};
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
            [self.webApiDelegate requestDataOnFail: @"网络连接出现问题"];
        }


        
    }
    
  }

- (void)requestUserInfo:(NSString *)user_id
{
    
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
    NSLog(@"data=%@",datas);
    if (userLoginParse == nil) {
        userLoginParse =[[UserLoginParse alloc]init];
    }
   
     NSDictionary *dics = [userLoginParse loginSerialization:datas];
    if (dics&&[dics count]>0)
    {
        if (0 == [userLoginParse getStatus])//登录成功
        {
            if ([self.webApiDelegate respondsToSelector:@selector(requestDataOnSuccess:)])
            {
                 [self.webApiDelegate requestDataOnSuccess:dics];
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
    else
    {
        if ([self.webApiDelegate respondsToSelector:@selector(requestDataOnFail:)])
        {
            [self.webApiDelegate requestDataOnFail: @"网络连接出现问题"];
        }
   }
}

@end
