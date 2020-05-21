//
//  PageControl.m
//  InsPageControl
//
//  Created by Eric JI on 2020/02/27.
//  Copyright © 2020 ericji. All rights reserved.
//

#import "PageControl.h"
#import "ItemView.h"

typedef NS_ENUM(NSUInteger, Direction) {
    Left,
    Right,
    Stay,
};

@implementation PageControl {
    UIScrollView *_scrollView;
    
    int _displayCount;
    NSMutableArray *_items;
}

#pragma mark  - Init function

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
        [self updateViewSize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
        [self updateViewSize];
    }
    return self;
}


#pragma mark  - Public functions

- (void)setConfig:(Config)config {
    
    _config = config;
    [self invalidateIntrinsicContentSize];
    [self update:_currentPage config:config];
    
}

- (void)setNumberOfPages:(int)numberOfPages {
    
    _numberOfPages = numberOfPages;
    [_scrollView setHidden:(_numberOfPages <= 1 && _hidesForSinglePage)];
    _displayCount = MIN(_config.displayCount, _numberOfPages);
    [self invalidateIntrinsicContentSize];
    
    [self update:_currentPage config:_config];
}

- (void)setHidesForSinglePage:(BOOL)hidesForSinglePage {
    
    _hidesForSinglePage = hidesForSinglePage;
    [_scrollView setHidden:(_numberOfPages <= 1 && hidesForSinglePage)];
}

- (void)setCurrentPage:(int)currentPage {
    [self setCurrentPage:currentPage animated:YES];
}

- (void)setCurrentPage:(int)currentPage animated: (BOOL)animatd {
    
    if (currentPage == _currentPage) {
        return;
    }
    
    if ((currentPage >= _numberOfPages) || (currentPage < 0)) {
        return;
    }
    
    [_scrollView.layer removeAllAnimations];
    [self updateDotAt:currentPage animated:animatd];
    _currentPage = currentPage;
    
}

- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor {
    
    _pageIndicatorTintColor = pageIndicatorTintColor;
    [self updateDotColor:_currentPage];
    
}

- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor {
    
    _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
    [self updateDotColor:_currentPage];

}

- (void)setProgress: (CGFloat)contentOffsetX pageWidth: (CGFloat)pageWidth {
    
    if (pageWidth <= 0) {
        return;
    }
    
    int currentPage = (int)round(contentOffsetX / pageWidth);
    
    [self setCurrentPage:currentPage animated:YES];
    
}


#pragma mark  - Override function

- (CGSize)intrinsicContentSize {
    return CGSizeMake([self itemSize] * _displayCount, [self itemSize]);
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [_scrollView setCenter: CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2)];
    
}

#pragma mark  - Private function

- (void)setup {
    
    self.backgroundColor = [UIColor clearColor];
    
    _scrollView = [UIScrollView new];
    _scrollView.backgroundColor = [UIColor clearColor];
    [_scrollView setUserInteractionEnabled: NO];
    [_scrollView setShowsHorizontalScrollIndicator: NO];
    
    [self addSubview:_scrollView];
    
    _currentPage = 0;
    _items = [NSMutableArray new];
    _pageIndicatorTintColor = [UIColor colorWithRed:0.86 green:0.86 blue:0.86 alpha:1.0];
    _currentPageIndicatorTintColor = [UIColor colorWithRed:0.32 green:0.59 blue:0.91 alpha:1.0];
    _animateDuration = 0.3;
};

- (void)updateViewSize {
    self.bounds = CGRectMake(0, 0, [self intrinsicContentSize].width, [self intrinsicContentSize].height);
}

- (CGFloat)itemSize {
    return _config.dotSize + _config.dotSpace;
}

- (void)update: (int)currentPage config: (Config)config {
    
    ItemConfig itemConfig = {};
    itemConfig.dotSize = _config.dotSize;
    itemConfig.itemSize = [self itemSize];
    itemConfig.smallDotSizeRatio = _config.smallDotSizeRatio;
    itemConfig.mediumDotSizeRatio = _config.mediumDotSizeRatio;

    [_items removeAllObjects];
    
    if (currentPage < _displayCount) {
        for (int index = -2; index < _displayCount + 2; index++) {
            ItemView *view = [[ItemView alloc] initWithConfig:itemConfig index:index];
            [_items addObject:view];
        }
    } else {
        
        ItemView *first = [_items firstObject];
        int firstIndex = first.index;
        ItemView *last = [_items lastObject];
        int lastIndex = last.index + 1;
        
        for (int index = firstIndex; index < lastIndex; index++) {
            ItemView *view = [[ItemView alloc] initWithConfig:itemConfig index:index];
            [_items addObject:view];
        }
    }
    
    _scrollView.contentSize = CGSizeMake([self itemSize] * (CGFloat)_numberOfPages, [self itemSize]);
    for (UIView*view in _scrollView.subviews) {
        [view removeFromSuperview];
    }
    
    for (UIView*view in _items) {
        [_scrollView addSubview:view];
    }
    
    CGSize size = CGSizeMake([self itemSize] * (CGFloat)_displayCount, [self itemSize]);
    _scrollView.bounds = CGRectMake(0, 0, size.width, size.height);
    
    if (_displayCount < _numberOfPages) {
        _scrollView.contentInset = UIEdgeInsetsMake(0, [self itemSize] * 2, 0, [self itemSize] * 2);
    } else {
        _scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    [self updateDotAt:currentPage animated:NO];
    
}

- (void)updateDotAt: (int)currentPage animated: (BOOL)animated {
    
    [self updateDotColor:currentPage];
    
    if (_numberOfPages > _displayCount) {
        [self updateDotPosition:currentPage animated:animated];
        [self updateDotSize:currentPage animated:animated];
    }
}

- (void)updateDotColor: (int)currentPage {
    
    for (ItemView*view in _items) {
        view.dotColor = (view.index == currentPage) ? _currentPageIndicatorTintColor : _pageIndicatorTintColor;
    }
    
}

- (void)updateDotPosition: (int)currentPage animated: (BOOL)animated {
    
    NSTimeInterval duration = animated ? _animateDuration : 0;
    
    if (currentPage == 0) {
       CGFloat x = -_scrollView.contentInset.left;
        [self moveScrollView:x duration:duration];

    } else if (currentPage == _numberOfPages - 1) {
        CGFloat x = _scrollView.contentSize.width - _scrollView.bounds.size.width + _scrollView.contentInset.right;
        [self moveScrollView:x duration:duration];

    } else if (([self itemSize] * (CGFloat)currentPage) <= (_scrollView.contentOffset.x + [self itemSize])) {
        CGFloat x = _scrollView.contentOffset.x - [self itemSize];
        [self moveScrollView:x duration:duration];

    } else if (([self itemSize] * (CGFloat)currentPage + [self itemSize]) >= (_scrollView.contentOffset.x + _scrollView.bounds.size.width - [self itemSize])) {
        CGFloat x = _scrollView.contentOffset.x + [self itemSize];
        [self moveScrollView:x duration:duration];

    }
    
    
}

- (void)updateDotSize: (int)currentPage animated: (BOOL)animated {
    
    NSTimeInterval duration = animated ? _animateDuration : 0;
    
    for (ItemView*view in _items) {
        
        view.animateDuration = duration;
        
        if (view.index == currentPage) {
            view.state = Normal;
        }
        else if (view.index < 0) {
            view.state = None;
        }
        
        else if (view.index > _numberOfPages - 1) {
            view.state = None;
        }
        
        else if (CGRectGetMinX(view.frame) <= _scrollView.contentOffset.x) {
            view.state = Small;
        }
        
        else if (CGRectGetMaxX(view.frame) >= _scrollView.contentOffset.x + _scrollView.bounds.size.width) {
            view.state = Small;
        }
        
        else if (CGRectGetMinX(view.frame) <= _scrollView.contentOffset.x + [self itemSize]) {
            view.state = Medium;
        }
        
        else if (CGRectGetMaxX(view.frame) >= _scrollView.contentOffset.x + _scrollView.bounds.size.width - [self itemSize]) {
            view.state = Medium;
        }
        
        else {
            view.state = Normal;
        }
        
    }
    
    
}

- (void)moveScrollView: (CGFloat)x duration: (NSTimeInterval)duration {
    
    Direction direction = [self behaviorDirection:x];
    [self reusedView:direction];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:_animateDuration animations:^{
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf->_scrollView.contentOffset = CGPointMake(x, strongSelf->_scrollView.contentOffset.y);
    }];

}

- (Direction)behaviorDirection: (CGFloat)x {
    
    if (x > _scrollView.contentOffset.x) {
        return Right;
    } else if (x < _scrollView.contentOffset.x) {
        return Left;
    } else {
        return Stay;
    }
}

- (void)reusedView: (Direction)direction {
    
    ItemView *firstItem = [_items firstObject];
    ItemView *lastItem = [_items lastObject];
    
    if (direction == Left) {
        lastItem.index = firstItem.index - 1;
        lastItem.frame = CGRectMake((CGFloat)lastItem.index * [self itemSize], 0, [self itemSize], [self itemSize]);
        [_items insertObject:lastItem atIndex:0];
        [_items removeLastObject];
    }
    
    else if (direction == Right) {
        firstItem.index = lastItem.index + 1;
        firstItem.frame = CGRectMake((CGFloat)firstItem.index * [self itemSize], 0, [self itemSize], [self itemSize]);
        [_items insertObject:firstItem atIndex:_items.count];
        [_items removeObjectAtIndex:0];
    }
    
}

@end
