//
//  ItemView.h
//  InsPageControl
//
//  Created by Eric JI on 2020/02/27.
//  Copyright © 2020 ericji. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ItemView : UIView

typedef struct ItemConfig {
    CGFloat dotSize;
    CGFloat itemSize;
    CGFloat smallDotSizeRatio;
    CGFloat mediumDotSizeRatio;
} ItemConfig;

typedef NS_ENUM(NSUInteger, State) {
    None,
    Small,
    Medium,
    Normal,
};

@property (nonatomic, readwrite, assign)int index;
@property (nonatomic, readwrite, strong)UIColor *dotColor;
@property (nonatomic, readwrite, assign)State state;
@property (nonatomic, assign)NSTimeInterval animateDuration;

- (instancetype)initWithConfig: (ItemConfig)config index: (int)index;


@end

NS_ASSUME_NONNULL_END
