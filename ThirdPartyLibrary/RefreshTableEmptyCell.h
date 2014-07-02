//
//  RefreshTableEmptyCell.h
//  ISST
//
//  Created by zhaoxs on 6/14/14.
//  Copyright (c) 2014 MSE.ZJU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISSTActivityIndicatorView.h"
typedef enum
{
    EmptyCellState_Loading,
    EmptyCellState_Tips,
    EmptyCellState_Error,
}EmptyCellState;

@interface RefreshTableEmptyCell : UITableViewCell
{
    ISSTActivityIndicatorView *_activityView;
    UIImageView *_tipsImageView;
    UILabel     *_tipsLabelView;
    
}

@property(nonatomic, strong)NSString *emptyText;
@property(nonatomic, strong)UIImage *emptyImage;
@property(nonatomic) EmptyCellState state;

@end
