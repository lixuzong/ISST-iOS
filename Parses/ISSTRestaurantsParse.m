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
    NSDictionary      *_dict;
    NSArray      *_restaurantsArray;
}
@property (nonatomic,strong)NSDictionary    *dict;
@property (nonatomic,strong)NSMutableArray         *restaurantsArray;
@property (nonatomic,strong)NSDictionary    *detailsInfo;

@end
@implementation ISSTRestaurantsParse
@synthesize  dict;
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
    NSMutableArray *tmpArray =[[NSMutableArray alloc]init] ;
    
    NSLog(@"%@",dict);
 restaurantsArray = [dict objectForKey:@"body"] ;//get the news info array
    int  count = [restaurantsArray count];
    NSLog(@"count=%d",count);
    for (int i=0; i<count; i++)
    {
        ISSTRestaurantsModel *restaurant = [[ISSTRestaurantsModel alloc]init];
        restaurant.restaurantsId     = [[[restaurantsArray objectAtIndex:i ] objectForKey:@"id"] intValue];
        restaurant.name              = [[restaurantsArray objectAtIndex:i] objectForKey:@"name"];
        restaurant.description       = [[restaurantsArray objectAtIndex:i] objectForKey:@"description"];
        restaurant.picture           = [[restaurantsArray objectAtIndex:i]objectForKey:@"picture"];
        restaurant.address           = [[restaurantsArray objectAtIndex:i] objectForKey:@"address"];
        restaurant.hotline           = [[restaurantsArray objectAtIndex:i]objectForKey:@"hotline"];
        restaurant.businessHours     = [[restaurantsArray objectAtIndex:i]objectForKey:@"businessHours"];
        [tmpArray addObject:restaurant];
    }
    return [tmpArray retain];

}


- (int)getStatus
{
    return [[dict objectForKey:@"status"]intValue];
}


-(id)restaurantsDetailsParse
{
    detailsInfo = [dict objectForKey:@"body"];
    ISSTRestaurantsModel *restaurantsDetailsModel = [[ISSTRestaurantsModel alloc]init];
   // ISSTRestaurantsModel *restaurant = [[[ISSTRestaurantsModel alloc]init]autorelease];
    restaurantsDetailsModel.restaurantsId     = [[detailsInfo objectForKey:@"id"] intValue];
    restaurantsDetailsModel.name              = [detailsInfo objectForKey:@"name"];
    restaurantsDetailsModel.description       = [detailsInfo objectForKey:@"description"];
    restaurantsDetailsModel.picture           = [detailsInfo objectForKey:@"picture"];
    restaurantsDetailsModel.address           = [detailsInfo objectForKey:@"address"];
    restaurantsDetailsModel.hotline           = [detailsInfo objectForKey:@"hotline"];
    restaurantsDetailsModel.businessHours     = [detailsInfo objectForKey:@"businessHours"];
    restaurantsDetailsModel.content           = [detailsInfo objectForKey:@"content"];
    return [restaurantsDetailsModel retain];
}


- (id)restaurantsSerialization:(NSData*)datas
{
    
    dict = [NSJSONSerialization JSONObjectWithData:datas options:NSJSONReadingAllowFragments error:nil];
    return dict;

}
@end
