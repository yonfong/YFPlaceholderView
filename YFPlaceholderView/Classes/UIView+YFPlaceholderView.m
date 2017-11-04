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

@interface YFPlaceholderContainer : UIView

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIView *placeHolderView;

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets;

@property (nonatomic, copy) void (^yf_containerTapHandle)(void);

- (void)setupConstraints;

- (void)prepareForReuse;

@end

@implementation YFPlaceholderContainer

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.contentView];
        _contentEdgeInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (void)didMoveToSuperview {
    CGRect superviewBounds = self.superview.bounds;
    self.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(superviewBounds), CGRectGetHeight(superviewBounds));
    self.contentView.alpha = 1.0;
}

- (void)prepareForReuse {
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    [self removeAllConstraints];
}

- (void)setupConstraints {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1
                                                      constant:_contentEdgeInsets.top]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1
                                                      constant:_contentEdgeInsets.left]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1
                                                      constant:_contentEdgeInsets.bottom]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1
                                                      constant:_contentEdgeInsets.right]];

    if (_placeHolderView) {
        [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_placeHolderView
                                                                 attribute:NSLayoutAttributeCenterX
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_contentView
                                                                 attribute:NSLayoutAttributeCenterX
                                                                multiplier:1.0
                                                                  constant:0]];

        [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_placeHolderView
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_contentView
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1.0
                                                                  constant:0]];
    }
}

- (void)removeAllConstraints {
    [self removeConstraints:self.constraints];
    [_contentView removeConstraints:_contentView.constraints];
}

#pragma mark - getters && setters
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
        _contentView.backgroundColor = [UIColor clearColor];
        _contentView.userInteractionEnabled = YES;
        _contentView.alpha = 0;
    }
    return _contentView;
}

- (void)setYf_containerTapHandle:(void (^)(void))yf_containerTapHandle {
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

- (void)setPlaceHolderView:(UIView *)placeHolderView {
    if (!placeHolderView) {
        return;
    }

    if (_placeHolderView) {
        [_placeHolderView removeFromSuperview];
        _placeHolderView = nil;
    }

    _placeHolderView = placeHolderView;
    _placeHolderView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_placeHolderView];
}

@end

@interface UIView ()

@property (nonatomic, weak) YFPlaceholderContainer *yf_placeholderContainer;
@property (nonatomic, assign) BOOL yf_originalScrollEnabled;

@end

@implementation UIView (YFPlaceholderView)

- (void)yf_showPlaceholderViewWithType:(YFPlaceholderType)type tapHandle:(void (^)(void))tapHandle {
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
        // fix placeholderContainer position not correct
        [self layoutIfNeeded];

        // 如果是UIScrollView及其子类，占位图展示期间禁止scroll
        if ([self isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrollView = (UIScrollView *)self;

            if (self.yf_placeholderContainer.superview) {
                scrollView.scrollEnabled = self.yf_originalScrollEnabled;
            }

            // 先记录原本的scrollEnabled
            self.yf_originalScrollEnabled = scrollView.scrollEnabled;
            // 再将scrollEnabled设为NO
            scrollView.scrollEnabled = NO;
        }

        //------- 占位图 容器 -------//
        YFPlaceholderContainer *containerView = self.yf_placeholderContainer;
        if (!containerView) {
            containerView = [[YFPlaceholderContainer alloc] initWithFrame:CGRectZero];
        }

        if (!containerView.superview) {
            [self addSubview:containerView];
            self.yf_placeholderContainer = containerView;
        }

        [containerView prepareForReuse];
        containerView.contentEdgeInsets = edgeInset;
        containerView.placeHolderView = customPlaceholder;
        [containerView setupConstraints];

        self.yf_placeholderContainer.yf_containerTapHandle = tapHandle;

        [UIView performWithoutAnimation:^{
            [containerView layoutIfNeeded];
        }];
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
