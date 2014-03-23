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

@implementation ISSTLoginApi(Network)






@end


@implementation ISSTLoginApi
 @synthesize webApiDelegate;
 @synthesize datas;


- (void)requestLoginName:(NSString *)name andPassword:(NSString *)password
{

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
    
}





@end
