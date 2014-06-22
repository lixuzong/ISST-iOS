//
//  ISSTActivityStatus.h
//  ISST
//
//  Created by apple on 14-6-21.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISSTActivityStatusModel : NSObject
@property (nonatomic,assign) int             statusId;
@property (nonatomic,strong) NSString*      statusMessage;
@end
