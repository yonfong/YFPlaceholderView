//
//  SKYViewController.m
//  YFPlaceholderView
//
//  Created by bluesky0109 on 10/13/2017.
//  Copyright (c) 2017 bluesky0109. All rights reserved.
//

#import "SKYViewController.h"
#import <YFPlaceholderView/UIView+YFPlaceholderView.h>

@interface SKYViewController ()

@end

@implementation SKYViewController

- (void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    __weak __typeof(self) weakSelf = self;
    [self.view yf_showPlaceholderViewWithType:YFPlaceholderTypeLoading title:@"拼命加载中..." tapHandle:^{
        [weakSelf.view yf_showPlaceholderViewWithType:YFPlaceholderTypeSuccess tapHandle:^{
            [weakSelf.view yf_showPlaceholderViewWithType:YFPlaceholderTypeFail tapHandle:^{
                [weakSelf.view yf_removePlaceholderView];
            }];
        }];
    }];
}

@end
