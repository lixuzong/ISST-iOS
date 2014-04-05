//
//  ISSTPushedViewController.m
//  ISST
//
//  Created by XSZHAO on 14-3-20.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTPushedViewController.h"

@interface ISSTPushedViewController ()

@end

#pragma mark Implementation
@implementation ISSTPushedViewController

#pragma mark Memory Management
- (id)initWithTitle:(NSString *)title {
	if (self = [super initWithNibName:nil bundle:nil]) {
		self.title =     title;
	}
	return self;
}

#pragma mark UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	/*UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
     view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
     view.backgroundColor = [UIColor redColor];
     [self.view addSubview:view];*/
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}


@end
