//
//  ISSTActivitiesModel.m
//  ISST
//
//  Created by XSZHAO on 14-4-7.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTActivityModel.h"

@implementation ISSTActivityModel

@synthesize title,picture,description,content;
- (id)init
{
    if (self= [super init]) {
        
    }
    return self;
}

- (void)dealloc
{
    [title release];
    title=nil;
    [picture release];
    picture = nil;
    [description release];
    description = nil;
    [content release];
    content = nil;
    [super dealloc];
}


@end
