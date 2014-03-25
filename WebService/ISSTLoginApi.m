//
//  ISSTLoginApi.m
//  ISST
//
//  Created by XSZHAO on 14-3-23.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTLoginApi.h"
#import "UserLoginParse.h"
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
    datas = [[NSMutableData alloc]init];
    NSString *info = [[NSString stringWithFormat:@"username=%@&password=%@&longitude=121.00&latitude=30.01",name,password]autorelease];
     NSString *subUrlString = [[NSString stringWithFormat:@"api/login"]autorelease];
    [super requestWithSuburl:subUrlString Method:@"POST" Delegate:self Info:info MD5Dictionary:nil];
}

- (void)requestUserInfo:(NSString *)user_id
{
    
}



-(void)dealloc
{
    webApiDelegate=nil;
    datas=nil;
    [super dealloc];
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
    
    //[self retrunCookies];
    NSLog(@"data=%@",datas);
    userLoginParse =[[UserLoginParse alloc]init];
    [userLoginParse loginSerialization:datas];
    NSLog(@"%@",(ISSTUserModel *)[userLoginParse userInfoParse]);
    NSDictionary *dics= [NSJSONSerialization JSONObjectWithData:datas options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"dics= %@",dics);
    [self.webApiDelegate requestDataOnSuccess:dics];
}


-(void)retrunCookies{
  
    /*NSDictionary *properties = [[[NSMutableDictionary alloc] init] autorelease];
   // [properties setValue:[LoginViewController getLanguageType:loginInfo.lang] forKey:NSHTTPCookieValue];
    [properties setValue:@"BENGGURU.GAIA.CULTURE_CODE" forKey:NSHTTPCookieName];
    [properties setValue:@"" forKey:NSHTTPCookieDomain];
    [properties setValue:[NSDate dateWithTimeIntervalSinceNow:60*60] forKey:NSHTTPCookieExpires];
    [properties setValue:@"" forKey:NSHTTPCookiePath];
    NSHTTPCookie *cookie = [[[NSHTTPCookie alloc] initWithProperties:properties] autorelease];
    return [NSMutableArray arrayWithObject:cookie];
*/
 
    NSArray *tmp_Cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:@"http://www.thirtydevs.com"]];
    NSLog(@"1:%@",[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]);
    for (NSHTTPCookie *cookie in tmp_Cookies)
    {
        //从cookies中获取sessionid并保存.
        if ([[cookie domain] isEqualToString:@"www.thirtydevs.com"]) {
            NSDictionary *cookieProperties = [[NSMutableDictionary alloc]init];
            
            [cookieProperties setValue:[cookie value] forKey:NSHTTPCookieValue];
            [cookieProperties setValue:[cookie name]  forKey:NSHTTPCookieName];
            [cookieProperties setValue:@"m.thirtydevs.com" forKey:NSHTTPCookieDomain];
            //没有增加新cookie也许是由于没有把NSHTTPCookieExpires和NSHTTPCookiePath设置好.
            [cookieProperties setValue:nil forKey:NSHTTPCookieExpires];
            [cookieProperties setValue:[cookie path] forKey:NSHTTPCookiePath];
            
            NSHTTPCookie *ncookie = [[NSHTTPCookie alloc] initWithProperties:cookieProperties];
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:ncookie];
            [ncookie release];
            break;
        }
    }
    NSLog(@"2:%@",[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]);
}

@end
