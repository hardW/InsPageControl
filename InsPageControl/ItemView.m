//
//  ItemView.m
//  InsPageControl
//
//  Created by Eric JI on 2020/02/27.
//  Copyright © 2020 ericji. All rights reserved.
//

#import "ItemView.h"

@implementation ItemView {
    UIView *_dotView;
    CGFloat _itemSize;
    CGFloat _dotSize;
    CGFloat _smallSizeRatio;
    CGFloat _mediumSizeRatio;
}

- (instancetype)initWithConfig: (ItemConfig)config index: (int)index
{
    
    CGFloat x = config.itemSize*(CGFloat)index;
    CGRect frame = CGRectMake(x, 0, config.itemSize, config.itemSize);
    
    self = [super initWithFrame: frame];
    if (self) {
        _dotView = [UIView new];
        
        _itemSize = config.itemSize;
        _dotSize = config.dotSize;
        _mediumSizeRatio = config.mediumDotSizeRatio;
        _smallSizeRatio = config.smallDotSizeRatio;
        _index = index;
        
        self.backgroundColor = [UIColor clearColor];
        _dotView.frame = CGRectMake(0, 0, _dotSize, _dotSize);
        _dotView.center = CGPointMake(_itemSize/2, _itemSize/2);
        _dotView.backgroundColor = [UIColor lightGrayColor];
        _dotView.layer.cornerRadius = _dotSize/2;
        _dotView.layer.masksToBounds = YES;
        
        _animateDuration = 0.3;
        
        [self addSubview:_dotView];

    }
    return self;
}

- (void)updateDotSize: (State)state {
    
    CGSize size = CGSizeZero;
    
    switch (state) {
        case Normal:
            size = CGSizeMake(_dotSize, _dotSize);
            break;
        case Medium:
            size = CGSizeMake(_dotSize * _mediumSizeRatio, _dotSize * _mediumSizeRatio);
            break;
        case Small:
            size = CGSizeMake(_dotSize * _smallSizeRatio, _dotSize * _smallSizeRatio);
            break;
        default:
            break;
    }
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:_animateDuration animations:^{
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf->_dotView.layer.cornerRadius = size.height / 2.0;
        strongSelf->_dotView.layer.bounds = CGRectMake(0, 0, size.width, size.height);
    }];
    
}

#pragma mark - Set functions

- (void)setState:(State)state {
    [self updateDotSize:state];
}

- (void)setDotColor:(UIColor *)dotColor {
    _dotView.backgroundColor = dotColor;
}


@end
