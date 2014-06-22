//
//  ISSTActivitiesModel.m
//  ISST
//
//  Created by XSZHAO on 14-4-7.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTActivityModel.h"

@implementation ISSTActivityModel

@synthesize cityId,title,picture,activityId,location,startTime,expireTime,updateAt,content,participated,releaseUserModel;
- (id)init
{
    if (self= [super init]) {
        
    }
    return self;
}

- (void)dealloc
{
    [title release];
   // title=nil;
    [picture release];
   // picture = nil;
    [location release];
    //description = nil;
   // content = nil;
    [startTime release];
    [expireTime release];
    [updateAt release];
    [content release];
    [releaseUserModel release];
    [super dealloc];
}


@end
