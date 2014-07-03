//
//  ISSTUserCenter.m
//  ISST
//
//  Created by zhaoxs on 6/21/14.
//  Copyright (c) 2014 MSE.ZJU. All rights reserved.
//
typedef NS_ENUM(NSInteger, MethodType)
{
    ChangeUserInfo= 1,
    TasksList= 2,
    Survey= 3,
    Experience= 4
};

#import "ISSTUserModel.h"
#import "AppCache.h"
#import "ISSTUserCenterApi.h"
#import "LoginErrors.h"
#import "NetworkReachability.h"
#import "ISSTUserCenterParse.h"
#import "ISSTTasksParse.h"

@implementation ISSTUserCenterApi
@synthesize webApiDelegate;
@synthesize datas;
@synthesize methodId;

-(void)requestSurveyLists
{
//    if (NetworkReachability.isConnectionAvailable)
//    {
//        methodId  = Survey;
//        if (NetworkReachability.isConnectionAvailable)
//        {
////            datas = [[NSMutableData alloc]init];
////            NSMutableString *info = [[NSMutableString alloc]initWithString:[NSString stringWithFormat:@"page＝",contactId,gender,gradeId,classId,majorId,cityId]];
////            //        if (contactId>=0) {
////            //            [info appendFormat:@"%@",[NSString stringWithFormat:@"id=%d",contactId]];
////            //        }
////            if (name) {
////                //            NSString * encodingNameString = [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
////                [info appendFormat:@"%@",[NSString stringWithFormat:@"&name=%@",name]];
////            }
////            if (className) {
////                [info appendFormat:@"%@",[NSString stringWithFormat:@"&className=%@",className]];
////            }
////            if (majorName) {
////                [info appendFormat:@"%@",[NSString stringWithFormat:@"&major=%@",majorName]];
////            }
////            //        if (cityName) {
////            //            [info appendFormat:@"%@",[NSString stringWithFormat:@"&cityName=%@",cityName]];
////            //        }
////            if ( company) {
////                [info appendFormat:@"%@",[NSString stringWithFormat:@"&company=%@",company]];
////            }
////            NSString *subUrlString = [NSString stringWithFormat:@"api/alumni?%@",info];
////            NSLog(@"subUrlString=%@",subUrlString);
//            
//    }
//    else
//    {
//        [self handleConnectionUnAvailable];
//    }
}

- (void)requestExperienceLists:(int)page pageSize:(int)pageSize keywords:(NSString*) keywords
{
    if (NetworkReachability.isConnectionAvailable)
    {
        methodId  = Experience;
        datas = [[NSMutableData alloc]init];
        NSString *subUrlString = [NSString stringWithFormat:@"api/users/archives/experience"];
        NSMutableString *info = [[NSMutableString alloc]initWithString:[NSString stringWithFormat:@"page＝%d&pageSize=%d",page,pageSize]];
        [super requestWithSuburl:subUrlString Method:@"GET" Delegate:self Info:info MD5Dictionary:nil];
        
    }
    else
    {
        [self handleConnectionUnAvailable];
    }
}

- (void)requestTasksLists:(int)page pageSize:(int)pageSize keywords:(NSString*) keywords
{
    if (NetworkReachability.isConnectionAvailable)
    {
        methodId  = TasksList;
        datas = [[NSMutableData alloc]init];
        NSString *subUrlString = [NSString stringWithFormat:@"api/tasks"];
         NSMutableString *info = [[NSMutableString alloc]initWithString:[NSString stringWithFormat:@"page＝%d&pageSize=%d",page,pageSize]];
            [super requestWithSuburl:subUrlString Method:@"GET" Delegate:self Info:info MD5Dictionary:nil];
        
    }
    else
    {
        [self handleConnectionUnAvailable];
    }
}

- (void)requestChangeUserInfo:(NSMutableDictionary*)dict
{
    if (NetworkReachability.isConnectionAvailable)
    {
        methodId  = ChangeUserInfo;
        datas = [[NSMutableData alloc]init];
//        NSString *email = [dict   valueForKey:@"email"];
//        NSString *phone = [dict valueForKey:@"phone"];
//        NSString *company = [dict valueForKey:@"company"];
//        NSString *position = [dict valueForKey:@"position"];
//        NSString *signature = [dict valueForKey:@"signature"];
        ISSTUserModel *userModel = [AppCache getCache];
        if (userModel) {
            NSMutableString *info = [[NSMutableString alloc] init ];
            [dict enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
                if (obj!= nil) {
                    if ([obj isKindOfClass:[NSString class]]) {
                       // if (![obj isEqualToString:@""]) {
                            if ([key isEqualToString:@"email"] )//邮箱不能为空
                            {
                                [info appendString:[NSString stringWithFormat:@"email=%@&",obj]];
                            }
                            else if ([key isEqualToString:@"phone"] )//手机不能为空
                            {
                                [info appendString:[NSString stringWithFormat:@"phone=%@&",obj]];
                            }
                            else if ([key isEqualToString:@"qq"] && ! [userModel.qq  isEqualToString:obj])
                            {
                                [info appendString:[NSString stringWithFormat:@"qq=%@&",obj]];
                            }
                            else if([key isEqualToString:@"position"] && ! [userModel.position isEqualToString:obj])
                            {
                                [info appendString:[NSString stringWithFormat:@"position=%@&",obj]];
                            }
                            else if([key isEqualToString:@"signature"] && ! [userModel.signature isEqualToString:obj])
                            {
                                [info appendString:[NSString stringWithFormat:@"signature=%@&",obj]];
                            }
                            else if ([key isEqualToString:@"company"] && ! [userModel.company isEqualToString:obj])
                            {
                                [info appendString:[NSString stringWithFormat:@"company=%@&",obj]];
                            }
//                            else if ([key isEqualToString:@"cityId"]&&  userModel.cityId != [obj intValue]  )
//                            {
//                                [info appendString:[NSString stringWithFormat:@"cityId=%@&",obj]];
//                            }
//                            else if ([key isEqualToString:@"cityName"] && ! [userModel.cityName isEqualToString:obj])
//                            {
//                                [info appendString:[NSString stringWithFormat:@"cityName=%@&",obj]];
//                            }

                        }
                  //  }
                    if ([obj isKindOfClass:[NSNumber class]]) {
                        if ([key isEqualToString:@"privateQQ"] && userModel.privateQQ !=[obj boolValue]  )
                        {
                            [info appendString:[NSString stringWithFormat:@"privateQQ=%d&",[obj boolValue]?1:0]];
                        }
                        else if ([key isEqualToString:@"privateCompany"] && userModel.privateCompany !=[obj boolValue]  )
                        {
                            [info appendString:[NSString stringWithFormat:@"privateCompany=%d&",[obj boolValue]?1:0]];
                        }
                        else if ([key isEqualToString:@"privatePhone"] && userModel.privateCompany !=[obj boolValue]  )
                        {
                            [info appendString:[NSString stringWithFormat:@"privatePhone=%d&",[obj boolValue]?1:0]];
                        }
                        else if ([key isEqualToString:@"privatePosition"] && userModel.privateCompany !=[obj boolValue]  )
                        {
                            [info appendString:[NSString stringWithFormat:@"privatePosition=%d&",[obj boolValue]?1:0]];
                        }
                        else if ([key isEqualToString:@"cityId"]&&  userModel.cityId != [obj intValue]  )
                        {
                            [info appendString:[NSString stringWithFormat:@"cityId=%@&",obj]];
                        }


                    }
                }
//            if (obj != nil&& ![obj isEqualToString:@""] )
//            {
//                           }
        }];
        
        [info deleteCharactersInRange:NSMakeRange(info.length-1,1)];
        
        NSString *subUrlString = [NSString stringWithFormat:@"api/user"];
        [super requestWithSuburl:subUrlString Method:@"POST" Delegate:self Info:info MD5Dictionary:nil];
        }
    }
    else
    {
        [self handleConnectionUnAvailable];
    }
}
-  (void)handleConnectionUnAvailable
{
    //数据库解析，
    if ([self.webApiDelegate respondsToSelector:@selector(requestDataOnFail:)])
    {
        [self.webApiDelegate requestDataOnFail: [LoginErrors getNetworkProblem]];
    }
}


#pragma mark -
#pragma mark NSURLConnectionDelegate  methods

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@",[error localizedDescription]);
    [self.webApiDelegate requestDataOnFail:[LoginErrors checkNetworkConnection]];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
    NSDictionary *fields = [HTTPResponse allHeaderFields];
    NSLog(@"self=%@ fields=%@",self,[fields description]);
    if ([[fields allKeys] containsObject:@"Set-Cookie"])
    {
 
        cookie = [[[fields valueForKey:@"Set-Cookie"] componentsSeparatedByString:@";"] objectAtIndex:0];
    }
    [self.datas setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [datas appendData:data];
}


//请求完成
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    ISSTUserCenterParse *userCenterParse=[[ISSTUserCenterParse alloc]init];
    ISSTTasksParse *tasksParse = [[ISSTTasksParse alloc] init];
    NSDictionary *dics;
    
    id message;
    
    switch (methodId) {
        case ChangeUserInfo:
            dics   = [userCenterParse infoSerialization:datas];
            if (dics&&[dics count]>0)
            {
                int status =[userCenterParse getStatus];
                if (0 == status)//登录成功
                {
                    message = [userCenterParse messageInfoParse];
                   
                    if ([self.webApiDelegate respondsToSelector:@selector(requestDataOnSuccess:)])
                    {
                        [self.webApiDelegate requestDataOnSuccess:message];
                    }
                }
                else if(1 == status)
                {
                    if ([self.webApiDelegate respondsToSelector:@selector(requestDataOnFail:)])
                    {
                        [self.webApiDelegate requestDataOnFail:[LoginErrors getUnLoginMessage]];
                    }
                }
                else
                {
                    message = [userCenterParse messageInfoParse];
                    
                    if ([self.webApiDelegate respondsToSelector:@selector(requestDataOnFail:)])
                    {
                        [self.webApiDelegate requestDataOnSuccess:message];
                    }

                }
            }
            else//可能服务器宕掉
            {
                [self handleConnectionUnAvailable];
            }
            break;
            case TasksList:
            dics = [tasksParse infoSerialization:datas];
            NSLog(@"%@",dics);
            if (dics&&[dics count]>0) {
                int status = [tasksParse getStatus];
                if (0 == status) {
                    if (self.webApiDelegate &&[self.webApiDelegate respondsToSelector:@selector(requestDataOnSuccess:)]) {
                        [self.webApiDelegate requestDataOnSuccess:[tasksParse taskListsParse]];
                    }
                }
                else
                {
                    if (self.webApiDelegate &&[self.webApiDelegate respondsToSelector:@selector(requestDataOnFail:)]) {
                        [self.webApiDelegate requestDataOnSuccess:[tasksParse tasksMessageParse]];
                    }
                }
            }
            else//可能服务器宕掉
            {
                [self handleConnectionUnAvailable];
            }
            break;
            case Experience://由于格式一样，直接解析放到task里了，
            dics = [tasksParse infoSerialization:datas];
            NSLog(@"%@",dics);
            if (dics&&[dics count]>0) {
                int status = [tasksParse getStatus];
                if (0 == status) {
                    if (self.webApiDelegate &&[self.webApiDelegate respondsToSelector:@selector(requestDataOnSuccess:)]) {
                        [self.webApiDelegate requestDataOnSuccess:[tasksParse experienceListsParse]];
                    }
                }
                else
                {
                    if (self.webApiDelegate &&[self.webApiDelegate respondsToSelector:@selector(requestDataOnFail:)]) {
                        [self.webApiDelegate requestDataOnSuccess:[tasksParse tasksMessageParse]];
                    }
                }
            }
            else//可能服务器宕掉
            {
                [self handleConnectionUnAvailable];
            }
            break;
        
    
    }
}


@end
