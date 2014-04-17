//
//  ISSTNewsDetailsModel.m
//  ISST
//
//  Created by XSZHAO on 14-4-2.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTNewsDetailsModel.h"

@implementation ISSTNewsDetailsModel
@synthesize content,description,title,userModel,updatedAt,userId;

- (id)init
{
    self = [super init];
    if(self){
        ;
    }
    
    return self;
}

- (void)dealloc
{
    [content release];
    [userModel release];
    [updatedAt release];
    [description release];
    [title release];
    [super dealloc];
}
@end
