//
//  ISSTActivityIndicatorView.h
//  ISST
//
//  Created by zhaoxs on 6/14/14.
//  Copyright (c) 2014 MSE.ZJU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISSTActivityIndicatorView : UIView
{
    BOOL _isAnimating;
    
}

@property(nonatomic) BOOL                         hidesWhenStopped;           // default is YES. calls -setHidden when animating gets set to NO

@property (readwrite, nonatomic, strong) UIColor *color;

- (void)startAnimating;
- (void)stopAnimating;
- (BOOL)isAnimating;

+ (ISSTActivityIndicatorView*)defaultActivityIndicatorView;
@end
