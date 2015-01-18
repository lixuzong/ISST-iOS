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
const    static  int   postpushid= 4;

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
        NSLog(@"%@",subUrlString);
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

- (void)updateLoginUserId:(NSString*)userId andPassword:(NSString*) password;
{
    if (NetworkReachability.isConnectionAvailable)
    {
        methodId = UPDATELOGIN;
        datas = [[NSMutableData alloc]init];
        //MD5 secret
        NSDictionary *md5Dic =  @{@"userId": userId,@"password":password};
        long long timestamp = [ISSTMD5 getTimestamp];
        NSString *token= [ISSTMD5 tokenWithDic:md5Dic andTimestamp:timestamp];
        
        
        NSString *info = [NSString stringWithFormat:@"userId=%@&token=%@&timestamp=%llu&longitude=121.00&latitude=30.01",userId,token,timestamp];
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
-(void)postPushWithStudentid:(NSString *)stuid andUserid:(NSString *)userid andChannelid:(NSString *)channelid
{
    if (NetworkReachability.isConnectionAvailable)
    {
        methodId=postpushid;
        datas = [[NSMutableData alloc]init];
        //MD5 secret
       
        
          NSLog(@"ready for post");
        NSString *subUrlString = [NSString stringWithFormat:@"api/messages/binds"];
        
        
        
        
        NSMutableDictionary *inf = [NSMutableDictionary dictionary];
        [inf setObject:stuid forKey:@"studentId"];

        [inf setObject:channelid forKey:@"channelId" ];
 
                [inf setObject:userid forKey:@"userId"];
        NSString *in = [inf JSONString];
        
        NSError *error;
        
        NSData* jsonData =[NSJSONSerialization dataWithJSONObject:inf
                                                          options:NSJSONWritingPrettyPrinted error:&error];
        NSString * json=[[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"dic=%@",inf);
        NSLog(@"json1=%@",in);
        NSLog(@"json2=%@",json);
        
        [super requestWithSuburl:subUrlString Method:@"POST2" Delegate:self Info:in MD5Dictionary:nil];

    }//network connect
//    else
//    {
//        //数据库解析，
//        if ([self.webApiDelegate respondsToSelector:@selector(requestDataOnFail:)])
//        {
//            [self.webApiDelegate requestDataOnFail: [LoginErrors getNetworkProblem]];
//        }
//    }

}



#pragma mark -
#pragma mark NSURLConnectionDelegate  methods

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@",[error localizedDescription]);
   
    [self.webApiDelegate requestDataOnFail:@"请求超时"];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
    NSDictionary *fields = [HTTPResponse allHeaderFields];
    NSLog(@"获取返回（状态，包头）信息");
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
    NSLog(@"接收从服务器返回的数据");
    [datas appendData:data];//add data from server
}
//请求完成
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    if (userLoginParse == nil) {
        userLoginParse =[[UserLoginParse alloc]init];
    }
      NSDictionary *dics = [userLoginParse infoSerialization:datas];
      
    NSLog(@"self=%@,解析数据为dictionary成功",self);
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
       
            
//            case postpushid:
//        {
//            NSLog(@"post successfully");
//        }
        default:
            break;
    }
    
   }

@end
