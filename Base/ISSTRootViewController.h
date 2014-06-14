//
//  ISSTRootViewController.h
//  ISST
//
//  Created by XSZHAO on 14-3-20.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EGORefreshTableHeaderView.h"
#import "MoreTableViewCell.h"
#import "RefreshTableEmptyCell.h"

typedef void (^RevealBlock)();
@interface ISSTRootViewController : UIViewController<EGORefreshTableHeaderDelegate>
{
    
    EGORefreshTableHeaderView   *_refreshHeaderView;
    MoreTableViewCell           *_getMoreCell;
    RefreshTableEmptyCell       *_emptyCell;
    BOOL    _refreshLoading ;
    
}
@property (nonatomic,strong)MoreTableViewCell *getMoreCell;


- (id)initWithTitle:(NSString *)title withRevealBlock:(RevealBlock)revealBlock;

-(BOOL)canGetMoreData;
-(void)requestRefresh;
@end
