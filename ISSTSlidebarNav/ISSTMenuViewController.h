//
//  ISSTMenuViewController.h
//  ISST
//
//  Created by XSZHAO on 14-3-20.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ISSTRevealViewController ;
@interface ISSTMenuViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

//侧拉菜单的菜单项，包括：搜索，标题，控制器导航页标题，控制页标题显示风格
- (id)initWithSidebarViewController:(ISSTRevealViewController *)sidebarVC
					  withImageView:(UIImageView *)imageView
						withHeaders:(NSArray *)headers
					withControllers:(NSArray *)controllers
					  withCellInfos:(NSArray *)cellInfos;

- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath
					animated:(BOOL)animated
			  scrollPosition:(UITableViewScrollPosition)scrollPosition;
@end
