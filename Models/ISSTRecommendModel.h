//
//  ISSTRecommendModel.h
//  ISST
//
//  Created by zhangran on 14-7-3.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISSTRecommendModel : NSObject
@property (nonatomic,assign)int rId;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy) NSString *company;
@property (nonatomic,copy) NSString *position;
@property (nonatomic,copy)NSString* updatedAt;
@property (nonatomic,assign)int cityId;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *rDescription;
@end
