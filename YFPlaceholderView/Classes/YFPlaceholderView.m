//
//  YFPlaceholderView.m
//  YFPlaceholderView
//
//  Created by bluesky0109 on 10/13/2017.
//  Copyright (c) 2017 bluesky0109. All rights reserved.
//

#import "YFPlaceholderView.h"
#import "UIImage+YFPlaceholder.h"

@interface YFPlaceholderView()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *indicatorImageView;
@property (nonatomic, assign) YFPlaceholderType placeholderType;

@end

@implementation YFPlaceholderView

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithPlaceHolderType:YFPlaceholderTypeSuccess title:@""];
}

- (instancetype)initWithPlaceHolderType:(YFPlaceholderType)placeholderType title:(NSString *)title {
    if (self = [super initWithFrame:CGRectZero]) {
        [self setupViews];
        self.placeholderType = placeholderType;
        self.titleLabel.text = title;
    }
    return self;
}

+ (instancetype)placeholderViewWithType:(YFPlaceholderType)placeholderType title:(NSString *)title {
    return  [[self alloc] initWithPlaceHolderType:placeholderType title:title];
}

- (void)setupViews {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.indicatorImageView];
    [self addSubview:self.titleLabel];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.indicatorImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.indicatorImageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:8]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:8]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:200]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.indicatorImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.indicatorImageView attribute:NSLayoutAttributeBottom multiplier:1 constant:8]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    if (!self.superview) {
        [self.indicatorImageView stopAnimating];
        self.indicatorImageView.animationImages = nil;
    } else {
        if (self.placeholderType == YFPlaceholderTypeLoading) {
            [self.indicatorImageView startAnimating];
        }
    }
}

#pragma mark - getters && setters
- (UIImageView *)indicatorImageView {
    if (!_indicatorImageView) {
        _indicatorImageView = [[UIImageView alloc] initWithImage:[UIImage yf_bundleImageNamed:@"yf_Indicator_Success"]];
        _indicatorImageView.animationDuration = 0.1;
        _indicatorImageView.animationRepeatCount = 0;
        _indicatorImageView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _indicatorImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor lightGrayColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _titleLabel;
}

- (void)setPlaceholderType:(YFPlaceholderType)placeholderType {
    _placeholderType = placeholderType;
    [self.indicatorImageView stopAnimating];
    if (placeholderType == YFPlaceholderTypeSuccess) {
        self.indicatorImageView.image = [UIImage yf_bundleImageNamed:@"yf_Indicator_Success"];
    } else if (placeholderType == YFPlaceholderTypeFail) {
        self.indicatorImageView.image = [UIImage yf_bundleImageNamed:@"yf_Indicator_Fail"];
    } else {
        self.indicatorImageView.animationImages = [self indicatorAnimationImages];
    }
}

- (NSArray<UIImage *> *)indicatorAnimationImages {
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:6];
    for (int index = 1; index <= 6; index++) {
        NSString *imageName = [NSString stringWithFormat:@"yf_Indicator_Loading_%d",index];
        UIImage *image = [UIImage yf_bundleImageNamed:imageName];
        if (image) {
            [images addObject:image];
        }
    }
    return images.copy;
}

@end

