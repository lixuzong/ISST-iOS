//
//  ISSTSidebarSearchViewControllerDelegate.h
//  ISST
//
//  Created by XSZHAO on 14-3-20.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//
typedef void (^SearchResultsBlock)(NSArray *);
#import <Foundation/Foundation.h>

@protocol ISSTSidebarSearchViewControllerDelegate <NSObject>
@required
- (void)searchResultsForText:(NSString *)text withScope:(NSString *)scope callback:(SearchResultsBlock)callback;
- (void)searchResult:(id)result selectedAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)searchResultCellForEntry:(id)entry atIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView;
@end
