//
//  UIScrollView+LCYRefresh.h
//  LCYPullRefreshDemo
//
//  Created by eagle on 14/9/18.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <UIKit/UIKit.h>

#define initialPulltoRefreshThreshold 40.0
#define StartPosition 10.0

typedef void (^actionHandler)(void);
typedef NS_ENUM(NSUInteger, LCYPullToRefreshState) {
    LCYPullToRefreshStateNone = 0,
    LCYPullToRefreshStateStopped,
    LCYPullToRefreshStateTriggering,
    LCYPullToRefreshStateTriggered,
    LCYPullToRefreshStateLoading,
    LCYPullToRefreshStateCanFinish,
};


@class LCYRefreshView;
@interface UIScrollView (LCYRefresh)
@property (nonatomic,assign) BOOL showPullToRefresh;
@property (nonatomic,assign) BOOL showAlphaTransition;
@property (nonatomic,assign) BOOL showVariableSize;
@property (nonatomic,strong) LCYRefreshView *pullToRefreshView;

- (void)addPullToRefreshActionHandler:(actionHandler)handler
                       ProgressImages:(NSArray *)progressImages
                        LoadingImages:(NSArray *)loadingImages
              ProgressScrollThreshold:(NSInteger)threshold
               LoadingImagesFrameRate:(NSInteger)lframe;

/**
 *  强制触发下拉刷新:LCYRefresh
 */
- (void)triggerPullToRefresh;
/**
 *  停止下拉刷新动画:LCYRefresh
 */
- (void)stopRefreshAnimation;
@end


@interface LCYRefreshView : UIView
@property (nonatomic,assign) BOOL isObserving;
@property (nonatomic,assign) CGFloat originalTopInset;
@property (nonatomic,assign) LCYPullToRefreshState state;
@property (nonatomic,weak) UIScrollView *scrollView;
@property (nonatomic,copy) actionHandler pullToRefreshHandler;
@property (nonatomic,assign) BOOL showAlphaTransition;
@property (nonatomic,assign) BOOL isVariableSize;
- (instancetype)initWithProgressImages:(NSArray *)progressImg LoadingImages:(NSArray *)loadingImages ProgressScrollThreshold:(NSInteger)threshold LoadingImagesFrameRate:(NSInteger)lFrameRate;
- (void)stopIndicatorAnimation;
- (void)manuallyTriggered;
- (void)setSize:(CGSize) size;

- (void)setFrameSizeByProgressImage;
- (void)setFrameSizeByLoadingImage;
@end
