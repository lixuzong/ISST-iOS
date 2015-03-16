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
    

    NSString *mainUrl = @"http://www.cst.zju.edu.cn/isst/";
//    NSString *mainUrl = @"http://10.82.60.35:8080/isst/";
//    NSString *mainUrl=@"http://10.82.197.249:8080/isst/";
    NSString *strUrl= [NSString stringWithFormat:@"%@%@",mainUrl,subUrl];
    
    //NSURL *url = [NSURL URLWithString:[strUrl URLEncodedString]];
    // NSURL *url=[NSURL URLWithString:[strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    if ([method isEqualToString:@"GET"]) {    //不带参数
        NSURL *url = [NSURL URLWithString:[strUrl URLEncodedString]];
        
        NSURLCache *urlCache=[NSURLCache sharedURLCache];
        //设置1M的缓存
        [urlCache setMemoryCapacity:5*1024*1024];
        
        
        
        //NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                            cachePolicy:NSURLRequestUseProtocolCachePolicy //使用protocal协议定义
                                                           timeoutInterval:20];
        //判断是否有缓存
        NSCachedURLResponse *response =[urlCache cachedResponseForRequest:request];
        NSLog(@"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
        if (response!=nil) {
            NSLog(@"get1=$$$$$$$$$$$$$$$$$$$$$$$$$$＝有缓存，与网上的进行比较再加载＝$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
            [request setCachePolicy:NSURLRequestReturnCacheDataDontLoad];
        }
        
        /* 创建NSURLConnection*/
        
        NSURLConnection *connection =
        
        [[NSURLConnection alloc] initWithRequest:request
         
                                        delegate:delegate];

        if (cookie!=nil) {
            NSLog(@"***********cookie****************");
            NSLog(@"1234");
           // [request setValue:USERAGENT forHTTPHeaderField:@"User-Agent"];
        
            [request setValue:(NSString*)cookie      forHTTPHeaderField:@"Set-Cookie"];
            // [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        }
       
//        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:delegate];
        if (connection) {
            NSLog(@"连接成功");
        
        }
        
        
    }
    
    
    else if([method isEqualToString:@"GET2"]) {   //需要参数的函数就使用“GET2”（参数在info中）  (其实也可以在之前的api中将info和subUrl拼接在一起然后传过来)
        strUrl= [NSString stringWithFormat:@"%@%@?%@",mainUrl,subUrl,info];
        
//        NSLog(@"ISSTApi*********");
        NSLog(@"request %@ by get 2",strUrl);
        
        NSURL *url = [NSURL URLWithString:[strUrl URLEncodedString]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:6.0f];
        
        NSURLCache *urlCache=[NSURLCache sharedURLCache];
        
        [urlCache setMemoryCapacity:1*1024*1024];
        
        [urlCache removeCachedResponseForRequest:request];
//        [urlCache removeAllCachedResponses];
        
        NSCachedURLResponse *response=[urlCache cachedResponseForRequest:request];
        
        if (response!=nil) {
            NSLog(@"get2=$$$$$$$$$$$$$$$$$$$$$$$$$$$＝有缓存，从与网上的进行比较再加载＝$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
             [request setCachePolicy:NSURLRequestReloadRevalidatingCacheData];
        }

        else
        {
            NSLog(@"无缓存");
        }
        NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:request delegate:delegate startImmediately:YES];
//        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:delegate];
        if(connection){
            NSLog(@"连接成功");

        }
        
    }
    
    else if([method isEqualToString:@"PUT"]) {
        
    }
    
    else if([method isEqualToString:@"POST"]) {
        NSURL *url = [NSURL URLWithString:[strUrl URLEncodedString]];
        
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

        }
        
        else {
            NSLog(@"connect error");
        }
        
        
        
    }
    
    
    else if([method isEqualToString:@"POST2"])
    {
        NSURL *url = [NSURL URLWithString:[strUrl URLEncodedString]];
        
        NSData *data = [info dataUsingEncoding:NSUTF8StringEncoding];
        NSString *testdata=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"postpushiddata %@",testdata);
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                               cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                           timeoutInterval:6];
        // NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        //关于iOS上的http请求还在不断学习，从早先的时候发现原来iOS的http请求可以自动保存cookie到后来的，发现ASIHttpRequest会有User-Agent，到现在发现竟然NSURLRequest默认不带USer-Agent的。添加方法：
        
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];//传送json要设置请求头不要忘了
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
        }
        else {
            NSLog(@"connect error");
        }

    }
    
    else if([method isEqualToString:@"DELETE"]) {
        
    }
}


@end
