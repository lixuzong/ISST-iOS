//
//  CommentsModel.h
//  ISST
//
//  Created by XSZHAO on 14-4-19.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISSTUserModel.h"
@interface ISSTCommentsModel : NSObject

@property (nonatomic,assign) int        commentsId;
@property (nonatomic,strong) NSString   *title;
@property (nonatomic,strong) NSString   *content;
@property (nonatomic,strong) NSString   *createdAt;
@property (nonatomic,strong) ISSTUserModel *userModel;

@end
