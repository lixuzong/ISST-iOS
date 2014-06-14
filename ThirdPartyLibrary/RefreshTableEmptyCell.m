//
//  RefreshTableEmptyCell.m
//  ISST
//
//  Created by zhaoxs on 6/14/14.
//  Copyright (c) 2014 MSE.ZJU. All rights reserved.
//

#import "RefreshTableEmptyCell.h"

@implementation RefreshTableEmptyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        _activityView = [ISSTActivityIndicatorView defaultActivityIndicatorView];
        [_activityView stopAnimating];
        _activityView.hidden = YES;
        [self.contentView addSubview:_activityView];
        
        _tipsImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_tipsImageView];
        
        _tipsLabelView = [[UILabel alloc] initWithFrame:CGRectZero];
        _tipsLabelView.font = [UIFont systemFontOfSize:13];
        _tipsLabelView.textAlignment = NSTextAlignmentCenter;
        //        _tipsLabelView.textColor =
        _tipsLabelView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_tipsLabelView];
        
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}


#define IMAGE_TEXT_GAP  10
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.state == EmptyCellState_Tips || self.state == EmptyCellState_Error)
    {
        _tipsImageView.hidden = NO;
        _tipsLabelView.hidden = NO;
        
        [_activityView stopAnimating];
        
        _tipsLabelView.text = self.emptyText;
        
        UIImage *image = nil;
        
        if (self.state == EmptyCellState_Tips)
        {
            image = self.emptyImage;
        }
        else
        {
            image = [UIImage imageNamed:@"re_load"];
        }
        _tipsImageView.image = image;
        
        CGSize tipsTxtSize = [self.emptyText sizeWithFont:_tipsLabelView.font];
        int tipsContentHeight = image.size.height;
        if ((int)tipsTxtSize.height > 0)
        {
            tipsContentHeight += + IMAGE_TEXT_GAP + tipsTxtSize.height;
        }
        
        
        int startX = 0;
        int startY = (self.frame.size.height - tipsContentHeight) * 0.5;
        
        startX = (self.frame.size.width - image.size.width) * .5;
        _tipsImageView.frame = CGRectMake(startX, startY, image.size.width, image.size.height);
        
        startY += image.size.height + 5;
        startX = 0;
        _tipsLabelView.frame = CGRectMake(0, startY, self.frame.size.width, 13);
    }
    else
    {
        _tipsImageView.hidden = YES;
        _tipsLabelView.hidden = YES;
        
        [_activityView startAnimating];
        _activityView.center = CGPointMake(self.frame.size.width * .5, self.frame.size.height * .5);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
