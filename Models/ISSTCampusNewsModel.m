//
//  ISSTCampusNews.m
//  ISST
//
//  Created by XSZHAO on 14-3-31.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTCampusNewsModel.h"

@implementation ISSTCampusNewsModel
@synthesize title,description,updatedAt,userId,newsId,categoryId,userModel;

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
    [title release];
    [description release];
    [updatedAt release];
    [userModel release];
    [super dealloc];
}

@end
