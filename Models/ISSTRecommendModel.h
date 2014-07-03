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
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy) NSString *company;
@property (nonatomic,copy) NSString *position;
@property (nonatomic,assign)long long   updatedAt;
@property (nonatomic,assign)int cityId;
@end
