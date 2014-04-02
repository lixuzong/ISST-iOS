//
//  GogoViewController.h
//  ISST
//
//  Created by XSZHAO on 14-3-20.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTPushedViewController.h"
@interface ISSTNewsDetailViewController : ISSTPushedViewController<UIWebViewDelegate>
{
    IBOutlet UIWebView *webView;
   
}
 @property(nonatomic,assign)int newsId;

@end
