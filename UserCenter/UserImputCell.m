//
//  UserImputCell.m
//  ISST
//
//  Created by zhaoxs on 6/16/14.
//  Copyright (c) 2014 MSE.ZJU. All rights reserved.
//

#import "UserImputCell.h"
@interface  UserImputCell()
{
    UILabel *_titleLabel;
}

@end
@implementation UserImputCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 40, 40)];
        _titleLabel.textColor =[UIColor lightGrayColor];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(65, 0, 240, 40)];
        _textField.textColor = [UIColor orangeColor];
        _textField.font = [UIFont systemFontOfSize:15];
        _textField.borderStyle = UITextBorderStyleRoundedRect ;
        [self.contentView addSubview:_textField];
        [self.contentView addSubview:_titleLabel];
    }
    return self;
}

-(void)setTitle:(NSString *)title andContent:(NSString *)content
{
    _titleLabel.text = title;
    _textField.text = content;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
