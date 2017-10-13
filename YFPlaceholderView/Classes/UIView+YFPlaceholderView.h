//
//  UIView+YFPlaceholderView.h
//  YFPlaceholderView
//
//  Created by bluesky0109 on 10/13/2017.
//  Copyright (c) 2017 bluesky0109. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YFPlaceholderView.h"

@interface UIView (YFPlaceholderView)


/**
 在当前UIView上显示占位图，会覆盖整个View

 @param type 占位图类型
 @param tapHandle 点击背景回调
 */
- (void)yf_showPlaceholderViewWithType:(YFPlaceholderType)type tapHandle:(void(^)(void))tapHandle;


/**
 在当前UIView指定区域内显示占位图

 @param showRect 占位图要显示的区域
 @param type 占位图类型
 @param tapHandle 点击背景回调
 */
- (void)yf_showPlaceholderViewInRect:(CGRect)showRect type:(YFPlaceholderType)type tapHandle:(void(^)(void))tapHandle;


/**
 移除当前UIView上的占位图
 */
- (void)yf_removePlaceholderView;

@end
