//
//  LoginErrors.h
//  ISST
//
//  Created by XSZHAO on 14-3-31.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginErrors : NSObject
+ (NSString *)getStatusMessage:(int )status;

+ (NSString *)getNetworkProblem;

+ (NSString *)getUnLoginMessage;

+(NSString *)checkNetworkConnection;
@end
