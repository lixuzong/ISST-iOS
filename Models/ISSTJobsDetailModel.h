//
//  ISSTJobsDetailModel.h
//  ISST
//
//  Created by zhukang on 14-4-14.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//
#import <Foundation/Foundation.h>
@class ISSTUserModel;
@interface ISSTJobsDetailModel : NSObject
@property (nonatomic,assign) int         messageId;
@property (nonatomic,copy) NSString      *title;
@property(nonatomic,copy)NSString        *company;
@property(nonatomic,copy)NSString        *position;
@property(nonatomic,copy)NSString        *updatedAt;
@property(nonatomic,copy)NSString        *description;
@property(nonatomic,copy)NSString        *content;
@property(nonatomic,assign)int           cityId;
@property(nonatomic,assign)int           userId;
@property (nonatomic,strong) ISSTUserModel  *userModel;
@end
