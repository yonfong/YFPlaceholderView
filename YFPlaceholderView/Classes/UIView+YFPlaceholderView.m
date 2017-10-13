//
//  UIView+YFPlaceholderView.m
//  YFPlaceholderView
//
//  Created by bluesky0109 on 10/13/2017.
//  Copyright (c) 2017 bluesky0109. All rights reserved.
//

#import "UIView+YFPlaceholderView.h"

@import ObjectiveC.runtime;

@interface UIView()

@property (nonatomic, strong) UIView *yf_placeholderContainer;

@property (nonatomic, assign) BOOL yf_originalScrollEnabled;

@property (nonatomic, copy) void(^yf_containerTapHandle)(void);

@end

@implementation UIView (YFPlaceholderView)

- (void)yf_showPlaceholderViewWithType:(YFPlaceholderType)type tapHandle:(void(^)(void))tapHandle {
    [self yf_showPlaceholderViewWithType:type title:nil tapHandle:tapHandle];
}

- (void)yf_showPlaceholderViewWithType:(YFPlaceholderType)type title:(NSString *)title tapHandle:(void (^)(void))tapHandle {
    YFPlaceholderView *placeHolderView = [YFPlaceholderView placeholderViewWithType:type title:title];
    return [self yf_showCustomPlaceholderView:placeHolderView inRect:self.bounds tapHandle:tapHandle];
}

- (void)yf_showPlaceholderViewInRect:(CGRect)showRect type:(YFPlaceholderType)type tapHandle:(void(^)(void))tapHandle {
    return [self yf_showPlaceholderViewInRect:showRect type:type title:nil tapHandle:tapHandle];
}

- (void)yf_showPlaceholderViewInRect:(CGRect)showRect type:(YFPlaceholderType)type title:(NSString *)title tapHandle:(void (^)(void))tapHandle {
    YFPlaceholderView *placeHolderView = [YFPlaceholderView placeholderViewWithType:type title:title];
    return [self yf_showCustomPlaceholderView:placeHolderView inRect:showRect tapHandle:tapHandle];
}

- (void)yf_showCustomPlaceholderView:(__kindof UIView *)customPlaceholder tapHandle:(void (^)(void))tapHandle {
    return [self yf_showCustomPlaceholderView:customPlaceholder inRect:self.bounds tapHandle:tapHandle];
}

- (void)yf_showCustomPlaceholderView:(__kindof UIView *)customPlaceholder inRect:(CGRect)showRect tapHandle:(void (^)(void))tapHandle {
    
    if (customPlaceholder == nil) {
        return;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.00 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 如果是UIScrollView及其子类，占位图展示期间禁止scroll
        if ([self isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrollView = (UIScrollView *)self;
            // 先记录原本的scrollEnabled
            self.yf_originalScrollEnabled = scrollView.scrollEnabled;
            // 再将scrollEnabled设为NO
            scrollView.scrollEnabled = NO;
        }
        
        //------- 占位图 -------//
        if (self.yf_placeholderContainer) {
            [self.yf_placeholderContainer removeFromSuperview];
            self.yf_placeholderContainer = nil;
        }
        self.yf_placeholderContainer = [[UIView alloc] initWithFrame:showRect];
        [self addSubview:self.yf_placeholderContainer];
        self.yf_placeholderContainer.backgroundColor = [UIColor whiteColor];
        
        if (tapHandle) {
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(yf_placeholderContainerTaped)];
            [self.yf_placeholderContainer addGestureRecognizer:tapGesture];
            self.yf_containerTapHandle = tapHandle;
        } else {
            self.yf_containerTapHandle = nil;
        }
        
        customPlaceholder.translatesAutoresizingMaskIntoConstraints = NO;
        [self.yf_placeholderContainer addSubview:customPlaceholder];
        
        NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:customPlaceholder attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.yf_placeholderContainer attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        
        NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:customPlaceholder attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.yf_placeholderContainer attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
        
        [self.yf_placeholderContainer addConstraint:centerXConstraint];
        [self.yf_placeholderContainer addConstraint:centerYConstraint];
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

- (void)yf_placeholderContainerTaped {
    if (self.yf_containerTapHandle) {
        self.yf_containerTapHandle();
    }
}

- (void(^)(void))yf_containerTapHandle {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setYf_containerTapHandle:(void(^)(void))yf_containerTapHandle {
    objc_setAssociatedObject(self, @selector(yf_containerTapHandle), yf_containerTapHandle, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UIView *)yf_placeholderContainer {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setYf_placeholderContainer:(UIView *)yf_placeholderContainer {
    objc_setAssociatedObject(self, @selector(yf_placeholderContainer), yf_placeholderContainer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)yf_originalScrollEnabled {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setYf_originalScrollEnabled:(BOOL)yf_originalScrollEnabled {
    objc_setAssociatedObject(self, @selector(yf_originalScrollEnabled), @(yf_originalScrollEnabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

