//
//  YFPlaceholderView.h
//  YFPlaceholderView
//
//  Created by bluesky0109 on 10/13/2017.
//  Copyright (c) 2017 bluesky0109. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YFPlaceholderType) {
    YFPlaceholderTypeLoading = 0,
    YFPlaceholderTypeFail ,
    YFPlaceholderTypeSuccess,
};

@interface YFPlaceholderView : UIView

- (instancetype)initWithPlaceHolderType:(YFPlaceholderType)placeholderType title:(NSString *)title;

+ (instancetype)placeholderViewWithType:(YFPlaceholderType)placeholderType title:(NSString *)title;

@end
