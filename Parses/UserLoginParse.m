//
//  UserLoginParse.m
//  ISST
//
//  Created by XSZHAO on 14-3-25.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//
#import "ISSTUserModel.h"
#import "UserLoginParse.h"



@interface UserLoginParse()
{
      NSDictionary      *_dict;
      NSDictionary      *_userInfo;
}
@property (nonatomic,strong)NSDictionary *dict;
@property (nonatomic,strong)NSDictionary *userInfo;
@end

@implementation UserLoginParse

@synthesize  dict;
@synthesize  userInfo;

- (id)init
{
    if (self = [super init]) {
       
    }
   return  self;
}

- (NSDictionary*)loginSerialization:(NSData*)datas
{
  dict = [NSJSONSerialization JSONObjectWithData:datas options:NSJSONReadingAllowFragments error:nil];
    return dict;
}

- (id)userInfoParse//:(NSData *)datas
{
    NSLog(@"userInfoParse.dict:%@",dict);
    ISSTUserModel *user = [[ISSTUserModel alloc]init];
    //serId,userName,name,gender,grade,classId,majorId,cityId,email,qq,signature,company,cityPrincipal,privateCompany,privateEmail,privatePhone,privatePosition,privateQQ;
    NSLog(@"%@",dict);
     userInfo = [dict objectForKey:@"body"];//get the user info content
    user.userId     = [[userInfo objectForKey:@"id"] intValue];
    user.userName   = [userInfo objectForKey:@"username"];
    user.name       = [userInfo objectForKey:@"name"];
    user.grade      = [[userInfo objectForKey:@"grade"]intValue];
    user.classId    = [[userInfo objectForKey:@"classId"]intValue];
    user.majorId    = [[userInfo objectForKey:@"majorId"]intValue];
    user.cityId     = [[userInfo objectForKey:@"cityId"]intValue];
    user.email      = [userInfo objectForKey:@"email"];
    user.qq         = [userInfo objectForKey:@"qq"];
    user.position   = [userInfo objectForKey:@"position"];
    user.signature  = [userInfo objectForKey:@"signature"];
    user.cityPrincipal  = [[userInfo objectForKey:@"cityPrincipal"] boolValue];
    user.privateQQ      = [[userInfo objectForKey:@"privateOQ"]boolValue];
    user.privateEmail   = [[userInfo objectForKey:@"privateEmail"]boolValue];
    user.privatePhone   = [[userInfo objectForKey:@"privatePhone"]boolValue];
    user.privatePosition= [[userInfo objectForKey:@"privatePosition"]boolValue];
    user.privateCompany = [[userInfo objectForKey:@"privateCompany"]boolValue];
    user.gender     = ([[userInfo objectForKey:@"gender"]intValue] == 1)? MALE:FAMALE;//枚举
    NSLog(@"gender=%d",user.gender);
    return [user autorelease];
}

- (BOOL)loginSuccessOrNot:(NSData *)datas
{/*
  {
  code = 1;
  message = "";
  }
  */
    
    dict = [UserLoginParse loginSerialization:datas];
    NSLog(@"loginSuccessOrNot.dict:%@",dict);
    NSString *codeString  = [dict objectForKey:@"code"];
    NSLog(@"code=%d",[codeString intValue]);
    return [codeString intValue]>0?YES:NO;
    
}

- (NSString *)loginFailMessage:(NSData *)datas
{
    dict = (NSDictionary*)[self loginSerialization:datas];
    NSLog(@"loginFailMessage.dict:%@",dict);
    NSString *messageString  = [dict objectForKey:@"message"];
    NSLog(@"code=%@",messageString);
    return messageString;
    
}

- (NSString *)getloginSuccessUserId:(NSData *)datas
{
    dict = (NSDictionary*)[self loginSerialization:datas];
    // NSLog(@"getloginSuccessUserId:%@",dict);
    NSString *codeString  = [dict objectForKey:@"code"];
    NSLog(@"code=%d",[codeString intValue]);
    return codeString;
}

-(void)dealloc
{
    [self.dict release];
    self.dict = nil;
    [self.userInfo release];
    self.dict = nil;
    [super dealloc];
}

@end
