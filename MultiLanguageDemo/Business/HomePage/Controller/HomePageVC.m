//
//  HomePageVC.m
//  MultiLanguageDemo
//
//  Created by 朱松泽 on 2018/3/15.
//  Copyright © 2018年 朱松泽. All rights reserved.
//

#import "HomePageVC.h"

@interface HomePageVC ()
@property (nonatomic, strong) UIWebView *myWebView;
@end

@implementation HomePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpChildView];
    [self setDefaultLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- lazy laod
- (UIWebView *)myWebView {
    if (_myWebView == nil) {
        _myWebView = [[UIWebView alloc] init];
        // https://www.toutiao.com/search/?keyword=彩票
        [_myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.toutiao.com/search/?keyword=%E5%BD%A9%E7%A5%A8"]]];
    }
    return _myWebView;
}

#pragma mark --- action

#pragma mark --- other
- (void)setUpChildView {
    self.view.backgroundColor = GreenSpecialColor;
    [self.view addSubview:self.myWebView];
}

- (void)setDefaultLayout {
    [self.myWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
    }];
}



@end
