//
//  NSBundle+YFPlaceholder.h
//  YFPlaceholderView
//
//  Created by bluesky0109 on 10/13/2017.
//  Copyright (c) 2017 bluesky0109. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle (YFPlaceholder)

/**
 获取 YFPlaceholderView Pod中的 资源文件

 @return YFPlaceholderView Pod中的 资源文件
 */
+ (NSBundle *)yf_placeholderBundle;

/**
 获取 YFPlaceholderView Pod中的 资源文件 URL路径

 @return YFPlaceholderView Pod中的 资源文件 URL路径
 */
+ (NSURL *)yf_placeholderBundleURL;

@end
