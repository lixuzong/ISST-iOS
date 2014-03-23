//
//  ISSTWebApiDelegate.h
//  ISST
//
//  Created by XSZHAO on 14-3-20.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ISSTWebApiDelegate <NSObject>
@optional

- (void)requestDataOnSuccess:(NSMutableArray *)array;

- (void)requestDataOnFail:(NSString *)error;
@end
