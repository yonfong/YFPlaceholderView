//
//  NSBundle+YFPlaceholder.m
//  YFPlaceholderView
//
//  Created by bluesky0109 on 10/13/2017.
//  Copyright (c) 2017 bluesky0109. All rights reserved.
//

#import "NSBundle+YFPlaceholder.h"

static NSString * const kPodName = @"YFPlaceholderView";

@implementation NSBundle (YFPlaceHolder)

+ (NSBundle *)yf_placeholderBundle {
    return [self bundleWithURL:[self yf_placeholderBundleURL]];
}

+ (NSURL *)yf_placeholderBundleURL {
    NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(kPodName)];
    return [bundle URLForResource:kPodName withExtension:@"bundle"];
}

@end
