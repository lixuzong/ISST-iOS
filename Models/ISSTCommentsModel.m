//
//  CommentsModel.m
//  ISST
//
//  Created by XSZHAO on 14-4-19.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTCommentsModel.h"

@implementation ISSTCommentsModel
@synthesize commentsId,title,createdAt,userModel,content;
- (id)init
{
    self = [super init];
    if(self){
        
    }
    
    return self;
}


- (void)dealloc
{
    [title release];
    [createdAt release];
    [content release];
    userModel = nil;//userModel maybe nil, release may be result error
    
    [super dealloc];
}

@end
