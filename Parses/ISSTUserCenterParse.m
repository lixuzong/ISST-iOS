//
//  ISSTUserCenterParse.m
//  ISST
//
//  Created by zhaoxs on 6/21/14.
//  Copyright (c) 2014 MSE.ZJU. All rights reserved.
//

#import "ISSTUserCenterParse.h"

@implementation ISSTUserCenterParse

- (id)init
{
    if (self = [super init]) {
        
    }
    return  self;
}



-(id)messageInfoParse
{
    return [super.dict objectForKey:@"message"];

    
    
//    restaurantsArray = [super.dict objectForKey:@"body"] ;
//    int  count = [restaurantsArray count];
//    NSLog(@"count=%d",count);
//    for (int i=0; i<count; i++)
//    {
//        ISSTRestaurantsModel *restaurant = [[[ISSTRestaurantsModel alloc]init]autorelease];
//        restaurant.restaurantsId     = [[[restaurantsArray objectAtIndex:i ] objectForKey:@"id"] intValue];
//        restaurant.name              = [[restaurantsArray objectAtIndex:i] objectForKey:@"name"];
//        restaurant.description       = [[restaurantsArray objectAtIndex:i] objectForKey:@"description"];
//        restaurant.picture           = [[restaurantsArray objectAtIndex:i]objectForKey:@"picture"];
//        restaurant.address           = [[restaurantsArray objectAtIndex:i] objectForKey:@"address"];
//        restaurant.hotline           = [[restaurantsArray objectAtIndex:i]objectForKey:@"hotline"];
//        restaurant.businessHours     = [[restaurantsArray objectAtIndex:i]objectForKey:@"businessHours"];
//        [tmpArray addObject:restaurant];
//    }   return tmpArray ;
}




@end
