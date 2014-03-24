//
//  ISSTLoginApi.m
//  ISST
//
//  Created by XSZHAO on 14-3-23.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTLoginApi.h"
@interface  ISSTLoginApi(Network)
//@property (strong, nonatomic)NSMutableData *datas;
//@property (nonatomic, assign)id<ISSTWebApiDelegate> webApiDelegate;
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
    NSLog(@"data=%@",datas);
    
    NSDictionary *dics= [NSJSONSerialization JSONObjectWithData:datas options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"dics= %@",dics);
    [self.webApiDelegate requestDataOnSuccess:dics];
}





@end
