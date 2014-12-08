//
//  ISSTTaskDetailViewController.h
//  ISST
//
//  Created by rth on 14/12/7.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISSTWebApiDelegate.h"

@interface ISSTTaskDetailViewController : UIViewController<ISSTWebApiDelegate>

@property(nonatomic,assign)int taskId;
@property(nonatomic,assign)NSString *detail;
@property(nonatomic,assign)NSString *text;
@property(nonatomic,assign)int finishId;
@property(nonatomic,assign)NSString *updatedAt;
@property(nonatomic,assign)NSString *startTime;
@property(nonatomic,assign)NSString *expireTime;
@property(nonatomic,assign)NSString *TaskName;


@end
