//
//  UIScrollView+LCYRefresh.m
//  LCYPullRefreshDemo
//
//  Created by eagle on 14/9/18.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "UIScrollView+LCYRefresh.h"
#import <objc/runtime.h>

@interface LCYRefreshView()
@property (nonatomic,strong) UIImageView *imageViewProgress;
@property (nonatomic,strong) UIImageView *imageViewLoading;

@property (nonatomic,strong) NSArray *pImgArrProgress;
@property (nonatomic,strong) NSArray *pImgArrLoading;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, assign) double progress;
@property (nonatomic, assign) NSInteger progressThreshold;
@property (nonatomic, assign) NSInteger LoadingFrameRate;

@end

@implementation LCYRefreshView

- (instancetype)initWithProgressImages:(NSArray *)progressImg
                         LoadingImages:(NSArray *)loadingImages
               ProgressScrollThreshold:(NSInteger)threshold
                LoadingImagesFrameRate:(NSInteger)lFrameRate{
    if(threshold <=0){
        threshold = initialPulltoRefreshThreshold;
    }
    UIImage *image1 = progressImg.firstObject;
    self = [super initWithFrame:CGRectMake(0, -image1.size.height, image1.size.width, image1.size.height)];
    if(self) {
        self.pImgArrProgress = progressImg;
        self.pImgArrLoading = loadingImages;
        self.progressThreshold = threshold;
        self.LoadingFrameRate = lFrameRate;
        [self _commonInit];
    }
    return self;
}

- (void)_commonInit{
    self.contentMode = UIViewContentModeRedraw;
    self.state = LCYPullToRefreshStateNone;
    self.backgroundColor = [UIColor clearColor];
    
    NSAssert([self.pImgArrProgress.lastObject isKindOfClass:[UIImage class]], @"pImgArrProgress Array has object that is not image");
    self.imageViewProgress = [[UIImageView alloc] initWithImage:[self.pImgArrProgress lastObject]];
    self.imageViewProgress.contentMode = UIViewContentModeScaleAspectFit;
    self.imageViewProgress.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight ;
    self.imageViewProgress.frame = self.bounds;
    self.imageViewProgress.backgroundColor = [UIColor clearColor];
    [self addSubview:self.imageViewProgress];
    
    if(self.pImgArrLoading==nil)
    {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicatorView.hidesWhenStopped = YES;
        _activityIndicatorView.frame = self.bounds;
        [self addSubview:_activityIndicatorView];
    }
    else
    {
        NSAssert([self.pImgArrLoading.lastObject isKindOfClass:[UIImage class]], @"pImgArrLoading Array has object that is not image");
        self.imageViewLoading = [[UIImageView alloc] initWithImage:[self.pImgArrLoading firstObject]];
        self.imageViewLoading.contentMode = UIViewContentModeScaleAspectFit;
        self.imageViewLoading.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight ;
        self.imageViewLoading.frame = self.bounds;
        self.imageViewLoading.animationImages = self.pImgArrLoading;
        self.imageViewLoading.animationDuration = (CGFloat)ceilf((1.0/(CGFloat)self.LoadingFrameRate) * (CGFloat)self.imageViewLoading.animationImages.count);
        self.imageViewLoading.alpha = 0;
        self.imageViewLoading.backgroundColor = [UIColor clearColor];
        [self addSubview:self.imageViewLoading];
    }
    self.alpha = 0;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat midX = self.scrollView.bounds.size.width / 2.0f;
    CGPoint center = self.center;
    center.x = midX;
    self.center = center;
}

#pragma mark - ScrollViewInset
- (void)setupScrollViewContentInsetForLoadingIndicator:(actionHandler)handler{
    CGFloat offset = MAX(self.scrollView.contentOffset.y * -1, 0);
    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    currentInsets.top = MIN(offset, self.originalTopInset + self.bounds.size.height + 20.0);
    [self setScrollViewContentInset:currentInsets handler:handler];
}

- (void)resetScrollViewContentInset:(actionHandler)handler{
    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    currentInsets.top = self.originalTopInset;
    [self setScrollViewContentInset:currentInsets handler:handler];
}

- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset handler:(actionHandler)handler{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.scrollView.contentInset = contentInset;
                     }
                     completion:^(BOOL finished) {
                         if(handler)
                             handler();
                     }];
}

#pragma mark - property
- (void)setProgress:(double)progress{
    static double prevProgress;
    if(progress > 1.0)
    {
        progress = 1.0;
    }
    if(self.showAlphaTransition)
    {
        self.alpha = 1.0 * progress;
    }
    else
    {
        CGFloat alphaValue = 1.0 * progress *5;
        if(alphaValue > 1.0)
            alphaValue = 1.0f;
        self.alpha = alphaValue;
    }
    if (progress >= 0 && progress <=1.0) {
        //Animation
        NSInteger index = (NSInteger)roundf((self.pImgArrProgress.count ) * progress);
        if(index ==0)
        {
            self.imageViewProgress.image = nil;
        }
        else
        {
            self.imageViewProgress.image = [self.pImgArrProgress objectAtIndex:index-1];
        }
    }
    _progress = progress;
    prevProgress = progress;
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if([keyPath isEqualToString:@"contentOffset"])
    {
        [self scrollViewDidScroll:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
    }
    else if([keyPath isEqualToString:@"contentSize"])
    {
        [self setNeedsLayout];
        [self setNeedsDisplay];
    }
    else if([keyPath isEqualToString:@"frame"])
    {
        [self setFrameSizeByProgressImage];
        
        [self setNeedsLayout];
        [self setNeedsDisplay];
    }
}
- (void)scrollViewDidScroll:(CGPoint)contentOffset{
    static double prevProgress;
    CGFloat yOffset = contentOffset.y;
    self.progress = ((yOffset+ self.originalTopInset + StartPosition)/(-self.progressThreshold ));
    //    NSLog(@"progrss %f yOffset %f",self.progress,yOffset);
    self.center = CGPointMake(self.center.x, (contentOffset.y+ self.originalTopInset)/2);
    switch (_state) {
        case LCYPullToRefreshStateStopped: //finish
            //            NSLog(@"Stoped");
            break;
        case LCYPullToRefreshStateNone: //detect action
        {
            //            NSLog(@"None");
            if(self.scrollView.isDragging && yOffset <0 )
            {
                self.state = LCYPullToRefreshStateTriggering;
            }
        }
        case LCYPullToRefreshStateTriggering: //progress
        {
            //                        NSLog(@"trigering");
            if(self.progress >= 1.0)
                self.state = LCYPullToRefreshStateTriggered;
        }
            break;
        case LCYPullToRefreshStateTriggered: //fire actionhandler
            //                        NSLog(@"trigered");
            if(self.scrollView.tracking == NO && prevProgress > 0.98)
            {
                [self actionTriggeredState];
            }
            break;
        case LCYPullToRefreshStateLoading: //wait until stopIndicatorAnimation
            
            break;
        case LCYPullToRefreshStateCanFinish:
            if(self.progress < 0.01 + ((CGFloat)StartPosition/-self.progressThreshold) && self.progress > -0.01 +((CGFloat)StartPosition/-self.progressThreshold))
            {
                self.state = LCYPullToRefreshStateNone;
            }
            break;
        default:
            break;
    }
    //because of iOS6 KVO performance
    prevProgress = self.progress;
    
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (self.superview && newSuperview == nil) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        if (scrollView.showPullToRefresh) {
            if (self.isObserving) {
                [scrollView removeObserver:self forKeyPath:@"contentOffset"];
                [scrollView removeObserver:self forKeyPath:@"contentSize"];
                [scrollView removeObserver:self forKeyPath:@"frame"];
                self.isObserving = NO;
            }
        }
    }
}

-(void)actionStopState{
    self.state = LCYPullToRefreshStateCanFinish;
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction animations:^{
        if(self.pImgArrLoading.count>0)
        {
            
        }
        else
        {
            self.activityIndicatorView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        }
    } completion:^(BOOL finished) {
        
        if(self.pImgArrLoading.count>0)
        {
            [self.imageViewLoading stopAnimating];
            self.imageViewLoading.alpha = 0.0;
            
        }
        else
        {
            self.activityIndicatorView.transform = CGAffineTransformIdentity;
            [self.activityIndicatorView stopAnimating];
            self.activityIndicatorView.alpha = 0.0;
        }
        
        
        [self resetScrollViewContentInset:^{
            self.imageViewProgress.alpha = 1.0;
            if(self.isVariableSize)
                [self setFrameSizeByProgressImage];
        }];
        
    }];
}

-(void)actionTriggeredState{
    self.state = LCYPullToRefreshStateLoading;
    
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction animations:^{
        self.imageViewProgress.alpha = 0.0;
        if(self.isVariableSize)
        {
            [self setFrameSizeByLoadingImage];
        }
        if(self.pImgArrLoading.count>0)
        {
            self.imageViewLoading.alpha = 1.0;
        }
        else
        {
            self.activityIndicatorView.alpha = 1.0;
        }
    } completion:^(BOOL finished) {
    }];
    
    if(self.pImgArrLoading.count>0)
    {
        [self.imageViewLoading startAnimating];
    }
    else
    {
        [self.activityIndicatorView startAnimating];
    }
    [self setupScrollViewContentInsetForLoadingIndicator:nil];
    if(self.pullToRefreshHandler)
        self.pullToRefreshHandler();
}
- (void)setFrameSizeByProgressImage{
    UIImage *image1 = self.pImgArrProgress.lastObject;
    if(image1)
        self.frame = CGRectMake((self.scrollView.bounds.size.width - image1.size.width)/2, -image1.size.height, image1.size.width, image1.size.height);
}
- (void)setFrameSizeByLoadingImage{
    UIImage *image1 = self.pImgArrLoading.lastObject;
    if(image1)
    {
        self.frame = CGRectMake((self.scrollView.bounds.size.width - image1.size.width)/2, -image1.size.height, image1.size.width, image1.size.height);
    }
}

#pragma mark - public methods

- (void)stopIndicatorAnimation{
    [self actionStopState];
}
- (void)manuallyTriggered{
    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    currentInsets.top = self.originalTopInset + self.bounds.size.height + 20.0;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, -currentInsets.top);
    } completion:^(BOOL finished) {
        [self actionTriggeredState];
    }];
}
- (void)setSize:(CGSize) size{
    CGRect rect = CGRectMake((self.scrollView.bounds.size.width - size.width)/2,
                             -size.height, size.width, size.height);
    self.frame=rect;
    self.activityIndicatorView.frame = self.bounds;
    self.imageViewProgress.frame = self.bounds;
    self.imageViewLoading.frame = self.bounds;
}
- (void)setIsVariableSize:(BOOL)isVariableSize{
    _isVariableSize = isVariableSize;
    if(!_isVariableSize)
    {
        [self setFrameSizeByProgressImage];
    }
}

@end

static char UIScrollViewPullToRefreshView;

@implementation UIScrollView (LCYRefresh)

- (void)addPullToRefreshActionHandler:(actionHandler)handler
                       ProgressImages:(NSArray *)progressImages
                        LoadingImages:(NSArray *)loadingImages
              ProgressScrollThreshold:(NSInteger)threshold
               LoadingImagesFrameRate:(NSInteger)lframe{
    if(self.pullToRefreshView == nil)
    {
        LCYRefreshView *view = [[LCYRefreshView alloc] initWithProgressImages:progressImages LoadingImages:loadingImages ProgressScrollThreshold:threshold LoadingImagesFrameRate:lframe];
        view.pullToRefreshHandler = handler;
        view.scrollView = self;
        view.frame = CGRectMake((self.bounds.size.width - view.bounds.size.width)/2,
                                -view.bounds.size.height, view.bounds.size.width, view.bounds.size.height);
        view.originalTopInset = self.contentInset.top;
        [self addSubview:view];
        [self sendSubviewToBack:view];
        self.pullToRefreshView = view;
        self.showPullToRefresh = YES;
    }
}

- (void)triggerPullToRefresh
{
    [self.pullToRefreshView manuallyTriggered];
}
- (void)stopRefreshAnimation
{
    [self.pullToRefreshView stopIndicatorAnimation];
}

#pragma mark - property
- (void)setPullToRefreshView:(LCYRefreshView *)pullToRefreshView
{
    [self willChangeValueForKey:@"LCYRefreshView"];
    objc_setAssociatedObject(self, &UIScrollViewPullToRefreshView, pullToRefreshView, OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"LCYRefreshView"];
}
- (LCYRefreshView *)pullToRefreshView
{
    return objc_getAssociatedObject(self, &UIScrollViewPullToRefreshView);
}

- (void)setShowPullToRefresh:(BOOL)showPullToRefresh {
    self.pullToRefreshView.hidden = !showPullToRefresh;
    
    if(showPullToRefresh)
    {
        if(!self.pullToRefreshView.isObserving)
        {
            [self addObserver:self.pullToRefreshView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
            [self addObserver:self.pullToRefreshView forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
            [self addObserver:self.pullToRefreshView forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
            [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification
                                                       object:[UIDevice currentDevice]];
            
            self.pullToRefreshView.isObserving = YES;
        }
    }
    else
    {
        if(self.pullToRefreshView.isObserving)
        {
            [self removeObserver:self.pullToRefreshView forKeyPath:@"contentOffset"];
            [self removeObserver:self.pullToRefreshView forKeyPath:@"contentSize"];
            [self removeObserver:self.pullToRefreshView forKeyPath:@"frame"];
            [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
            
            self.pullToRefreshView.isObserving = NO;
        }
    }
}

- (BOOL)showPullToRefresh
{
    return !self.pullToRefreshView.hidden;
}

- (void)setShowAlphaTransition:(BOOL)showAlphaTransition
{
    self.pullToRefreshView.showAlphaTransition = showAlphaTransition;
}
- (BOOL)showAlphaTransition
{
    return self.pullToRefreshView.showAlphaTransition;
}
- (void)setShowVariableSize:(BOOL)showVariableSize
{
    self.pullToRefreshView.isVariableSize = showVariableSize;
}
-(BOOL)showVariableSize
{
    return self.pullToRefreshView.isVariableSize;
}

- (void) orientationChanged:(NSNotification *)note
{
    //    UIDevice * device = note.object;
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.pullToRefreshView.state == LCYPullToRefreshStateLoading && self.pullToRefreshView.isVariableSize)
        {
            [self.pullToRefreshView setFrameSizeByLoadingImage];
        }
        else
        {
            [self.pullToRefreshView setFrameSizeByProgressImage];
        }
    });
}

@end
