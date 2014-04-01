//
//  ISSTNewsViewController.h
//  ISST
//
//  Created by XSZHAO on 14-3-31.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISSTRootViewController.h"
@interface ISSTNewsViewController : ISSTRootViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *newsArrayTableView;
- (id)initWithTitle:(NSString *)title withRevealBlock:(RevealBlock)revealBlock;
@end

