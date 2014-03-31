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
    
  

    
    /*
     {
     categoryId = 4;
     content = "<null>";
     description = "\U5404\U4f4d\U7814\U7a76\U751f\Uff1a2014\U5e746\U6708\U5168\U56fd\U5927\U5b66\U82f1\U8bed\U3001\U5fb7\U8bed\U3001\U6cd5\U8bed\U3001\U65e5\U8bed\U3001\U4fc4\U8bed\U56db\U7ea7\Uff0c\U82f1\U8bed\U3001\U5fb7\U8bed\U3001\U65e5\U8bed\U3001\U4fc4\U8bed\U516d\U7ea7\Uff0c\U7701\U5927";
     id = 585;
     picture = "<null>";
     status = 0;
     title = "\U5173\U4e8e2014\U5e746\U6708\U5927\U5b66\U5916\U8bed\U7b49\U7ea7\U8003\U8bd5\U62a5\U540d\U7684\U901a\U77e5";
     updatedAt = 1394668800000;
     user = "<null>";
     userId = 0;
     }
     */
    NSMutableArray *newsArray = [[NSMutableArray alloc]init];
    
    NSLog(@"%@",dict);
    campusNewsArray = [[dict objectForKey:@"body"]autorelease];//get the news info array
    int  count = [campusNewsArray count];
    NSLog(@"count=%d",count);
    for (int i=0; i<count; i++)
    {
        
         ISSTCampusNewsModel *campusNews = [[[ISSTCampusNewsModel alloc]init]autorelease];
        campusNews.newsId     = [[[campusNewsArray objectAtIndex:i ] objectForKey:@"id"] intValue];
        campusNews.title      = [[campusNewsArray objectAtIndex:i] objectForKey:@"title"];
        campusNews.description= [[campusNewsArray objectAtIndex:i] objectForKey:@"description"];
        campusNews.updatedAt  = [[[campusNewsArray objectAtIndex:i ] objectForKey:@"updatedAt"]intValue];
        campusNews.userId     = [[[campusNewsArray objectAtIndex:i ] objectForKey:@"userId"]intValue];
        campusNews.categoryId     = [[[campusNewsArray objectAtIndex:i ] objectForKey:@"categoryId"]intValue];
        [newsArray addObject:campusNews];
    }
    
    return newsArray ;
}

- (BOOL)loginSuccessOrNot:(NSData *)datas
{/*
  {
  code = 1;
  message = "";
  }
  */
    
 //   dict = [UserLoginParse loginSerialization:datas];
    NSLog(@"loginSuccessOrNot.dict:%@",dict);
    NSString *codeString  = [dict objectForKey:@"code"];
    NSLog(@"code=%d",[codeString intValue]);
    return [codeString intValue]>0?YES:NO;
    
}

- (NSString *)loginFailMessage:(NSData *)datas
{
    dict = (NSDictionary*)[self loginSerialization:datas];
    NSLog(@"loginFailMessage.dict:%@",dict);
    NSString *messageString  = [dict objectForKey:@"message"];
    NSLog(@"code=%@",messageString);
    return messageString;
    
}



@end
