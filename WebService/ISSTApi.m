//
//  ISSTApi.m
//  ISST
//
//  Created by XSZHAO on 14-3-20.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTApi.h"

#import "NSString+URLEncoding.h"
#define USERAGENT @"Mozilla/5.0 (iPhone; CPU iPhone OS 5_1_1 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9B206 Safari/7534.48.3"


@implementation ISSTApi
//@synthesize cookie;
@synthesize webApiDelegate;
@synthesize datas;
- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)requestWithSuburl:(NSString *)subUrl Method:(NSString *)method Delegate:(id<NSURLConnectionDataDelegate>)delegate Info:(NSString*)info  MD5Dictionary:(NSDictionary *)dict
{
  /*  NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    long long dTime = [[NSNumber numberWithDouble:time] longLongValue];
    
    NSString *token = [self token:dict andTime:dTime];
    //    NSString *mainUrl = @"http://www.zjucst.com/isst/api";
    NSString *mainUrl = @"http://yplan.cloudapp.net:8080/party/api";
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",mainUrl,subUrl];
    
    NSRange foundObj = [strUrl rangeOfString:@"?"];
    if (foundObj.length>0)
    {
        strUrl = [NSString stringWithFormat:@"%@&token=%@&expire=%llu",strUrl,token,dTime];
    }
    else
    {
        strUrl= [NSString stringWithFormat:@"%@?token=%@&expire=%llu",strUrl,token,dTime];
    }
    
    NSURL *url = [NSURL URLWithString:[strUrl URLEncodedString]];
   */
    
    //http://yplan.cloudapp.net:8080/isst//users/validation?name=21351110&password=111111    name=%@&password=%@
    NSString *mainUrl = @"http://www.cst.zju.edu.cn/isst/";
//    NSString *mainUrl = @"http://yplan.cloudapp.net:8080/isst/";
    NSString *strUrl= [NSString stringWithFormat:@"%@%@",mainUrl,subUrl];
 
        
    NSURL *url = [NSURL URLWithString:[strUrl URLEncodedString]];
   // NSURL *url=[NSURL URLWithString:[strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if ([method isEqualToString:@"GET"]) {
        
        //NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                               cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                           timeoutInterval:6];
        if (cookie!=nil) {
            NSLog(@"1234");
           // [request setValue:USERAGENT forHTTPHeaderField:@"User-Agent"];
        
            [request setValue:(NSString*)cookie      forHTTPHeaderField:@"Set-Cookie"];
            // [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        }

        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:delegate];
        if (connection) {
            NSLog(@"连接成功");
//            
//            NSURLResponse *response;
//            
//            NSData *myReturn =[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
//            NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
//            NSDictionary *fields = [HTTPResponse allHeaderFields];
//         //   NSLog(@"%@",[fields description]);
//            if ([[fields allKeys] containsObject:@"Set-Cookie"])
//            {
//                //  cookie =[[NSString alloc] initWithString: [[[fields valueForKey:@"Set-Cookie"] componentsSeparatedByString:@";"] objectAtIndex:0]];
//                cookie = [[[fields valueForKey:@"Set-Cookie"] componentsSeparatedByString:@";"] objectAtIndex:0];
//            }
         //   NSLog(@"cookie = %@",cookie);
            //     [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:self.cookie];
            
          //  NSString *strRet = [[NSString alloc] initWithData:myReturn encoding:NSASCIIStringEncoding];
          //  NSLog(@"strRet%@",strRet);

            
        }
        
        
    } else if([method isEqualToString:@"PUT"]) {
        
    } else if([method isEqualToString:@"POST"]) {
        NSData *data = [info dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                               cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                        timeoutInterval:6];
       // NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        //关于iOS上的http请求还在不断学习，从早先的时候发现原来iOS的http请求可以自动保存cookie到后来的，发现ASIHttpRequest会有User-Agent，到现在发现竟然NSURLRequest默认不带USer-Agent的。添加方法：
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:data];
        if (cookie!=nil) {
             NSLog(@"1234");
            [request setValue:USERAGENT forHTTPHeaderField:@"User-Agent"];
            [request setValue:(NSString*)cookie   forHTTPHeaderField:@"Set-Cookie"];
       // [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        }
   
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:delegate];
        if (connection) {
            NSLog(@"连接成功");
//          //  NSMutableURLRequest *getRequest = [NSMutableURLRequest requestWithURL:url];
//              NSURLResponse *response;
//            
//            NSData *myReturn =[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
//            NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
//            NSDictionary *fields = [HTTPResponse allHeaderFields];
//            NSLog(@"%@",[fields description]);
//            
//            if ([[fields allKeys] containsObject:@"Set-Cookie"])
//            {
//               //  cookie =[[NSString alloc] initWithString: [[[fields valueForKey:@"Set-Cookie"] componentsSeparatedByString:@";"] objectAtIndex:0]];
//                  cookie = [[[fields valueForKey:@"Set-Cookie"] componentsSeparatedByString:@";"] objectAtIndex:0];
//            }
//            
//            if (cookie == nil) {
//                cookie = [[NSString alloc] initWithString: [[[fields valueForKey:@"Set-Cookie"] componentsSeparatedByString:@";"] objectAtIndex:0]];
//            }
//            else{
//                cookie = [[[fields valueForKey:@"Set-Cookie"] componentsSeparatedByString:@";"] objectAtIndex:0];
//            }
            
          //  NSLog(@"cookie = %@",cookie);
           //     [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:self.cookie];
        
//            NSString *strRet = [[NSString alloc] initWithData:myReturn encoding:NSASCIIStringEncoding];
//            NSLog(@"strRet%@",strRet);
        } else {
            NSLog(@"connect error");
        }
    } else if([method isEqualToString:@"DELETE"]) {
        
    }
}


@end
