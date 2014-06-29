//
//  CheckBox.h
//  Check_Box
//
//  Created by wangjf on 12-4-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol CheckBoxDelegate;

@interface CheckBox : UIView
{
    id<CheckBoxDelegate>delegate;
    BOOL isHook;
}

@property BOOL isHook;
@property (nonatomic, retain) id<CheckBoxDelegate>delegate;

- (void)didSelectOrDeselect;
@end

@protocol CheckBoxDelegate

-(void)SelectOrDeselect;

@end
