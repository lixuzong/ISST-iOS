//
//  MoreTableViewCell.m
//  ISST
//
//  Created by zhaoxs on 6/14/14.
//  Copyright (c) 2014 MSE.ZJU. All rights reserved.
//

#import "MoreTableViewCell.h"

@implementation MoreTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,13, 320, 14)];
        _infoLabel.font =[UIFont systemFontOfSize:13];
        _infoLabel.backgroundColor = [UIColor clearColor];
        _infoLabel.textAlignment=UITextAlignmentCenter;
        _infoLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_infoLabel];
    //色块的设置
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat centerX = self.frame.size.width * 0.5;
    CGFloat centerY = self.frame.size.height * 0.5;
    
    CGPoint point = _infoLabel.center;
    point.x = centerX;
    _infoLabel.center = point;
    
    _activityIndicatorView.center = CGPointMake(centerX, centerY);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setInfoText:(NSString*)infoString forState:(MoreCellState)state;
{
    _state = state;
    if (_state == MoreCellState_Loading)
    {
        _activityIndicatorView.hidden = NO;
        [_activityIndicatorView startAnimating];
        _infoLabel.hidden = YES;
    }
    else
    {
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW,
                                             10ull * NSEC_PER_MSEC);
        dispatch_after(time, dispatch_get_main_queue(), ^{
            [_activityIndicatorView stopAnimating];
            _infoLabel.hidden = NO;
        });
        _infoLabel.text = infoString;
        _infoLabel.frame = CGRectMake(10, 13, 205, 14);
    }
}



@end
