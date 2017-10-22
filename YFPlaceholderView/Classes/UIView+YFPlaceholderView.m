//
//  UIView+YFPlaceholderView.m
//  YFPlaceholderView
//
//  Created by bluesky0109 on 10/13/2017.
//  Copyright (c) 2017 bluesky0109. All rights reserved.
//

#import "UIView+YFPlaceholderView.h"

@import ObjectiveC.runtime;

// 主线程执行
NS_INLINE void dispatch_main_async(dispatch_block_t block) {
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

@interface YFPlaceholderContainer: UIView

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@property (nonatomic, copy) void(^yf_containerTapHandle)(void);

@end

@implementation YFPlaceholderContainer

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setYf_containerTapHandle:(void (^)(void))yf_containerTapHandle
{
    _yf_containerTapHandle = yf_containerTapHandle;
    if (yf_containerTapHandle) {
        self.tapGesture.enabled = YES;
    } else {
        self.tapGesture.enabled = NO;
    }
}

- (void)yf_placeholderContainerTaped {
    if (self.yf_containerTapHandle) {
        self.yf_containerTapHandle();
    }
}

- (UITapGestureRecognizer *)tapGesture {
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(yf_placeholderContainerTaped)];
        [self addGestureRecognizer:_tapGesture];
    }
    return _tapGesture;
}

@end


@interface UIView()

@property (nonatomic, weak) YFPlaceholderContainer *yf_placeholderContainer;
@property (nonatomic, assign) BOOL yf_originalScrollEnabled;

@end

@implementation UIView (YFPlaceholderView)

- (void)yf_showPlaceholderViewWithType:(YFPlaceholderType)type tapHandle:(void(^)(void))tapHandle {
    [self yf_showPlaceholderViewWithType:type title:nil tapHandle:tapHandle];
}

- (void)yf_showPlaceholderViewWithType:(YFPlaceholderType)type edgeInset:(UIEdgeInsets)edgeInset tapHandle:(void (^)(void))tapHandle {
    return [self yf_showPlaceholderViewWithType:type title:nil edgeInset:edgeInset tapHandle:tapHandle];
}

- (void)yf_showPlaceholderViewWithType:(YFPlaceholderType)type title:(NSString *)title tapHandle:(void (^)(void))tapHandle {
    return [self yf_showPlaceholderViewWithType:type title:title edgeInset:UIEdgeInsetsZero tapHandle:tapHandle];
}

- (void)yf_showPlaceholderViewWithType:(YFPlaceholderType)type title:(NSString *)title edgeInset:(UIEdgeInsets)edgeInset tapHandle:(void (^)(void))tapHandle {
    YFPlaceholderView *placeHolderView = [YFPlaceholderView placeholderViewWithType:type title:title];
    return [self yf_showCustomPlaceholderView:placeHolderView edgeInset:edgeInset tapHandle:tapHandle];
}

- (void)yf_showCustomPlaceholderView:(__kindof UIView *)customPlaceholder tapHandle:(void (^)(void))tapHandle {
    return [self yf_showCustomPlaceholderView:customPlaceholder edgeInset:UIEdgeInsetsZero tapHandle:tapHandle];
}

- (void)yf_showCustomPlaceholderView:(__kindof UIView *)customPlaceholder edgeInset:(UIEdgeInsets)edgeInset tapHandle:(void (^)(void))tapHandle {
    
    if (customPlaceholder == nil) {
        return;
    }
    
    dispatch_main_async(^{
        // 如果是UIScrollView及其子类，占位图展示期间禁止scroll
        if ([self isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrollView = (UIScrollView *)self;
            // 先记录原本的scrollEnabled
            self.yf_originalScrollEnabled = scrollView.scrollEnabled;
            // 再将scrollEnabled设为NO
            scrollView.scrollEnabled = NO;
        }
        
        //------- 占位图 容器 -------//
        if (self.yf_placeholderContainer) {
            [self.yf_placeholderContainer removeFromSuperview];
            self.yf_placeholderContainer = nil;
        }
        YFPlaceholderContainer *placeholderContainer = [[YFPlaceholderContainer alloc] initWithFrame:CGRectZero];
        [self addSubview:placeholderContainer];
        [placeholderContainer addSubview:customPlaceholder];
        
        self.yf_placeholderContainer = placeholderContainer;
        self.yf_placeholderContainer.yf_containerTapHandle = tapHandle;
        
        // layout placeholderContainer
        placeholderContainer.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraint:[NSLayoutConstraint constraintWithItem:placeholderContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:edgeInset.top]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:placeholderContainer attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:edgeInset.left]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:placeholderContainer attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:edgeInset.bottom]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:placeholderContainer attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:edgeInset.right]];
        
        
        // layout customPlaceholder
        customPlaceholder.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:customPlaceholder attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:placeholderContainer attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        
        NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:customPlaceholder attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:placeholderContainer attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
        
        [placeholderContainer addConstraint:centerXConstraint];
        [placeholderContainer addConstraint:centerYConstraint];
        
        // 确保 占位图 布局正确
        [self layoutIfNeeded];
        [self.yf_placeholderContainer layoutIfNeeded];
    });
}


- (void)yf_removePlaceholderView {
    if (self.yf_placeholderContainer) {
        [self.yf_placeholderContainer removeFromSuperview];
        self.yf_placeholderContainer = nil;
    }
    // 复原UIScrollView的scrollEnabled
    if ([self isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self;
        scrollView.scrollEnabled = self.yf_originalScrollEnabled;
    }
}

- (YFPlaceholderContainer *)yf_placeholderContainer {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setYf_placeholderContainer:(YFPlaceholderContainer *)yf_placeholderContainer {
    objc_setAssociatedObject(self, @selector(yf_placeholderContainer), yf_placeholderContainer, OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)yf_originalScrollEnabled {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setYf_originalScrollEnabled:(BOOL)yf_originalScrollEnabled {
    objc_setAssociatedObject(self, @selector(yf_originalScrollEnabled), @(yf_originalScrollEnabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

