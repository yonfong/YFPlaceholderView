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

@property (nonatomic, strong) UIImageView *indicatorImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, assign) YFPlaceholderType placeholderType;

@end

@implementation YFPlaceholderView

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithPlaceHolderType:YFPlaceholderTypeSuccess title:@""];
}

- (instancetype)initWithPlaceHolderType:(YFPlaceholderType)placeholderType title:(NSString *)title {
    if (self = [super initWithFrame:CGRectZero]) {
        [self setup];
        self.placeholderType = placeholderType;
        self.titleLabel.text = title;
    }
    return self;
}

+ (instancetype)placeholderViewWithType:(YFPlaceholderType)placeholderType title:(NSString *)title {
    return  [[self alloc] initWithPlaceHolderType:placeholderType title:title];
}

- (void)setup {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.indicatorImageView];
    [self addSubview:self.titleLabel];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_indicatorImageView);
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"|->=10-[_indicatorImageView]-|"
                          options:NSLayoutFormatAlignAllCenterX
                          metrics:nil views:views]];
    
    views = NSDictionaryOfVariableBindings(_titleLabel);
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"H:|-10-[_titleLabel]-|"
                          options:NSLayoutFormatAlignAllCenterX
                          metrics:nil views:views]];
    [_titleLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_indicatorImageView]-10-[_titleLabel]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_indicatorImageView,_titleLabel)]];
    
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
        _titleLabel.font = [UIFont systemFontOfSize:12];
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

