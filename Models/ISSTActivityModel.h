//
//  ISSTActivitiesModel.h
//  ISST
//
//  Created by XSZHAO on 14-4-7.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISSTUserModel.h"
@interface ISSTActivityModel : NSObject
@property (nonatomic,assign) int            activityId;
@property (nonatomic,strong) NSString*      title;
@property (nonatomic,strong) NSString*      picture;
@property (nonatomic,assign) int            cityId;
@property (nonatomic,strong) NSString*      location;
@property (nonatomic,strong) NSString*      startTime;
@property (nonatomic,strong) NSString*      expireTime;
@property (nonatomic,strong) NSString*      updateAt;
@property (nonatomic,strong) NSString*      content;
@property (nonatomic,assign) BOOL           participated;
@property (nonatomic,strong)ISSTUserModel*  releaseUserModel;
@end
