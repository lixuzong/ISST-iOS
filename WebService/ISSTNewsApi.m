//
//  ISSTNewsApi.m
//  ISST
//
//  Created by XSZHAO on 14-3-25.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTNewsApi.h"
#import "ISSTCampusNewsParse.h"

@implementation ISSTNewsApi

@synthesize webApiDelegate;
@synthesize datas;

- (void)requestCampusNews:(int)page andPageSize:(int)pageSize andKeywords:(NSString *)keywords
{
    datas = [[NSMutableData alloc]init];
    NSString *info = [[NSString stringWithFormat:@"page=%d&pageSize=%d",page,pageSize]autorelease];
    NSString *subUrlString = [[NSString stringWithFormat:@"api/archives/categories/campus"]autorelease];
    [super requestWithSuburl:subUrlString Method:@"GET" Delegate:self Info:info MD5Dictionary:nil];

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
      NSLog(@"data=%@",datas);
   //d NSLog(@"%@",(ISSTUserModel *)[userLoginParse userInfoParse]);
    NSDictionary *dics= [NSJSONSerialization JSONObjectWithData:datas options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"dics= %@",dics);
    ISSTCampusNewsParse *news = [[ISSTCampusNewsParse alloc]init];
    [news campusNewsSerialization:datas];
    NSArray *array = [news campusNewsInfoParse];
    
    [self.webApiDelegate requestDataOnSuccess:array];
}


@end
