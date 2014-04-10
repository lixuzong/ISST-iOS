//
//  ISSTStudyDetailViewController.h
//  ISST
//
//  Created by zhukang on 14-4-4.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTPushedViewController.h"
#include "ISSTWebApiDelegate.h"
#import <UIKit/UIKit.h>
@interface ISSTStudyDetailViewController : ISSTPushedViewController<UIWebViewDelegate,ISSTWebApiDelegate>

{
    IBOutlet UIWebView *webView;
    
}
@property(nonatomic,assign)int studyId;

@end
