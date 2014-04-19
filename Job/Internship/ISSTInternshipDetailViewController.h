//
//  GogoViewController.h
//  ISST
//
//  Created by XSZHAO on 14-3-20.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTPushedViewController.h"
#import "ISSTWebApiDelegate.H"
@interface ISSTInternshipDetailViewController : ISSTPushedViewController<UIWebViewDelegate,ISSTWebApiDelegate>
{
    IBOutlet UIWebView *webView;
   
}
 @property(nonatomic,assign)int internshipId;

@end
