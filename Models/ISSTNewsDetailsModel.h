//
//  ISSTNewsDetailsModel.h
//  ISST
//
//  Created by XSZHAO on 14-4-2.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISSTUserModel.h"
@interface ISSTNewsDetailsModel : NSObject
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *description;
@property (nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSDictionary *userModel;
@property(nonatomic,strong)NSString *updatedAt;
@property (nonatomic,assign) int        userId;
@end
