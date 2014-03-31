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
@property (nonatomic,copy) NSString     *title;
@property (nonatomic,copy) NSString     *description;
@property (nonatomic,assign) int        updatedAt;
@property (nonatomic,assign) int        userId;// 0为管理员，整数为学生
//@property (nonatomic, copy) ISSTUserModel *user;


@end
