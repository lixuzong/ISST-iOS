//
//  ISSTCampusNewsParse.m
//  ISST
//
//  Created by XSZHAO on 14-3-31.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTCampusNewsParse.h"
#import "ISSTCampusNewsModel.h"

@interface ISSTCampusNewsParse()
{
    NSDictionary      *_dict;
    NSArray      *_campusNewsArray;
}
@property (nonatomic,strong)NSDictionary *dict;
@property (nonatomic,strong)NSArray *campusNewsArray;
@end

@implementation ISSTCampusNewsParse
@synthesize  dict;
@synthesize  campusNewsArray;


- (id)init
{
    if (self = [super init]) {
        
    }
    return  self;
}

- (id)campusNewsSerialization:(NSData*)datas
{
    dict = [NSJSONSerialization JSONObjectWithData:datas options:NSJSONReadingAllowFragments error:nil];
    return dict;
}

- (id)campusNewsInfoParse//:(NSData *)datas
{
    NSMutableArray *newsArray =[[NSMutableArray alloc]init] ;
    
    NSLog(@"%@",dict);
    campusNewsArray = [dict objectForKey:@"body"] ;//get the news info array
    int  count = [campusNewsArray count];
    NSLog(@"count=%d",count);
    for (int i=0; i<count; i++)
    {
        
         ISSTCampusNewsModel *campusNews = [[ISSTCampusNewsModel alloc]init];
        campusNews.newsId     = [[[campusNewsArray objectAtIndex:i ] objectForKey:@"id"] intValue];
        campusNews.title      = [[campusNewsArray objectAtIndex:i] objectForKey:@"title"];
        campusNews.description= [[campusNewsArray objectAtIndex:i] objectForKey:@"description"];
        campusNews.updatedAt  = [[[campusNewsArray objectAtIndex:i ] objectForKey:@"updatedAt"]intValue];
        campusNews.userId     = [[[campusNewsArray objectAtIndex:i ] objectForKey:@"userId"]intValue];
        campusNews.categoryId     = [[[campusNewsArray objectAtIndex:i ] objectForKey:@"categoryId"]intValue];
        [newsArray addObject:campusNews];
    }
    return [newsArray retain];
}




@end
