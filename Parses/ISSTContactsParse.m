//
//  ISSTContactsParse.m
//  ISST
//
//  Created by XSZHAO on 14-4-9.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTContactsParse.h"
#import "ISSTUserModel.h"
#import "ISSTClassModel.h"
#import "ISSTMajorModel.h"
#import "AppCache.h"
@interface ISSTContactsParse()
{
    NSArray      *_contactsArray;
}

@property (nonatomic,strong)NSMutableArray          *contactsArray;
@property (nonatomic,strong)NSMutableDictionary     *userInfo;
@property (nonatomic,strong)NSMutableArray          *classesOrMajoresArray;
@end

@implementation ISSTContactsParse
@synthesize classesOrMajoresArray,userInfo,contactsArray;
- (id)init
{
    if (self = [super init]) {
        
    }
    return  self;
}

-(id)contactsInfoParse
{
    NSMutableArray *tmpArray =[[[NSMutableArray alloc]init] autorelease];
    
    
    contactsArray = [super.dict objectForKey:@"body"];
    int  count = [contactsArray count];
    NSLog(@"count=%d",count);
    for (int i=0; i<count; i++)
    {
        ISSTUserModel *contactsModel = [[[ISSTUserModel alloc]init]autorelease];
        contactsModel.userId     = [[[contactsArray objectAtIndex:i ] objectForKey:@"id"] intValue];
        contactsModel.name              = [[contactsArray objectAtIndex:i] objectForKey:@"name"];
        [tmpArray addObject:contactsModel];
    }
    return tmpArray ;
}

-(id)contactDetailsParse
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
    user.className  = [userInfo objectForKey:@"className"];
    user.majorName  = [userInfo objectForKey:@"major"];
    user.cityName   = [userInfo objectForKey:@"cityName"];
    user.gender     = ([[userInfo objectForKey:@"gender"]intValue] == 1)? MALE:FAMALE;//枚举
    NSLog(@"gender=%d",user.gender);
    return user;
}

-(id)classesInfoParse
{
    NSMutableArray *tmpArray =[[[NSMutableArray alloc]init] autorelease];
    classesOrMajoresArray = [super.dict objectForKey:@"body"];
    int  count = [classesOrMajoresArray count];
    NSLog(@"count=%d",count);
    for (int i=0; i<count; i++)
    {
//        ISSTClassModel *classModel = [[[ISSTClassModel  alloc]init]autorelease];
//        classModel.classId         = [[[classesOrMajoresArray objectAtIndex:i ] objectForKey:@"id"] intValue];
//        classModel.name            = [[classesOrMajoresArray objectAtIndex:i] objectForKey:@"name"];
        [tmpArray addObject:[[classesOrMajoresArray objectAtIndex:i] objectForKey:@"name"]];
    }
    [AppCache saveClassListsCache:tmpArray];
    return tmpArray ;
}


-(id)majorsInfoParse
{
    
    NSMutableArray *tmpArray =[[[NSMutableArray alloc]init] autorelease];
    classesOrMajoresArray = [super.dict objectForKey:@"body"];
    int count = 0;
    count = [classesOrMajoresArray count];
    NSLog(@"count=%d",count);
    for (int i=0; i<count; i++)
    {
//        ISSTMajorModel *majorModel = [[[ISSTMajorModel  alloc]init]autorelease];
//        majorModel.majorId         = [[[classesOrMajoresArray objectAtIndex:i ] objectForKey:@"id"] intValue];
//        majorModel.name            = [[classesOrMajoresArray objectAtIndex:i] objectForKey:@"name"];
//      //  [tmpArray addObject:majorModel];
      [tmpArray addObject:[[classesOrMajoresArray objectAtIndex:i] objectForKey:@"name"]];
    }
    [AppCache saveMajorListsCache:tmpArray];
    return tmpArray;
}

- (void)dealloc
{
    _contactsArray = nil;
    userInfo = nil;
    [super dealloc];
}
@end
