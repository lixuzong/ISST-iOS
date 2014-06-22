//
//  ISSTActivityStatus.m
//  ISST
//
//  Created by apple on 14-6-21.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTActivityStatusModel.h"

@implementation ISSTActivityStatusModel
@synthesize  statusMessage,statusId;
- (id)init
{
    self = [super init];
    if(self){
        
    }
    
    return self;
}
- (void)dealloc
{
    [statusMessage release];
    statusMessage = nil;//userModel maybe nil, release may be result error
    [super dealloc];
}
@end
