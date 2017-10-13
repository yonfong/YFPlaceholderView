//
//  UIImage+YFPlaceholder.h
//  YFPlaceholderView
//
//  Created by bluesky0109 on 10/13/2017.
//  Copyright (c) 2017 bluesky0109. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (YFPlaceholder)

+ (UIImage *)yf_bundleImageNamed:(NSString *)name;

+ (UIImage *)yf_imageNamed:(NSString *)name inBundle:(NSBundle *)bundle;

@end
