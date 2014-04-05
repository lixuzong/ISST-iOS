//
//  ISSTRestaurantsMenusParse.m
//  ISST
//
//  Created by XSZHAO on 14-4-5.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTRestaurantsMenusParse.h"
#import "ISSTRestaurantsMenusModel.h"
@interface ISSTRestaurantsMenusParse()
{
    NSDictionary      *_dict;
    NSArray      *_restaurantsArray;
}
@property (nonatomic,strong)NSDictionary    *dict;
@property (nonatomic,strong)NSMutableArray         *restaurantsMenusArray;
@property (nonatomic,strong)NSDictionary    *detailsInfo;

@end

@implementation ISSTRestaurantsMenusParse

@synthesize detailsInfo,restaurantsMenusArray,dict;

- (id)init
{
    if (self = [super init]) {
        
    }
    return  self;
}

-(id)restaurantsMenusInfoParse
{
    NSMutableArray *tmpArray =[[NSMutableArray alloc]init] ;
    
    NSLog(@"%@",dict);
    restaurantsMenusArray = [dict objectForKey:@"body"] ;//get the news info array
    int  count = [restaurantsMenusArray count];
    NSLog(@"count=%d",count);
    for (int i=0; i<count; i++)
    {
        ISSTRestaurantsMenusModel *restaurant = [[ISSTRestaurantsMenusModel alloc]init];
    
        restaurant.name              = [[restaurantsMenusArray objectAtIndex:i] objectForKey:@"name"];
        restaurant.description       = [[restaurantsMenusArray objectAtIndex:i] objectForKey:@"description"];
        restaurant.picture           = [[restaurantsMenusArray objectAtIndex:i]objectForKey:@"picture"];
        restaurant.price           = [[[restaurantsMenusArray objectAtIndex:i] objectForKey:@"price"]floatValue];
        [tmpArray addObject:restaurant];
    }
    return [tmpArray retain];
}

- (int)getStatus
{
   return [[dict objectForKey:@"status"]intValue];}

- (id)restaurantsMenusSerialization:(NSData*)datas
{
    dict = [NSJSONSerialization JSONObjectWithData:datas options:NSJSONReadingAllowFragments error:nil];
    return dict;
}
@end
