//
//  SKYViewController.m
//  YFPlaceholderView
//
//  Created by bluesky0109 on 10/13/2017.
//  Copyright (c) 2017 bluesky0109. All rights reserved.
//

#import "Masonry.h"
#import "SKYViewController.h"
#import <YFPlaceholderView/UIView+YFPlaceholderView.h>

@interface SKYViewController ()

@property (nonatomic, strong) UITableView *topTableView;
@property (nonatomic, strong) UITableView *bottomTableView;

@end

@implementation SKYViewController

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.topTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.topTableView.scrollEnabled = NO;
    self.topTableView.allowsSelection = NO;
    [self.view addSubview:self.topTableView];

    [self.topTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(140);
    }];

    self.bottomTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.bottomTableView.rowHeight = 100;
    [self.view addSubview:self.bottomTableView];

    [self.bottomTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.and.left.and.right.equalTo(self.view);
        make.top.equalTo(self.topTableView.mas_bottom);
    }];

    __weak __typeof(self) weakSelf = self;
    [self.bottomTableView yf_showPlaceholderViewWithType:YFPlaceholderTypeLoading
                                                   title:@"拼命加载中..."
                                               tapHandle:^{
                                                   [weakSelf.bottomTableView yf_showPlaceholderViewWithType:YFPlaceholderTypeSuccess
                                                                                                  tapHandle:^{
                                                                                                      [weakSelf.bottomTableView
                                                                                                          yf_showPlaceholderViewWithType:YFPlaceholderTypeFail
                                                                                                                               tapHandle:^{
                                                                                                                                   [weakSelf.bottomTableView yf_removePlaceholderView];
                                                                                                                               }];
                                                                                                  }];
                                               }];
}

@end
