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
      NSDictionary      *_userInfo;
}
@property (nonatomic,strong)NSDictionary *userInfo;
@end

@implementation UserLoginParse


@synthesize  userInfo;

- (id)init
{
    if (self = [super init]) {
       
    }
   return  self;
}



- (id)userInfoParse
{
     ISSTUserModel *user = [[[ISSTUserModel alloc]init] autorelease];
  
     userInfo = [super.dict objectForKey:@"body"];//get the user info content
    user.userId     = [[userInfo objectForKey:@"id"] intValue];
    user.userName   = [userInfo objectForKey:@"username"];
    user.name       = [userInfo objectForKey:@"name"];
    user.grade      = [[userInfo objectForKey:@"grade"]intValue];
    user.classId    = [[userInfo objectForKey:@"classId"]intValue];
    user.majorId    = [[userInfo objectForKey:@"majorId"]intValue];
    user.cityId     = [[userInfo objectForKey:@"cityId"]intValue];
    user.phone      = [userInfo objectForKey:@"phone"];
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
   
     user.className       = [userInfo objectForKey:@"className"];
 user.cityName       = [userInfo objectForKey:@"cityName"];
 user.majorName       = [userInfo objectForKey:@"major"];
    NSLog(@"gender=%d",user.gender);
    return user ;
}

-(void)dealloc
{

    _userInfo = nil ;

    [super dealloc];
}

@end
