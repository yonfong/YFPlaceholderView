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

@end

@implementation UIView (YFPlaceholderView)

- (void)yf_showPlaceholderViewWithType:(YFPlaceholderType)type tapHandle:(void(^)(void))tapHandle {
    [self yf_showPlaceholderViewInRect:self.bounds type:type tapHandle:tapHandle];
}


- (void)yf_showPlaceholderViewInRect:(CGRect)showRect type:(YFPlaceholderType)type tapHandle:(void(^)(void))tapHandle {
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
        
        NSString *title = @"";
        if (type == YFPlaceholderTypeLoading) {
            title = @"努力加载中";
        } else if (type == YFPlaceholderTypeFail) {
            title = @"加载失败";
        }
        
        YFPlaceholderView *placeHolderView = [YFPlaceholderView placeholderViewWithType:type title:title];
        placeHolderView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.yf_placeholderContainer addSubview:placeHolderView];
        
        NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:placeHolderView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.yf_placeholderContainer attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        
        NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:placeHolderView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.yf_placeholderContainer attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
        
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

