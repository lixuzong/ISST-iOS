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
#import "TFHpple.h"
@interface ISSTCampusNewsParse()
{
    NSDictionary      *_dict;
    NSArray      *_campusNewsArray;
}
@property (nonatomic,strong)NSDictionary    *dict;
@property (nonatomic,strong)NSArray         *campusNewsArray;
@property (nonatomic,strong)NSDictionary    *detailsInfo;

@end

@implementation ISSTCampusNewsParse
@synthesize  dict;
@synthesize  campusNewsArray;
@synthesize detailsInfo;

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

- (int)getStatus
{
    return [[dict objectForKey:@"status"]intValue];
}


- (id)campusNewsInfoParse
{
    NSMutableArray *newsArray =[[NSMutableArray alloc]init] ;
    
    NSLog(@"%@",dict);
    campusNewsArray = [dict objectForKey:@"body"] ;//get the news info array
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
       // spittle.SCposttime = [dateFormatter stringFromDate:datePT];

        
        
        campusNews.updatedAt  = [dateFormatter stringFromDate:datePT];//[[[campusNewsArray objectAtIndex:i ] objectForKey:@"updatedAt"]longLongValue];
        campusNews.userId     = [[[campusNewsArray objectAtIndex:i ] objectForKey:@"userId"]intValue];
        campusNews.categoryId     = [[[campusNewsArray objectAtIndex:i ] objectForKey:@"categoryId"]intValue];
        [newsArray addObject:campusNews];
    }
    return [newsArray retain];
}

-(id)newsDetailsParse
{
    detailsInfo = [dict objectForKey:@"body"];
    ISSTNewsDetailsModel *newsDetailsModel = [[ISSTNewsDetailsModel alloc]init];
    NSLog(@"class=%@ \n content=%@",self,[detailsInfo objectForKey:@"content"]);
     NSData *htmlData=[ [detailsInfo objectForKey:@"content"]dataUsingEncoding:NSUTF8StringEncoding];
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
    NSArray *elements  = [xpathParser searchWithXPathQuery:@"//a"];
 
    for (TFHppleElement *element in elements) {
        
        if ([element attributes]) {
            newsDetailsModel.content =[[element attributes]objectForKey:@"href"];
        }
    }
    
    newsDetailsModel.content = [detailsInfo objectForKey:@"content"];
    newsDetailsModel.title = [detailsInfo objectForKey:@"title"];
    newsDetailsModel.description = [detailsInfo objectForKey:@"description"];
    return [newsDetailsModel retain];
}


- (void)dealloc
{
    //[detailsInfo release];
    //[dict release];
  //  [campusNewsArray release];
    [super dealloc];
}

@end
