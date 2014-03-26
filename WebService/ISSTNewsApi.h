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
- (void)requestCampusNews:(int)page andPageSize:(int)pageSize andKeywords:(NSString *)keywords;
@end
