//
//  ISSTJobsParse.h
//  ISST
//
//  Created by zhukang on 14-4-14.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "BaseParse.h"

@interface ISSTJobsParse : BaseParse
/*****
 2014.04.14
 创建： zhu
 解析信息列表
 *****/
-(id)jobsInfoParse;
/*****
 2014.04.14
 创建： zhu
 解析信息详情
 *****/
-(id)jobsDetailInfoParse;
/*****
 2014.04.19
 创建： zhao
 解析内推评论列表，rc = recommend comments
 *****/
-(id)rcListsParse;
/*****
 2014.04.19
 创建： zhao
 解析发布的内存信息
 *****/
-(id)recommendCommentsParse;


@end
