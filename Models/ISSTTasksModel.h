//
//  ISSTTasksModel.h
//  ISST
//
//  Created by rth on 14-12-6.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISSTTasksModel : NSObject
@property (nonatomic,assign)int taskId;
@property (nonatomic,assign)int type;
@property (nonatomic,assign)int finishId;
@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy)NSString *description;
@property(nonatomic,copy)NSString *updatedAt;
@property (nonatomic,copy)NSString *startTime;
@property (nonatomic,copy)NSString *expireTime;
@end
