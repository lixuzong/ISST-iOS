//
//  ISSTRootViewController.m
//  ISST
//
//  Created by XSZHAO on 14-3-20.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTRootViewController.h"
#import "ISSTPushedViewController.h"


@interface ISSTRootViewController ()

- (void)pushViewController;
- (void)revealSidebar;
@end

@implementation ISSTRootViewController
{
@private
    RevealBlock _revealBlock;
}

#pragma mark Memory Management
- (id)initWithTitle:(NSString *)title withRevealBlock:(RevealBlock)revealBlock {
    if (self = [super initWithNibName:nil bundle:nil]) {
		self.title = title;
		_revealBlock = [revealBlock copy];
		self.navigationItem.leftBarButtonItem =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize
                                                      target:self
                                                      action:@selector(revealSidebar)];
    
        if ([self isList]) {
              [self   initialRefreshLoadingCell];
        }
      
	}
	return self;
}

-(BOOL)isList
{
    return NO;
}

-(void)initialRefreshLoadingCell
{
    _refreshLoading = NO;
    _getMoreCell = [[MoreTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MoreTableViewCell"];
    _emptyCell  = [[RefreshTableEmptyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RefreshTableEmptyCell"];
    _emptyCell.emptyImage = [UIImage imageNamed:@"none_list"];

}


-(void)requestRefresh
{
    
}


#pragma mark UIViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	self.view.backgroundColor = [UIColor lightGrayColor];
    
    /*	UIButton *pushButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
     [pushButton setTitle:@"Push" forState:UIControlStateNormal];
     [pushButton addTarget:self action:@selector(pushViewController) forControlEvents:UIControlEventTouchUpInside];
     [pushButton sizeToFit];
     [self.view addSubview:pushButton];
     */
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(BOOL)canGetMoreData
{
    return NO;
}
#pragma mark - UIScrollViewDelegate
//当tableView滚动时就会调用这个函数
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

// called on start of dragging (may require some time and or distance to move)
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
{
    
}



//当tableView滚动结束时就会调用这个函数
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView   // called on finger up as we are moving
{
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;      // called when scroll view grinds to a halt
{
    if ([self canGetMoreData])
    {
        CGRect rc = _getMoreCell.frame;
        
        NSLog(@"$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$    ====scrollView.contentOffset.y=%f \
              \
              scrollView.frame.size.height=%f   \
              \
              rc.origin.y=%f \
              \
              rc.size.height =%f\
              \
              contentSize.height=%f \
              ",scrollView.contentOffset.y, scrollView.frame.size.height,rc.origin.y,rc.size.height,scrollView.contentSize.height);
        //887   548    0  44
        if ((scrollView.contentSize.height-scrollView.contentOffset.y)<=scrollView.frame.size.height)
        {
            if (rc.origin.y > 0&&!_refreshLoading) {
                [self performSelector:@selector(requestGetMore) withObject:nil afterDelay:0.0f];
            }
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView;
{
    
}

#pragma mark - EGORefreshTableHeaderDelegate
//当弹出下拉界面时调用此函数
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view;
{
    [self requestRefresh];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view;
{
    return _refreshLoading;
    //return  true;
}

- (UIEdgeInsets)egoRefreshTableHeaderContentInset:(EGORefreshTableHeaderView *)view
{
    //刷新完成后，返回数据的inset
    /**
     *topLayoutGuide为IOS7新增属性，所以在iOS6上奔溃。此处解决此问题。
     */
    if ([UIDevice currentDevice].systemVersion.floatValue>=7.0) {
        return UIEdgeInsetsMake(self.topLayoutGuide.length,
                                0,
                                self.bottomLayoutGuide.length,
                                0);
    }
    return UIEdgeInsetsZero;
}




#pragma mark Private Methods
- (void)pushViewController {
	NSString *vcTitle = [self.title stringByAppendingString:@" - Pushed"];
	UIViewController *vc = [[ISSTPushedViewController alloc] initWithTitle:vcTitle];
	
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)revealSidebar {
	_revealBlock();
}
@end
