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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    __weak __typeof(self) weakSelf = self;
    
    [self.view yf_showPlaceholderViewWithType:YFPlaceholderTypeLoading tapHandle:^{
        [weakSelf.view yf_showPlaceholderViewWithType:YFPlaceholderTypeSuccess tapHandle:^{
            [weakSelf.view yf_showPlaceholderViewWithType:YFPlaceholderTypeFail tapHandle:^{
                [weakSelf.view yf_removePlaceholderView];
            }];
        }];
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
