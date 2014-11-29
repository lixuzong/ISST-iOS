//
//  AppCache.h
//  ISST
//
//  Created by XSZHAO on 14-4-11.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppCache : NSObject
+ (BOOL)saveCache:(id)model;
+ ( id)getCache;

+(BOOL)saveClassListsCache:(NSArray *)array;
+(id)getClassListsCache;
+(BOOL)saveMajorListsCache:(NSArray *)array;
+(id)getMajorListsCache;
@end
