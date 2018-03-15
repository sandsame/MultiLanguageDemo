//
//  ZSZPlaceHolderView.m
//  FunSDKDemo
//
//  Created by 朱松泽 on 2018/1/10.
//  Copyright © 2018年 xiongmaitech. All rights reserved.
//

#import "ZSZPlaceHolderView.h"

@implementation ZSZPlaceHolderView


- (instancetype)init {
    if (self = [super init]) {
        self.ImageViewWidth = 150;
        [self setUpChildView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.myImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(self.ImageViewWidth);
        make.centerX.equalTo(self.mas_centerX).offset(0);
        make.centerY.equalTo(self.mas_centerY).offset(-self.frame.size.height/5);
    }];
    
    [self.myLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.top.equalTo(self.myImageView.mas_bottom).offset(8);
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
    }];
    
}

#pragma mark --- lazy load
- (UIImageView *)myImageView {
    if (_myImageView == nil) {
        _myImageView = [[UIImageView alloc] init];
        _myImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _myImageView;
}

- (UILabel *)myLabel {
    if (_myLabel == nil) {
        _myLabel = [[UILabel alloc] init];
        _myLabel.font = FONT(18);
        _myLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _myLabel;
}

- (void)setImageViewWidth:(NSInteger)ImageViewWidth {
    _ImageViewWidth = ImageViewWidth;
}

#pragma mark --- action

#pragma mark --- other

- (void)setUpChildView {
    [self addSubview:self.myImageView];
    [self addSubview:self.myLabel];
}

@end
