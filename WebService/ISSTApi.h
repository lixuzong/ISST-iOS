//
//  ISSTApi.h
//  ISST
//
//  Created by XSZHAO on 14-3-20.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISSTWebApiDelegate.h"
 static NSHTTPCookie *cookie;
@interface ISSTApi : NSObject

@property (strong, nonatomic)NSMutableData *datas;
@property (nonatomic, assign)id<ISSTWebApiDelegate> webApiDelegate;
- (void)requestWithSuburl:(NSString *)subUrl Method:(NSString *)method Delegate:(id<NSURLConnectionDataDelegate>)delegate Info:(NSString*)info  MD5Dictionary:(NSDictionary *)dict;

@end
