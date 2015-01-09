//
//  ISSTPushViewController.h
//  ISST
//
//  Created by apple on 14/12/11.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISSTWebApiDelegate.h"
#import "ISSTBaseViewController.h"

@interface ISSTPushViewController : UIViewController   <UITableViewDataSource,UITableViewDelegate,ISSTWebApiDelegate>
@property (weak, nonatomic) IBOutlet UITableView *pushTableview;

@end
