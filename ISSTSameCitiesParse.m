//
//  ISSTSameCitiesParse.m
//  ISST
//
//  Created by apple on 14-4-27.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTSameCitiesParse.h"
#import "ISSTUserModel.h"
#import "ISSTSameCitiesModel.h"
@interface ISSTSameCitiesParse()
{
    NSArray      *_citiesArray;
}
@property (nonatomic,strong)NSMutableArray          *citiesArray;
@property (nonatomic,strong)NSMutableDictionary     *userInfo;
@end

@implementation ISSTSameCitiesParse
@synthesize citiesArray,userInfo;
- (id)init
{
    if (self = [super init]) {
        
    }
    return  self;
}

-(id)citiesInfoParse
{
    NSMutableArray *tmpArray =[[[NSMutableArray alloc]init] autorelease];
    citiesArray = [super.dict objectForKey:@"body"];
    int  count = [citiesArray count];
    NSLog(@"count=%d",count);
    for (int i=0; i<count; i++)
    {
        ISSTUserModel *user=[[ISSTUserModel alloc] init];
        ISSTSameCitiesModel *citiesModel = [[[ISSTSameCitiesModel alloc]init] autorelease];
        citiesModel.cityId = [[[citiesArray objectAtIndex:i ] objectForKey:@"id"] intValue];
        citiesModel.cityName = [[citiesArray objectAtIndex:i] objectForKey:@"name"];
        citiesModel.userId=[[citiesArray objectAtIndex:i]objectForKey:@"userId"];
        userInfo=[[citiesArray objectAtIndex:i]objectForKey:@"user"];
        user.userId     = [[userInfo objectForKey:@"id"] intValue];
        user.name       = [userInfo objectForKey:@"name"];
        user.email      = [userInfo objectForKey:@"email"];
        user.qq         = [userInfo objectForKey:@"qq"];
        user.company   = [userInfo objectForKey:@"company"];
        user.position  = [userInfo objectForKey:@"position"];
        citiesModel.userModel=user;
        [tmpArray addObject:citiesModel];
        [user release];
    }
    return tmpArray ;
}
- (void)dealloc
{
    _citiesArray = nil;
    userInfo = nil;
    [super dealloc];
}

@end
