//
//  ISSTJobsModel.h
//  ISST
//
//  Created by zhukang on 14-4-14.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISSTJobsModel : NSObject
@property (nonatomic,assign) int         messageId;
@property (nonatomic,copy) NSString      *title;
@property(nonatomic,copy)NSString        *company;
@property(nonatomic,copy)NSString        *updatedAt;
@property(nonatomic,assign)int           userId;
@end
