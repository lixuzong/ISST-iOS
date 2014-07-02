//
//  ISSTTasksModel.h
//  ISST
//
//  Created by xszhao on 14-7-2.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISSTTasksModel : NSObject
@property (nonatomic,assign)int taskId;
@property (nonatomic,assign)int type;
@property (nonatomic,assign)int finishId;
@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy)NSString *description;
@property (nonatomic,assign)long long  updatedAt;
@property (nonatomic,assign)long long startTime;
@property (nonatomic,assign)long long expireTime;
@end
