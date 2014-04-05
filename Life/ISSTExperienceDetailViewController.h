//
//  ISSTExperenceDetailViewController.h
//  ISST
//
//  Created by liuyang on 14-4-4.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTPushedViewController.h"
#import "ISSTWebApiDelegate.h"
@interface ISSTExperienceDetailViewController : ISSTPushedViewController<UIWebViewDelegate,ISSTWebApiDelegate>
{
    IBOutlet UIWebView *webView;
    
}
@property(nonatomic,assign)int experienceId;
@end
