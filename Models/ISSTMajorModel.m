//
//  ISSTMajorModel.m
//  ISST
//
//  Created by XSZHAO on 14-4-9.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTMajorModel.h"

@implementation ISSTMajorModel
@synthesize majorId,name;
- (id)init
{
    self = [super init];
    if(self){
        
    }
    
    return self;
}


- (void)dealloc
{
    name = nil;
    [super dealloc];
}
@end
