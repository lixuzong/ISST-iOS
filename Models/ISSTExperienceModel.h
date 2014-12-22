//
//  ISSTExperienceModel.h
//  ISST
//
//  Created by rth on 14-12-20.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISSTExperienceModel : NSObject
@property (nonatomic,assign) int eId;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,assign)int status;
@property(nonatomic,copy)NSString *updatedAt;
@property (nonatomic,copy) NSString *description;
@end
