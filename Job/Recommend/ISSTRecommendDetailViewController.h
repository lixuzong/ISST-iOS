//
//  ISSTRecommendDetailViewController.h
//  ISST
//
//  Created by XSZHAO on 14-4-19.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTPushedViewController.h"
#import "ISSTWebApiDelegate.h"
#import "ISSTMoreButtonDelegate.h"
@interface ISSTRecommendDetailViewController : ISSTPushedViewController<UIWebViewDelegate,ISSTWebApiDelegate,ISSTMoreButtonDelegate>
@property (nonatomic, assign) int       jobId;


@end
