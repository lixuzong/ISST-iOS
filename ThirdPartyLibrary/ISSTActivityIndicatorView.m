//
//  ISSTActivityIndicatorView.m
//  ISST
//
//  Created by  on 6/14/14.
//  Copyright (c) 2014 MSE.ZJU. All rights reserved.
//

#import "ISSTActivityIndicatorView.h"
#define _ANIMATION_DURATION 0.2

#define _TICK_INTERVAL  (_ANIMATION_DURATION + 0.2)

#define _INDICATOR_SIZE     5
#define _INDICATOR_SPACING  2



@interface ISSTActivityIndicatorView()
{
    BOOL _setAnimating;
    
    NSUInteger _animatingTickIndex;
    
    NSMutableArray *_indicatorViewsArray;
    
    CGFloat alphaFactor;
}
@property(nonatomic, strong)NSTimer *timer;
@end

@implementation ISSTActivityIndicatorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self _indicatorInitialize];
    }
    return self;
}


- (void)awakeFromNib
{
    [self _indicatorInitialize];
}

- (CGSize)sizeThatFits:(CGSize)size;
{
    CGFloat si = _INDICATOR_SIZE + _INDICATOR_SIZE + _INDICATOR_SPACING;
    return CGSizeMake(si, si);
}

- (void)_indicatorInitialize
{
    _setAnimating = YES;
    _isAnimating = NO;
    _animatingTickIndex = 0;
    _hidesWhenStopped = YES;
    
    self.backgroundColor = [UIColor clearColor];
    
    _indicatorViewsArray = [NSMutableArray arrayWithCapacity:4];
    
    
    
    int startX = 0;
    int startY = 0;
    UIView *indictorView = [[UIView alloc] initWithFrame:CGRectMake(startX, startY, _INDICATOR_SIZE, _INDICATOR_SIZE)];
    [self addSubview:indictorView];
    [_indicatorViewsArray addObject:indictorView];
    
    startX += _INDICATOR_SIZE + _INDICATOR_SPACING;
    
    indictorView = [[UIView alloc] initWithFrame:CGRectMake(startX, startY, _INDICATOR_SIZE, _INDICATOR_SIZE)];
    indictorView.alpha = 0.75;
    [self addSubview:indictorView];
    [_indicatorViewsArray addObject:indictorView];
    
    startY+= _INDICATOR_SIZE + _INDICATOR_SPACING;
    
    indictorView = [[UIView alloc] initWithFrame:CGRectMake(startX, startY, _INDICATOR_SIZE, _INDICATOR_SIZE)];
    indictorView.alpha = 0.5;
    [self addSubview:indictorView];
    [_indicatorViewsArray addObject:indictorView];
    
    startX = 0;
    
    indictorView = [[UIView alloc] initWithFrame:CGRectMake(startX, startY, _INDICATOR_SIZE, _INDICATOR_SIZE)];
    indictorView.alpha = 0.25;
    [self addSubview:indictorView];
    [_indicatorViewsArray addObject:indictorView];
    
    alphaFactor = 1.0 / [_indicatorViewsArray count];
    self.color = [UIColor blueColor];
    
    [self _restAnimationInitialStatus];
}


- (void)_restAnimationInitialStatus
{
    _animatingTickIndex = 0;
    
    int count = [_indicatorViewsArray count];
    CGFloat alpha = 1;
    for (int i = 0; i < count; i++)
    {
        UIView *aIndicatorView = [_indicatorViewsArray objectAtIndex:i];
        aIndicatorView.alpha = alpha;
        
        alpha -= alphaFactor;
    }
}

- (void)dealloc
{
    //    DLog(@"&&&&&&&&　dealloc");
}

- (void)willMoveToWindow:(UIWindow *)newWindow
{
    if (newWindow)
    {
        if (_setAnimating)
        {
            [self _startTimer];
        }
    }
    else
    {
        [self _stopTimer];
    }
}

- (void)_updateAnimatingStatus
{
    [UIView animateWithDuration:_ANIMATION_DURATION animations:^{
        int count = [_indicatorViewsArray count];
        CGFloat alpha = 1;
        
        for (int i = _animatingTickIndex; i < _animatingTickIndex + count; i++)
        {
            NSUInteger index = i % count;
            UIView *aIndicatorView = [_indicatorViewsArray objectAtIndex:index];
            aIndicatorView.alpha = alpha;
            
            alpha -= alphaFactor;
        }
    }];
    
}

- (void)_animatingTick
{
    _animatingTickIndex++;
    _animatingTickIndex %= [_indicatorViewsArray count];
    
    [self _updateAnimatingStatus];
}

- (void)setColor:(UIColor *)color
{
    if (_color != color)
    {
        _color = color;
        
        [_indicatorViewsArray makeObjectsPerformSelector:@selector(setBackgroundColor:) withObject:_color];
    }
}


- (void)_startTimer
{
    if (!_isAnimating)
    {
        self.hidden = NO;
        _isAnimating = YES;
        
        /*
         WARNING: timer 会将self retain, 所以一定要在合适的时机调用stopTimer, @see willMoveToWindow function
         */
        self.timer = [NSTimer timerWithTimeInterval:_TICK_INTERVAL
                                             target:self
                                           selector:@selector(_animatingTick)
                                           userInfo:nil
                                            repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer
                                  forMode:NSRunLoopCommonModes];
        
    }
}

- (void)_stopTimer;
{
    if (_isAnimating)
    {
        _isAnimating = NO;
        
        [self.timer invalidate];
        self.timer = nil;
        
        [self _restAnimationInitialStatus];
        
        if (self.hidesWhenStopped)
        {
            self.hidden = YES;
        }
    }
}

- (void)startAnimating;
{
    _setAnimating = YES;
    [self _startTimer];
}

- (void)stopAnimating;
{
    _setAnimating = NO;
    [self _stopTimer];
}

- (BOOL)isAnimating;
{
    return _isAnimating;
}

+ (ISSTActivityIndicatorView*)defaultActivityIndicatorView;
{
    return [[self alloc] initWithFrame:CGRectMake(0, 0, _INDICATOR_SIZE*2 + _INDICATOR_SPACING, _INDICATOR_SIZE*2 + _INDICATOR_SPACING)];
}



@end
