//
//  ISSTSameCitiesModel.h
//  ISST
//
//  Created by apple on 14-4-27.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISSTUserModel.h"
@interface ISSTSameCitiesModel : NSObject
@property(nonatomic,assign) int cityId;
@property(nonatomic,strong) NSString *cityName;
@property(nonatomic,assign)int userId;
@property(nonatomic,strong)ISSTUserModel* userModel;
@end
