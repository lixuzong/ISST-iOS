//
//  ISSTCampusNewsParse.m
//  ISST
//
//  Created by XSZHAO on 14-3-31.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTCampusNewsParse.h"
#import "ISSTCampusNewsModel.h"
#import "ISSTNewsDetailsModel.h"


@interface ISSTCampusNewsParse()
{
    NSArray      *_campusNewsArray;
}

@property (nonatomic,strong)NSArray         *campusNewsArray;
@property (nonatomic,strong)NSDictionary    *detailsInfo;
@property(nonatomic,strong)NSDictionary *userInfo;
@end

@implementation ISSTCampusNewsParse
//@synthesize  dict;
@synthesize  campusNewsArray;
@synthesize detailsInfo;
@synthesize userInfo;

- (id)init
{
    if (self = [super init]) {
        
    }
    return  self;
}




- (id)campusNewsInfoParse
{
    NSMutableArray *newsArray =[[[NSMutableArray alloc]init] autorelease];
    
   // NSLog(@"%@",dict);
    campusNewsArray = [super.dict objectForKey:@"body"] ;
    int  count = [campusNewsArray count];
    NSLog(@"count=%d",count);
    for (int i=0; i<count; i++)
    {
        
         ISSTCampusNewsModel *campusNews = [[[ISSTCampusNewsModel alloc]init]autorelease];
        campusNews.newsId     = [[[campusNewsArray objectAtIndex:i ] objectForKey:@"id"] intValue];
        campusNews.title      = [[campusNewsArray objectAtIndex:i] objectForKey:@"title"];
        campusNews.description= [[campusNewsArray objectAtIndex:i] objectForKey:@"description"];
        
        long long  updatedAt =  [[[campusNewsArray objectAtIndex:i] objectForKey:@"updatedAt"]longLongValue]/1000;
        
        NSDate  *datePT = [NSDate dateWithTimeIntervalSince1970:updatedAt];
       
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        campusNews.updatedAt  = [dateFormatter stringFromDate:datePT];
        [dateFormatter release];
        
        campusNews.userId     = [[[campusNewsArray objectAtIndex:i ] objectForKey:@"userId"]intValue];
        campusNews.categoryId     = [[[campusNewsArray objectAtIndex:i ] objectForKey:@"categoryId"]intValue];
        NSLog(@"%@",userInfo);
        if(campusNews.userId>0)
        {
        campusNews.userModel=(NSDictionary *)[[campusNewsArray objectAtIndex:i]objectForKey:@"user"];
        }
        [newsArray addObject:campusNews];
    }
    return newsArray;
}

-(id)newsDetailsParse
{
    detailsInfo = [super.dict objectForKey:@"body"];
    ISSTNewsDetailsModel *newsDetailsModel = [[[ISSTNewsDetailsModel alloc]init] autorelease];
    NSLog(@"class=%@ \n content=%@",self,[detailsInfo objectForKey:@"content"]);

    newsDetailsModel.content = [detailsInfo objectForKey:@"content"];
    newsDetailsModel.title = [detailsInfo objectForKey:@"title"];
    newsDetailsModel.description = [detailsInfo objectForKey:@"description"];
    newsDetailsModel.userId=[[detailsInfo objectForKey:@"userId"]intValue];
    long long  updatedAt =  [[detailsInfo objectForKey:@"updatedAt"]longLongValue]/1000;
    NSDate  *datePT = [NSDate dateWithTimeIntervalSince1970:updatedAt];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    newsDetailsModel.updatedAt  = [dateFormatter stringFromDate:datePT];
     [dateFormatter release];
    if(newsDetailsModel.userId>0)
    {
    newsDetailsModel.userModel=(NSDictionary *)[detailsInfo objectForKey:@"user"];
    }

    return newsDetailsModel ;
}


- (void)dealloc
{
    detailsInfo = nil ;
    userInfo=nil;
   _campusNewsArray = nil;
    [super dealloc];
}

@end
