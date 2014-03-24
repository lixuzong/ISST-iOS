//
//  ISSTRevealViewController.m
//  ISST
//
//  Created by XSZHAO on 14-3-20.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTRevealViewController.h"


#pragma mark -
#pragma mark Constants
const NSTimeInterval kISSTRevealSidebarDefaultAnimationDuration = 0.25;
const CGFloat kISSTRevealSidebarWidth = 250.0f;
const CGFloat kISSTRevealSidebarFlickVelocity = 1020.0f;





#pragma mark -
#pragma mark Private Interface
@interface ISSTRevealViewController ()
@property (nonatomic, readwrite, getter = isSidebarShowing) BOOL sidebarShowing;
@property (nonatomic, readwrite, getter = isSearching) BOOL searching;
@property (nonatomic, strong) UIView *searchView;
- (void)hideSidebar;

@end

#pragma mark -
#pragma mark Implementation
@implementation ISSTRevealViewController
{
@private
    UIView *_sidebarView;
    UIView *_contentView;
    UITapGestureRecognizer *_tapRecog;
}



- (void)setSidebarViewController:(UIViewController *)svc {
	if (_sidebarViewController == nil) {
		svc.view.frame = _sidebarView.bounds;
        svc.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
		_sidebarViewController = svc;
	//	[self addChildViewController:_sidebarViewController];
		[_sidebarView addSubview:_sidebarViewController.view];
		[_sidebarViewController didMoveToParentViewController:self];
	} else if (_sidebarViewController != svc) {
		svc.view.frame = _sidebarView.bounds;
        svc.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
		[_sidebarViewController willMoveToParentViewController:nil];
		//[self addChildViewController:svc];
		self.view.userInteractionEnabled = NO;
		[self transitionFromViewController:_sidebarViewController
						  toViewController:svc
								  duration:0
								   options:UIViewAnimationOptionTransitionNone
								animations:^{}
								completion:^(BOOL finished){
									self.view.userInteractionEnabled = YES;
									[_sidebarViewController removeFromParentViewController];
									[svc didMoveToParentViewController:self];
									_sidebarViewController = svc;
		          	}
		 ];
	}
}

- (void)setContentViewController:(UIViewController *)cvc {
	if (_contentViewController == nil) {
		cvc.view.frame = _contentView.bounds;
		_contentViewController = cvc;
		[self addChildViewController:_contentViewController];
		[_contentView addSubview:_contentViewController.view];
		[_contentViewController didMoveToParentViewController:self];
	} else if (_contentViewController != cvc) {
		cvc.view.frame = _contentView.bounds;
		[_contentViewController willMoveToParentViewController:nil];
		[self addChildViewController:cvc];
		self.view.userInteractionEnabled = NO;
		[self transitionFromViewController:_contentViewController
						  toViewController:cvc
								  duration:0
								   options:UIViewAnimationOptionTransitionNone
								animations:^{}
								completion:^(BOOL finished){
									self.view.userInteractionEnabled = YES;
									[_contentViewController removeFromParentViewController];
									[cvc didMoveToParentViewController:self];
									_contentViewController = cvc;
								}
         ];
	}
}

#pragma mark Memory Management
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		self.sidebarShowing = NO;
		self.searching = NO;
		_tapRecog = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSidebar)];
		_tapRecog.cancelsTouchesInView = YES;
		
		self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
		
		_sidebarView = [[UIView alloc] initWithFrame:self.view.bounds];
		_sidebarView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
		_sidebarView.backgroundColor = [UIColor clearColor];
		[self.view addSubview:_sidebarView];
		
		_contentView = [[UIView alloc] initWithFrame:self.view.bounds];
		_contentView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
		_contentView.backgroundColor = [UIColor clearColor];
		_contentView.layer.masksToBounds = NO;
		_contentView.layer.shadowColor = [UIColor blackColor].CGColor;
		_contentView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
		_contentView.layer.shadowOpacity = 1.0f;
		_contentView.layer.shadowRadius = 2.5f;
		_contentView.layer.shadowPath = [UIBezierPath bezierPathWithRect:_contentView.bounds].CGPath;
		[self.view addSubview:_contentView];
    }
    return self;
}







#pragma mark UIViewController
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation {
	return (orientation == UIInterfaceOrientationPortraitUpsideDown)
    ? (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    : YES;
}

#pragma mark Public Methods
- (void)dragContentView:(UIPanGestureRecognizer *)panGesture {
	CGFloat translation = [panGesture translationInView:self.view].x;
	if (panGesture.state == UIGestureRecognizerStateChanged) {
		if (_sidebarShowing) {
			if (translation > 0.0f) {
				_contentView.frame = CGRectOffset(_contentView.bounds, kISSTRevealSidebarWidth, 0.0f);
				self.sidebarShowing = YES;
			} else if (translation < -kISSTRevealSidebarWidth) {
				_contentView.frame = _contentView.bounds;
				self.sidebarShowing = NO;
			} else {
				_contentView.frame = CGRectOffset(_contentView.bounds, (kISSTRevealSidebarWidth + translation), 0.0f);
			}
		} else {
			if (translation < 0.0f) {
				_contentView.frame = _contentView.bounds;
				self.sidebarShowing = NO;
			} else if (translation > kISSTRevealSidebarWidth) {
				_contentView.frame = CGRectOffset(_contentView.bounds, kISSTRevealSidebarWidth, 0.0f);
				self.sidebarShowing = YES;
			} else {
				_contentView.frame = CGRectOffset(_contentView.bounds, translation, 0.0f);
			}
		}
	} else if (panGesture.state == UIGestureRecognizerStateEnded) {
		CGFloat velocity = [panGesture velocityInView:self.view].x;
		BOOL show = (fabs(velocity) > kISSTRevealSidebarFlickVelocity)
        ? (velocity > 0)
        : (translation > (kISSTRevealSidebarWidth / 2));
		[self toggleSidebar:show duration:kISSTRevealSidebarDefaultAnimationDuration];
		
	}
}

- (void)toggleSidebar:(BOOL)show duration:(NSTimeInterval)duration {
	[self toggleSidebar:show duration:duration completion:^(BOOL finshed){}];
}

- (void)toggleSidebar:(BOOL)show duration:(NSTimeInterval)duration completion:(void (^)(BOOL finsihed))completion {
    __weak ISSTRevealViewController *selfRef = self;
	void (^animations)(void) = ^{
		if (show) {
			_contentView.frame = CGRectOffset(_contentView.bounds, kISSTRevealSidebarWidth, 0.0f);
			[_contentView addGestureRecognizer:_tapRecog];
            [selfRef.contentViewController.view setUserInteractionEnabled:NO];
		} else {
			if (self.isSearching) {
				_sidebarView.frame = CGRectMake(0.0f, 0.0f, kISSTRevealSidebarWidth, CGRectGetHeight(self.view.bounds));
			} else {
				[_contentView removeGestureRecognizer:_tapRecog];
			}
			_contentView.frame = _contentView.bounds;
            [selfRef.contentViewController.view setUserInteractionEnabled:YES];
		}
		selfRef.sidebarShowing = show;
	};
	if (duration > 0.0) {
		[UIView animateWithDuration:duration
							  delay:0
							options:UIViewAnimationOptionCurveEaseInOut
						 animations:animations
						 completion:completion];
	} else {
		animations();
		completion(YES);
	}
}

- (void)toggleSearch:(BOOL)showSearch withSearchView:(UIView *)srchView duration:(NSTimeInterval)duration {
	[self toggleSearch:showSearch withSearchView:srchView duration:duration completion:^(BOOL finished){}];
}

- (void)toggleSearch:(BOOL)showSearch withSearchView:(UIView *)srchView duration:(NSTimeInterval)duration completion:(void (^)(BOOL finsihed))completion {
	if (showSearch) {
		srchView.frame = self.view.bounds;
	} else {
		_sidebarView.alpha = 0.0f;
		_contentView.frame = CGRectOffset(self.view.bounds, CGRectGetWidth(self.view.bounds), 0.0f);
		[self.view addSubview:_contentView];
	}
	void (^animations)(void) = ^{
		if (showSearch) {
			_contentView.frame = CGRectOffset(_contentView.bounds, CGRectGetWidth(self.view.bounds), 0.0f);
			[_contentView removeGestureRecognizer:_tapRecog];
			[_sidebarView removeFromSuperview];
			self.searchView = srchView;
			[self.view insertSubview:self.searchView atIndex:0];
		} else {
			_sidebarView.frame = CGRectMake(0.0f, 0.0f, kISSTRevealSidebarWidth, CGRectGetHeight(self.view.bounds));
			_sidebarView.alpha = 1.0f;
			[self.view insertSubview:_sidebarView atIndex:0];
			self.searchView.frame = _sidebarView.frame;
			_contentView.frame = CGRectOffset(_contentView.bounds, kISSTRevealSidebarWidth, 0.0f);
		}
	};
	void (^fullCompletion)(BOOL) = ^(BOOL finished){
		if (showSearch) {
			_contentView.frame = CGRectOffset(_contentView.bounds, CGRectGetHeight([UIScreen mainScreen].bounds), 0.0f);
			[_contentView removeFromSuperview];
		} else {
			[_contentView addGestureRecognizer:_tapRecog];
			[self.searchView removeFromSuperview];
			self.searchView = nil;
		}
		self.sidebarShowing = YES;
		self.searching = showSearch;
		completion(finished);
	};
	if (duration > 0.0) {
		[UIView animateWithDuration:duration
							  delay:0
							options:UIViewAnimationOptionCurveEaseInOut
						 animations:animations
						 completion:fullCompletion];
	} else {
		animations();
		fullCompletion(YES);
	}
}

#pragma mark Private Methods
- (void)hideSidebar {
	[self toggleSidebar:NO duration:kISSTRevealSidebarDefaultAnimationDuration];
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
