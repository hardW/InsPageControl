//
//  PageControl.h
//  InsPageControl
//
//  Created by Eric JI on 2020/02/27.
//  Copyright © 2020 ericji. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef struct Config {
    int displayCount;
    CGFloat dotSize;
    CGFloat dotSpace;
    CGFloat smallDotSizeRatio;
    CGFloat mediumDotSizeRatio;
} Config;

@interface PageControl : UIView

@property (nonatomic, readwrite, assign)Config config;
@property (nonatomic, readwrite, assign)int currentPage;
@property (nonatomic, readwrite, assign)int numberOfPages;
@property (nonatomic, readwrite, assign)BOOL hidesForSinglePage;
@property (nonatomic, readwrite, assign)NSTimeInterval animateDuration;
@property (nonatomic, readwrite, strong)UIColor *pageIndicatorTintColor;
@property (nonatomic, readwrite, strong)UIColor *currentPageIndicatorTintColor;

- (void)setProgress: (CGFloat)contentOffsetX pageWidth: (CGFloat)pageWidth;

@end

NS_ASSUME_NONNULL_END
