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
 @param tapHandle 点击背景回调,如不需点击回调请传 nil
 */
- (void)yf_showPlaceholderViewWithType:(YFPlaceholderType)type tapHandle:(void(^)(void))tapHandle;


/**
 在当前UIView上显示占位图，会覆盖整个View

 @param type 占位图类型
 @param title 占位图下面的提示内容
 @param tapHandle 点击背景回调,如不需点击回调请传 nil
 */
- (void)yf_showPlaceholderViewWithType:(YFPlaceholderType)type title:(NSString *)title tapHandle:(void(^)(void))tapHandle;

/**
 在当前UIView指定区域内显示占位图

 @param type 占位图类型
 @param edgeInset 占位图要显示的区域的偏移
 @param tapHandle 点击背景回调,如不需点击回调请传 nil
 */
- (void)yf_showPlaceholderViewWithType:(YFPlaceholderType)type edgeInset:(UIEdgeInsets)edgeInset tapHandle:(void(^)(void))tapHandle;


/**
 在当前UIView指定区域内显示占位图

 @param type 占位图类型
 @param title 占位图下面的提示内容
 @param edgeInset 占位图要显示的区域的偏移
 @param tapHandle 点击背景回调,如不需点击回调请传 nil
 */
- (void)yf_showPlaceholderViewWithType:(YFPlaceholderType)type title:(NSString *)title edgeInset:(UIEdgeInsets)edgeInset tapHandle:(void(^)(void))tapHandle;

/**
 在当前UIView上显示自定义的占位图

 @param customPlaceholder 自定义的占位图
 @param tapHandle 点击背景回调,如不需点击回调请传 nil
 */
- (void)yf_showCustomPlaceholderView:(__kindof UIView *)customPlaceholder tapHandle:(void (^)(void))tapHandle;

/**
 在当前UIView指定区域内显示自定义占位图

 @param customPlaceholder 自定义的占位图
 @param edgeInset 占位图要显示的区域的偏移
 @param tapHandle 点击背景回调,如不需点击回调请传 nil
 */
- (void)yf_showCustomPlaceholderView:(__kindof UIView *)customPlaceholder edgeInset:(UIEdgeInsets)edgeInset tapHandle:(void (^)(void))tapHandle;

/**
 移除当前UIView上的占位图
 */
- (void)yf_removePlaceholderView;

@end
