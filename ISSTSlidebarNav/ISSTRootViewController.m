//
//  ISSTRootViewController.m
//  ISST
//
//  Created by XSZHAO on 14-3-20.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTRootViewController.h"
#import "ISSTPushedViewController.h"

@interface ISSTRootViewController ()
- (void)pushViewController;
- (void)revealSidebar;
@end

@implementation ISSTRootViewController
{
@private
    RevealBlock _revealBlock;
}

#pragma mark Memory Management
- (id)initWithTitle:(NSString *)title withRevealBlock:(RevealBlock)revealBlock {
    if (self = [super initWithNibName:nil bundle:nil]) {
		self.title = title;
		_revealBlock = [revealBlock copy];
		self.navigationItem.leftBarButtonItem =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                      target:self
                                                      action:@selector(revealSidebar)];
	}
	return self;
}



#pragma mark UIViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	self.view.backgroundColor = [UIColor lightGrayColor];
    
    /*	UIButton *pushButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
     [pushButton setTitle:@"Push" forState:UIControlStateNormal];
     [pushButton addTarget:self action:@selector(pushViewController) forControlEvents:UIControlEventTouchUpInside];
     [pushButton sizeToFit];
     [self.view addSubview:pushButton];
     */
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Private Methods
- (void)pushViewController {
	NSString *vcTitle = [self.title stringByAppendingString:@" - Pushed"];
	UIViewController *vc = [[ISSTPushedViewController alloc] initWithTitle:vcTitle];
	
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)revealSidebar {
	_revealBlock();
}
@end
