//
//  ISSTCampusNews.h
//  ISST
//
//  Created by XSZHAO on 14-3-31.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import  "ISSTUserModel.h"
@interface ISSTCampusNewsModel : NSObject
@property (nonatomic, assign)int        categoryId;
@property (nonatomic ,assign)int        newsId;
@property (nonatomic,strong) NSString     *title;
@property (nonatomic,strong) NSString     *description;
@property (nonatomic,strong) NSString        *updatedAt;
@property (nonatomic,strong) NSDictionary *userModel;
@property (nonatomic,assign) int        userId;// 0为管理员，整数为学生

//@property (nonatomic, copy) ISSTUserModel *user;


@end
