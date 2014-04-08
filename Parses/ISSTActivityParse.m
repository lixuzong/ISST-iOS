//
//  ISSTActivityParse.m
//  ISST
//
//  Created by XSZHAO on 14-4-7.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTActivityParse.h"
#import "ISSTActivityModel.h"
@interface ISSTActivityParse()
{
    
    NSArray      *_activitiesArray;
}

@property (nonatomic,strong)NSMutableArray         *activitiesArray;
@property (nonatomic,strong)NSDictionary    *detailsInfo;

@end
@implementation ISSTActivityParse

@synthesize activitiesArray,detailsInfo;

- (id)init
{
    if (self = [super init]) {
        
    }
    return  self;
}

-(id)activityInfoParse
{
    NSMutableArray *tmpArray =[[NSMutableArray alloc]init] ;
    
    
    activitiesArray = [super.dict objectForKey:@"body"] ;//get the news info array
    int  count = [activitiesArray count];
    NSLog(@"count=%d",count);
    for (int i=0; i<count; i++)
    {
        ISSTActivityModel *activity = [[ISSTActivityModel alloc]init];
        activity.activityId     = [[[activitiesArray objectAtIndex:i ] objectForKey:@"id"] intValue];
        activity.title              = [[activitiesArray objectAtIndex:i] objectForKey:@"title"];
        activity.description       = [[activitiesArray objectAtIndex:i] objectForKey:@"description"];
        activity.picture           = [[activitiesArray objectAtIndex:i]objectForKey:@"picture"];
        activity.content           = [[activitiesArray objectAtIndex:i] objectForKey:@"content"];
        [tmpArray addObject:activity];
    }
    return [tmpArray retain];

}


-(id)activityDetailsParse
{
    detailsInfo = [super.dict objectForKey:@"body"];
   ISSTActivityModel *activityDetailModel = [[ISSTActivityModel alloc]init];
    activityDetailModel.activityId     = [[detailsInfo objectForKey:@"id"] intValue];
    activityDetailModel.title              = [detailsInfo objectForKey:@"title"];
    activityDetailModel.description       = [detailsInfo objectForKey:@"description"];
    activityDetailModel.picture           = [detailsInfo objectForKey:@"picture"];
    activityDetailModel.content           = [detailsInfo objectForKey:@"content"];
    return [activityDetailModel retain];

}


- (void)dealloc
{
    [super dealloc];
}
@end
