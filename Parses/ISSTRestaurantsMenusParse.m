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

@property (nonatomic,strong)NSMutableArray         *restaurantsMenusArray;
@property (nonatomic,strong)NSDictionary    *detailsInfo;

@end

@implementation ISSTRestaurantsMenusParse

@synthesize detailsInfo,restaurantsMenusArray;

- (id)init
{
    if (self = [super init]) {
        
    }
    return  self;
}

-(id)restaurantsMenusInfoParse
{
    NSMutableArray *tmpArray =[[NSMutableArray alloc]init];
    
    //NSLog(@"%@",dict);
    restaurantsMenusArray = [super.dict objectForKey:@"body"] ;
    int  count = [restaurantsMenusArray count];
    NSLog(@"count=%d",count);
    int i;
    for ( i=0; i<count; i++)
    {
        ISSTRestaurantsMenusModel *restaurant = [[ISSTRestaurantsMenusModel alloc]init];
    
        restaurant.name              = [[restaurantsMenusArray objectAtIndex:i] objectForKey:@"name"];
        restaurant.description       = [[restaurantsMenusArray objectAtIndex:i] objectForKey:@"description"];
        restaurant.picture           = [[restaurantsMenusArray objectAtIndex:i]objectForKey:@"picture"];
        restaurant.price           = [[[restaurantsMenusArray objectAtIndex:i] objectForKey:@"price"]floatValue];
        [tmpArray addObject:restaurant];
        [restaurant release];
    }
    return [tmpArray autorelease] ;
}

- (void)dealloc
{
    detailsInfo = nil;
    restaurantsMenusArray = nil;
    [super dealloc];
}

@end
