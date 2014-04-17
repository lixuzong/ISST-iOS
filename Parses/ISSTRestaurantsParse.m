//
//  RestaurantsParse.m
//  ISST
//
//  Created by XSZHAO on 14-4-5.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTRestaurantsParse.h"
#import "ISSTRestaurantsModel.h"
@interface ISSTRestaurantsParse()
{

    NSArray      *_restaurantsArray;
}

@property (nonatomic,strong)NSMutableArray         *restaurantsArray;
@property (nonatomic,strong)NSDictionary    *detailsInfo;

@end
@implementation ISSTRestaurantsParse

@synthesize  restaurantsArray;
@synthesize detailsInfo;

- (id)init
{
    if (self = [super init]) {
        
    }
    return  self;
}


-(id)restaurantsInfoParse
{
    NSMutableArray *tmpArray =[[[NSMutableArray alloc]init]autorelease] ;
    
   
 restaurantsArray = [super.dict objectForKey:@"body"] ;
    int  count = [restaurantsArray count];
    NSLog(@"count=%d",count);
    for (int i=0; i<count; i++)
    {
        ISSTRestaurantsModel *restaurant = [[[ISSTRestaurantsModel alloc]init]autorelease];
        restaurant.restaurantsId     = [[[restaurantsArray objectAtIndex:i ] objectForKey:@"id"] intValue];
        restaurant.name              = [[restaurantsArray objectAtIndex:i] objectForKey:@"name"];
        restaurant.description       = [[restaurantsArray objectAtIndex:i] objectForKey:@"description"];
        restaurant.picture           = [[restaurantsArray objectAtIndex:i]objectForKey:@"picture"];
        restaurant.address           = [[restaurantsArray objectAtIndex:i] objectForKey:@"address"];
        restaurant.hotline           = [[restaurantsArray objectAtIndex:i]objectForKey:@"hotline"];
        restaurant.businessHours     = [[restaurantsArray objectAtIndex:i]objectForKey:@"businessHours"];
        [tmpArray addObject:restaurant];
    }
    return tmpArray ;
}





-(id)restaurantsDetailsParse
{
    detailsInfo = [super.dict objectForKey:@"body"];
    ISSTRestaurantsModel *restaurantsDetailsModel = [[[ISSTRestaurantsModel alloc]init] autorelease];
   // ISSTRestaurantsModel *restaurant = [[[ISSTRestaurantsModel alloc]init]autorelease];
    restaurantsDetailsModel.restaurantsId     = [[detailsInfo objectForKey:@"id"] intValue];
    restaurantsDetailsModel.name              = [detailsInfo objectForKey:@"name"];
    restaurantsDetailsModel.description       = [detailsInfo objectForKey:@"description"];
    restaurantsDetailsModel.picture           = [detailsInfo objectForKey:@"picture"];
    restaurantsDetailsModel.address           = [detailsInfo objectForKey:@"address"];
    restaurantsDetailsModel.hotline           = [detailsInfo objectForKey:@"hotline"];
    restaurantsDetailsModel.businessHours     = [detailsInfo objectForKey:@"businessHours"];
    restaurantsDetailsModel.content           = [detailsInfo objectForKey:@"content"];
    return restaurantsDetailsModel ;
}

- (void)dealloc
{
    _restaurantsArray = nil;
    detailsInfo = nil;
    [super dealloc];
}

@end
