//
//  ISSTSameCitiesModel.m
//  ISST
//
//  Created by apple on 14-4-27.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTSameCitiesModel.h"
@implementation ISSTSameCitiesModel
@synthesize userId,userModel,cityId,cityName;
- (id)init
{
    self = [super init];
    if(self){
        
    }
    
    return self;
}
- (void)dealloc
{
   [cityName release];
    userModel = nil;//userModel maybe nil, release may be result error
    [super dealloc];
}
@end
