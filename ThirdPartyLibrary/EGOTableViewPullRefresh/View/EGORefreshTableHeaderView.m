//
//  EGORefreshTableHeaderView.m
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "EGORefreshTableHeaderView.h"
#import "ISSTActivityIndicatorView.h"

#define TEXT_COLOR	 [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:1.0]
//#define FLIP_ANIMATION_DURATION 0.18f

#define INDICATOR_CENTER_X 160
#define INDICATOR_CENTER_Y 25
#define INDICATOR_CENTER_BOTTOM 34

#define SCOLL_SCALE_START_Y  38
#define ScollScaleView_Size 15
#define ScollScaleView_SemiSize (ScollScaleView_Size * 0.5)

@interface ScrollScaleView : UIView
{
    UIView *_viewLT;
    UIView *_viewRT;
    UIView *_viewLB;
    UIView *_viewRB;
}

- (void)scaleRaletaiveDeltaDistance:(CGFloat)delta;
- (void)reset;
@end

@implementation ScrollScaleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {   
        _viewLT = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
        _viewLT.backgroundColor = [UIColor blueColor];
        [self addSubview:_viewLT];
        
        _viewRT = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
        _viewRT.backgroundColor =  [UIColor blueColor];;
        [self addSubview:_viewRT];
        
        _viewLB = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
        _viewLB.backgroundColor =  [UIColor blueColor];;
        [self addSubview:_viewLB];
        
        _viewRB = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
        _viewRB.backgroundColor =  [UIColor blueColor];;
        [self addSubview:_viewRB];
        
        [self reset];
    }
    
    return self;
}

- (void)reset
{
    CGPoint initialCenter = CGPointMake(self.frame.size.width * .5, self.frame.size.height * .5);
    _viewLT.center = initialCenter;
    _viewRT.center = initialCenter;
    _viewLB.center = initialCenter;
    _viewRB.center = initialCenter;
}

#define _SCALE_FACTOR (3.5 / (REFRESH_OFFSETY_THRESHOLD - SCOLL_SCALE_START_Y))
- (CGPoint)centerOfFactorDistance:(CGFloat)delta directionX:(int)dirX directionY:(int)dirY
{
    CGFloat deltaX = dirX * _SCALE_FACTOR * delta + ScollScaleView_SemiSize;
    CGFloat deltaY = dirY * _SCALE_FACTOR * delta + ScollScaleView_SemiSize;
    
    return CGPointMake(deltaX , deltaY);
}

- (void)scaleRaletaiveDeltaDistance:(CGFloat)delta;
{
    CGPoint deltaCenter;
    
    //左上
    deltaCenter = [self centerOfFactorDistance:delta directionX:-1 directionY:-1];
    _viewLT.center = deltaCenter;
    
    //右上
    deltaCenter = [self centerOfFactorDistance:delta directionX:1 directionY:-1];
    _viewRT.center = deltaCenter;
    
    //左下
    deltaCenter = [self centerOfFactorDistance:delta directionX:-1 directionY:1];
    _viewLB.center = deltaCenter;
    
    //右下
    deltaCenter = [self centerOfFactorDistance:delta directionX:1 directionY:1];
    _viewRB.center = deltaCenter;
}
@end

@interface EGORefreshTableHeaderView ()
{
    ScrollScaleView  *_scrollScaleView;
}
- (void)setState:(EGOPullRefreshState)aState;
@end

@implementation EGORefreshTableHeaderView

@synthesize delegate=_delegate;


- (id)initializeWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor  {
    {
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [UIColor clearColor];

        ScrollScaleView *view = [[ScrollScaleView alloc] initWithFrame:CGRectMake(160, 0, ScollScaleView_Size, ScollScaleView_Size)];
        view.backgroundColor = [UIColor clearColor];
        view.center = CGPointMake(INDICATOR_CENTER_X, frame.size.height - INDICATOR_CENTER_BOTTOM);
		[self addSubview:view];
		_scrollScaleView=view;
		[view release];
		
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 22.0f, self.frame.size.width, 12.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont systemFontOfSize:12.0f];
		label.textColor = textColor;
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
		[label release];
		
		
		ISSTActivityIndicatorView *activityView = [ISSTActivityIndicatorView defaultActivityIndicatorView];
        activityView.center = CGPointMake(INDICATOR_CENTER_X, frame.size.height - INDICATOR_CENTER_BOTTOM);
		activityView.hidden = YES;
        [self addSubview:activityView];
		_activityView = activityView;
		
		
		[self setState:EGOOPullRefreshNormal];
    }
	
    return self;
	
}

- (UIEdgeInsets)scrollViewInset
{
    if (self.delegate && [(NSObject*)self.delegate respondsToSelector:@selector(egoRefreshTableHeaderContentInset:)])
    {
        return [self.delegate egoRefreshTableHeaderContentInset:self];
    }
    return UIEdgeInsetsZero;
}

- (id)initWithFrame:(CGRect)frame  {
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initializeWithFrame:frame arrowImageName:@"blueArrow.png" textColor:TEXT_COLOR];
    }
    return self;
}

#pragma mark -
#pragma mark Setters

//- (void)refreshLastUpdatedDate {
//	
//	if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceLastUpdated:)]) {
//		
//		NSDate *date = [_delegate egoRefreshTableHeaderDataSourceLastUpdated:self];
//		
//		[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
//		NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
//		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
//		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
//
//		_lastUpdatedLabel.text = [NSString stringWithFormat:@"Last Updated: %@", [dateFormatter stringFromDate:date]];
//		[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"EGORefreshTableView_LastRefresh"];
//		[[NSUserDefaults standardUserDefaults] synchronize];
//		
//	} else {
//		
//		_lastUpdatedLabel.text = nil;
//		
//	}
//
//}

- (void)setState:(EGOPullRefreshState)aState{
	
	switch (aState) {
		case EGOOPullRefreshPulling:
			
			_statusLabel.text = @"释放刷新";
			
			break;
		case EGOOPullRefreshNormal:
			
			_statusLabel.text = @"下拉刷新";
			[_activityView stopAnimating];
			_scrollScaleView.hidden = NO;
            
			break;
		case EGOOPullRefreshLoading:
			
			_statusLabel.text = @"加载中...";

            [_activityView startAnimating];
            
            _scrollScaleView.hidden = YES;
            [_scrollScaleView reset];
			
			break;
		default:
			break;
	}
	
	_state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

- (CGFloat)scaleViewSizeOfOffsetY:(CGFloat)y
{
    if (y > 0)
    {

        CGFloat loadingSize = 12;
        CGFloat maxSize = 14;
        
        CGFloat size = loadingSize/ REFRESH_LOADIND_HEGITH * y;
        size = MIN(maxSize, size);
        
        return size;
    }
    else
    {
        return 0;
    }
}

- (CGFloat)scaleViewAlphaOfOffsetY:(CGFloat)y
{
    if (y > 0)
    {
        CGFloat alpha = 1.0 - 0.5/ REFRESH_LOADIND_HEGITH * (y - 33);
        alpha = MAX(0.5, alpha);
        
        return alpha;
    }
    else
    {
        return 1;
    }
}

- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetY = scrollView.contentOffset.y + self.scrollViewInset.top;
    
    CGFloat distance = -offsetY;
    
    self.hidden = ((int)distance) <= 0;
    
	if (_state == EGOOPullRefreshLoading) {
		
//		CGFloat offset = MAX(scrollView.contentOffset.y * -1 + self.scrollViewInset.top, 0);
//		offset = MIN(offset, REFRESH_LOADIND_HEGITH + self.scrollViewInset.top);
//        UIEdgeInsets insets = self.scrollViewInset;
//        insets.top = offset;
//		scrollView.contentInset = insets;
		
	} else if (scrollView.isDragging) {
		
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
			_loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
		}
        
        
        if (distance > SCOLL_SCALE_START_Y && distance < REFRESH_OFFSETY_THRESHOLD + DBL_EPSILON)
        {
            CGFloat deltaDistance = (distance - SCOLL_SCALE_START_Y);
            [_scrollScaleView scaleRaletaiveDeltaDistance:deltaDistance];
        }
        

		
		if (_state == EGOOPullRefreshPulling && offsetY > -REFRESH_OFFSETY_THRESHOLD && scrollView.contentOffset.y < 0.0f && !_loading) {
			[self setState:EGOOPullRefreshNormal];
		} else if (_state == EGOOPullRefreshNormal && offsetY < -REFRESH_OFFSETY_THRESHOLD && !_loading) {
			[self setState:EGOOPullRefreshPulling];
		}
		
		if (scrollView.contentInset.top != self.scrollViewInset.top) {
			scrollView.contentInset = self.scrollViewInset;
		}
	}
}

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
	
	BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
		_loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
	}
	
	if (scrollView.contentOffset.y+self.scrollViewInset.top <= - REFRESH_OFFSETY_THRESHOLD && !_loading) {
		
		if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:)]) {
			[_delegate egoRefreshTableHeaderDidTriggerRefresh:self];
		}
		
		[self setState:EGOOPullRefreshLoading];
        
        UIEdgeInsets insets = self.scrollViewInset;
        insets.top = insets.top + 60;
        
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		scrollView.contentInset = insets;
		[UIView commitAnimations];
	}
}

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {	
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	[scrollView setContentInset:self.scrollViewInset];
	[UIView commitAnimations];
	
	[self setState:EGOOPullRefreshNormal];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        self.hidden = YES;
    });
}


#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	
	_delegate=nil;
	_activityView = nil;
	_statusLabel = nil;
	_scrollScaleView = nil;
    [super dealloc];
}


@end
