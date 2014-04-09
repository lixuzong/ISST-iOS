//
//  ISSTRestaurantsModel.m
//  ISST
//
//  Created by XSZHAO on 14-4-5.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTRestaurantsModel.h"

@implementation ISSTRestaurantsModel
@synthesize restaurantsId,name,picture,address,hotline,businessHours,description,content;

- (void)dealloc
{
    [picture release];
  //  picture = nil;
    [name release];
  //  name = nil;
    [address release];
  //  address = nil;
    [hotline release];
   // hotline = nil;
    [businessHours release];
   // businessHours = nil;
    [description release];
   // description = nil;
    [content release];
   // content = nil;
    [super dealloc];
}
@end
