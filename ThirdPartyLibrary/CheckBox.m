//
//  CheckBox.m
//  Check_Box
//
//  Created by wangjf on 12-4-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CheckBox.h"

@implementation CheckBox
@synthesize isHook;
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //设置标志
        self.isHook = NO;
        //设置背景
        self.backgroundColor = [UIColor whiteColor];
        //将图层的边框设置为圆脚
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = YES;
        //给图层添加一个有色边框
        self.layer.borderWidth = 2;
        self.layer.borderColor = [[UIColor colorWithRed:0.52 green:0.09 blue:0.07 alpha:0.5f] CGColor];
        
    }
    return self;
}

-(void)setIsHook:(BOOL)isH
{
    isHook = !isH;
    [self didSelectOrDeselect];
    
}

-(BOOL)isHook
{
    return isHook;
    
}


- (void)didSelectOrDeselect
{
    if (isHook == YES)
    {
        isHook = NO;
        self.backgroundColor = [UIColor whiteColor];
    }
    else
    {
        isHook = YES;
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"fs_main_login_selected@2x.png"]];
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self didSelectOrDeselect];
    [super touchesBegan:touches withEvent:event];//调用ViewControllertouches事件。
}


@end
