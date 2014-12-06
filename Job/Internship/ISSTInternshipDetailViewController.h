//
//  ISSTInternshipDetailViewController.h
//  ISST
//
//  Created by rth on 14-12-4.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTPushedViewController.h"
#import "ISSTWebApiDelegate.h"
@interface ISSTInternshipDetailViewController : ISSTPushedViewController<UIWebViewDelegate,ISSTWebApiDelegate>
{
    IBOutlet UIWebView *webView;
   
}
 @property(nonatomic,assign)int internshipId;

@end
