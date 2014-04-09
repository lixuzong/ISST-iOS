//
//  ISSTRestaurantsMenusModel.m
//  ISST
//
//  Created by XSZHAO on 14-4-5.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTRestaurantsMenusModel.h"

@implementation ISSTRestaurantsMenusModel
@synthesize name,picture,description,price;
- (void)dealloc
{
    [picture release];
   // picture = nil;
    [name release];
   // name = nil;
    [description release];
   // description = nil;
      [super dealloc];
}
@end
