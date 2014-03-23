//
//  ISSTSidebarSearchViewController.h
//  ISST
//
//  Created by XSZHAO on 14-3-20.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISSTSidebarSearchViewControllerDelegate.h"
@class ISSTRevealViewController ;
@interface ISSTSidebarSearchViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate>

@property (nonatomic, readonly) UISearchBar *searchBar;
@property (nonatomic, readonly) NSArray *entries;
@property (weak, nonatomic) id<ISSTSidebarSearchViewControllerDelegate> searchDelegate;
@property (nonatomic) NSTimeInterval searchDelay;

- (id)initWithSidebarViewController:(ISSTRevealViewController *)sidebarVC;
@end
