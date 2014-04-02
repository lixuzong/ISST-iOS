//
//  ISSTUserModel.m
//  ISST
//
//  Created by XSZHAO on 14-3-25.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTUserModel.h"

@implementation ISSTUserModel

@synthesize userId,userName,name,gender,grade,classId,majorId,cityId,email,qq,signature,position, company,cityPrincipal,privateCompany,privateEmail,privatePhone,privatePosition,privateQQ;

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
    [userName release];
    [name release];
    [email release];
    [qq release];
    [signature release];
    [position release];
    [company release];
    [super dealloc];
}


@end
