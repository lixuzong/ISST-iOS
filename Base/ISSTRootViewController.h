//
//  ISSTRootViewController.h
//  ISST
//
//  Created by XSZHAO on 14-3-20.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^RevealBlock)();
@interface ISSTRootViewController : UIViewController
- (id)initWithTitle:(NSString *)title withRevealBlock:(RevealBlock)revealBlock;


@end
