//
//  BaseParse.m
//  ISST
//
//  Created by XSZHAO on 14-3-31.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "BaseParse.h"

@implementation BaseParse
@synthesize detailsInfo,dict,infoArray;
- (int)getStatus
{
    return [[dict objectForKey:@"status"]intValue];

}

- (id)infoSerialization:(NSData*)datas
{
    NSLog(@"*****************************datas***************************");
    NSLog(@"%@",datas);
    dict = [NSJSONSerialization JSONObjectWithData:datas options:NSJSONReadingAllowFragments error:nil];
    //jason 转化为 foundation
    NSLog(@"************BaseParse.h***********");
    NSLog(@"%@",dict);
    return dict;
}

-(void)dealloc
{
   
    infoArray = nil;
    detailsInfo= nil;
    dict= nil;
    [super dealloc];
}

@end
