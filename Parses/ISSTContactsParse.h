//
//  ISSTContactsParse.h
//  ISST
//
//  Created by XSZHAO on 14-4-9.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "BaseParse.h"

@interface ISSTContactsParse : BaseParse
/*****
 2014.04.09
 创建： zhao
 解析通讯录列表
 *****/
-(id)contactsInfoParse;
/*****
 2014.04.09
 创建： zhao
 解析校友详情
 *****/
-(id)contactDetailsParse;
/*****
 2014.04.09
 创建： zhao
 解析班级列表
 *****/
-(id)classesInfoParse;
/*****
 2014.04.09
 创建： zhao
 解析专业方向列表
 *****/
-(id)majorsInfoParse;

@end
