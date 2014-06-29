//
//  UserImputCell.h
//  ISST
//
//  Created by zhaoxs on 6/16/14.
//  Copyright (c) 2014 MSE.ZJU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserImputCell : UITableViewCell

@property (nonatomic,strong)UITextField *textField;

-(void)setTitle:(NSString *)title andContent:(NSString *)content;

@end
