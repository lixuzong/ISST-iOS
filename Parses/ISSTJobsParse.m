//
//  ISSTJobsParse.m
//  ISST
//
//  Created by zhukang on 14-4-14.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTJobsParse.h"
#import "ISSTJobsModel.h"
#import "ISSTJobsDetailModel.h"
@interface ISSTJobsParse()
{
    NSArray      *_jobsArray;
}

@property (nonatomic,strong)NSArray         *jobsArray;
@property (nonatomic,strong)NSDictionary    *detailsInfo;

@end
@implementation ISSTJobsParse
@synthesize jobsArray;
@synthesize detailsInfo;
- (id)init
{
    if (self = [super init]) {
        
    }
    return  self;
}

-(id)jobsInfoParse
{
    NSMutableArray *tempJobsArray =[[[NSMutableArray alloc]init] autorelease];
    
    // NSLog(@"%@",dict);
    jobsArray = [super.dict objectForKey:@"body"] ;
    int  count = [jobsArray count];
    NSLog(@"count=%d",count);
    for (int i=0; i<count; i++)
    {
        
        ISSTJobsModel *jobsModel = [[[ISSTJobsModel alloc]init]autorelease];
        jobsModel .messageId = [[[jobsArray objectAtIndex:i ] objectForKey:@"id"] intValue];
        jobsModel .title= [[jobsArray objectAtIndex:i] objectForKey:@"title"];
        jobsModel .company= [[jobsArray objectAtIndex:i] objectForKey:@"company"];
        jobsModel .userId=[[[jobsArray objectAtIndex:i ] objectForKey:@"userId"] intValue];
        
        
        long long  updatedAt =  [[[jobsArray objectAtIndex:i] objectForKey:@"updatedAt"]longLongValue]/1000;
        
        NSDate  *datePT = [NSDate dateWithTimeIntervalSince1970:updatedAt];
      
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        jobsModel .updatedAt  = [dateFormatter stringFromDate:datePT];
        [dateFormatter release];
        
        [tempJobsArray addObject:jobsModel];
    }
    return tempJobsArray;

}
-(id)jobsDetailInfoParse
{
    detailsInfo = [super.dict objectForKey:@"body"];
    ISSTJobsDetailModel *jobsDetailModel = [[[ISSTJobsDetailModel alloc]init] autorelease];
    NSLog(@"class=%@ \n content=%@",self,[detailsInfo objectForKey:@"content"]);
    
    jobsDetailModel.content = [detailsInfo objectForKey:@"content"];
    jobsDetailModel.title= [detailsInfo objectForKey:@"title"];
    jobsDetailModel.description = [detailsInfo objectForKey:@"description"];
    jobsDetailModel.messageId=[[detailsInfo objectForKey:@"id"]intValue];
    jobsDetailModel.company=[detailsInfo objectForKey:@"company"];
    jobsDetailModel.position=[detailsInfo objectForKey:@"position"];
    long long  updatedAt =  [[detailsInfo objectForKey:@"updatedAt"]longLongValue]/1000;
    
    NSDate  *datePT = [NSDate dateWithTimeIntervalSince1970:updatedAt];
   
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    jobsDetailModel.updatedAt=[dateFormatter stringFromDate:datePT];
    [dateFormatter release];
    
    return jobsDetailModel ;
    
}

- (void)dealloc
{
    detailsInfo = nil ;
    
    _jobsArray = nil;
    [super dealloc];
}

@end
