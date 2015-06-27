//
//  ISSTPushDetailViewController.h
//  ISST
//
//  Created by apple on 15/5/8.
//  Copyright (c) 2015年 MSE.ZJU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISSTWebApiDelegate.h"

@interface ISSTPushDetailViewController : UIViewController<UIWebViewDelegate,ISSTWebApiDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *tit;
@property(nonatomic,strong)NSString *updateAt;
@end
