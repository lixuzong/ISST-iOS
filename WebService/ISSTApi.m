//
//  ISSTApi.m
//  ISST
//
//  Created by XSZHAO on 14-3-20.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTApi.h"

#import "NSString+URLEncoding.h"



@implementation ISSTApi

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
    NSString *mainUrl = @"http://yplan.cloudapp.net:8080/party/api";
      NSString *strUrl = [NSString stringWithFormat:@"%@%@",mainUrl,subUrl];
     NSURL *url = [NSURL URLWithString:[strUrl URLEncodedString]];
    if ([method isEqualToString:@"GET"]) {
        
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:delegate];
        if (connection) {
            NSLog(@"连接成功");
        }
    } else if([method isEqualToString:@"PUT"]) {
        
    } else if([method isEqualToString:@"POST"]) {
        
        NSData *data = [info dataUsingEncoding:NSUTF8StringEncoding];
        //   NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
        //                                                      cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
        //                                                 timeoutInterval:6];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:data];
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:delegate];
        if (connection) {
            NSLog(@"连接成功");
        } else {
            NSLog(@"connect error");
        }
    } else if([method isEqualToString:@"DELETE"]) {
        
    }
}


@end
