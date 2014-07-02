//
//  ISSTJobsModel.h
//  ISST
//
//  Created by zhukang on 14-4-14.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ISSTUserModel;
@interface ISSTJobsModel : NSObject
@property (nonatomic,assign) int         messageId;
@property (nonatomic,copy) NSString      *title;
@property (nonatomic,copy) NSString        *company;
@property (nonatomic,copy) NSString        *updatedAt;
@property (nonatomic,assign) int           userId;
//@property(nonatomic,copy)NSDictionary *userModel;
@property (nonatomic,strong) ISSTUserModel  *userModel;
@property (nonatomic,copy) NSString *description;
@property (nonatomic,copy)NSString *location;
@property (nonatomic,copy)NSString *startTime;
@property (nonatomic,copy)NSString *expireTime;
@property (nonatomic,assign) int            cityId;
@property (nonatomic,assign)BOOL participated;
@end
