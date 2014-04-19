//
//  ISSTJobsDetailModel.m
//  ISST
//
//  Created by zhukang on 14-4-14.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTJobsDetailModel.h"

@implementation ISSTJobsDetailModel
@synthesize title,messageId,company,position,updatedAt,description,content,cityId,userModel,userId;

- (id)init
{
    if (self= [super init]) {
        
    }
    return self;
}

- (void)dealloc
{
    [title release];
    [company release];
    [position release];
    [updatedAt release];
    [description release];
    [content release];
    [userModel release];
    [super dealloc];
}

@end
