//
//  ISSTActivityDetailViewController.h
//  ISST
//
//  Created by apple on 14-6-22.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISSTSameCitiesApi.h"
@interface ISSTSameCityActivityDetailViewController : UIViewController<ISSTWebApiDelegate>
@property (assign,nonatomic) int   cityId;
@property (assign,nonatomic) int   activityId;
@end
