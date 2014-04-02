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
@synthesize methodId;
const    static  int  CAMPUSNEWS = 1;
const    static  int   DETAILS   = 2;


- (void)requestCampusNews:(int)page andPageSize:(int)pageSize andKeywords:(NSString *)keywords
{
    methodId = CAMPUSNEWS;
    datas = [[NSMutableData alloc]init];
    NSString *info = [NSString stringWithFormat:@"page=%d&pageSize=%d",page,pageSize];
    NSString *subUrlString = [NSString stringWithFormat:@"api/archives/categories/campus"];
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
     NSDictionary *dics= [NSJSONSerialization JSONObjectWithData:datas options:NSJSONReadingAllowFragments error:nil];
    ISSTCampusNewsParse *news  = [[ISSTCampusNewsParse alloc]init];
    NSArray *array ;
    id backData;
    switch (methodId) {
        case CAMPUSNEWS:
            NSLog(@"dics= %@",dics);
            
            [news campusNewsSerialization:datas];
            array = [news campusNewsInfoParse];
            if ([self.webApiDelegate respondsToSelector:@selector(requestDataOnSuccess:)])
            {
                [self.webApiDelegate requestDataOnSuccess:array];
            }

            break;
        case DETAILS:
            array = [news campusNewsSerialization:datas];
            NSLog(@"class=%@  \n content=%@",self,array);
            backData  = [news newsDetailsParse];
            if ([self.webApiDelegate respondsToSelector:@selector(requestDataOnSuccess:)])
            {
                [self.webApiDelegate requestDataOnSuccess:backData];
            }

            break;
        default:
            break;
    }
    
   
    
   
}


@end
