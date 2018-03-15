//
//  ImageFullScreenView.m
//  FunSDKDemo
//
//  Created by 朱松泽 on 2017/12/16.
//  Copyright © 2017年 xiongmaitech. All rights reserved.
//

#import "ImageFullScreenView.h"

@implementation ImageFullScreenView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpChildView];
    }
    return self;
}
#pragma mark --- other
- (void)setUpChildView {
    [self addSubview:self.myImageView];
    [self addSubview:self.myScrollView];
}

#pragma mark --- lazy load
- (UIImageView *)myImageView {
    if (_myImageView == nil) {
        _myImageView = [[UIImageView alloc] init];
        _myImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _myImageView;
}

- (UIScrollView *)myScrollView {
    if (_myScrollView == nil) {
        _myScrollView = [[UIScrollView alloc] init];
        
    }
    return _myScrollView;
}

#pragma mark --- action

@end
