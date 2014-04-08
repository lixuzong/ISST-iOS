//
//  ISSTActivitiesModel.h
//  ISST
//
//  Created by XSZHAO on 14-4-7.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISSTActivityModel : NSObject
@property (nonatomic,assign) int            activityId;
@property (nonatomic,strong) NSString*      title;
@property (nonatomic,strong) NSString*      picture;
@property (nonatomic,strong) NSString*      description;
@property (nonatomic,strong) NSString*      content;
@end
