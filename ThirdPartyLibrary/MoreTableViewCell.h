//
//  MoreTableViewCell.h
//  ISST
//
//  Created by zhaoxs on 6/14/14.
//  Copyright (c) 2014 MSE.ZJU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISSTActivityIndicatorView.h"
typedef enum
{
    MoreCellState_Loading,      //加载
    MoreCellState_Information,
}MoreCellState;

@interface MoreTableViewCell : UITableViewCell
{
    MoreCellState _state;
    UILabel *infoLabel;
    ISSTActivityIndicatorView *_activityIndicatorView;
    
}
@property(nonatomic, readonly)MoreCellState state;
@property(nonatomic, readonly)UILabel *infoLabel;

- (void)setInfoText:(NSString*)infoString forState:(MoreCellState)state;
@end
