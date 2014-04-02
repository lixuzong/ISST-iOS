//
//  ISSTNewsApi.h
//  ISST
//
//  Created by XSZHAO on 14-3-25.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTApi.h"
#import  "ISSTWebApiDelegate.h"

@interface ISSTNewsApi : ISSTApi<ISSTWebApiDelegate>
@property (nonatomic,assign)int methodId;

/*****
 2014.04.01
 创建： zhao
 获取信息列表
 *****/
- (void)requestCampusNews:(int)page andPageSize:(int)pageSize andKeywords:(NSString *)keywords;
/*****
 2014.04.01
 创建： zhao
 获取信息详情
 *****/
- (void)requestDetailInfoWithId:(int)detailId;
@end
