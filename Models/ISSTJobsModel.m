//
//  ISSTJobsModel.m
//  ISST
//
//  Created by zhukang on 14-4-14.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTJobsModel.h"

@implementation ISSTJobsModel
@synthesize messageId,title,userId,updatedAt,userModel,description,cityId,location,startTime,expireTime,participated;


- (id)init
{
    if (self= [super init]) {
        
    }
    return self;
}

- (void)dealloc
{
    [title release];
    [updatedAt release];
    [userModel release];
    [description release];
    [location release];
    [startTime release];
    [expireTime release];
    [super dealloc];
}
@end
