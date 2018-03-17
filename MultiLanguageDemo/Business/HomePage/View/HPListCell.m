//
//  HPListCell.m
//  MultiLanguageDemo
//
//  Created by 朱松泽 on 2018/3/16.
//  Copyright © 2018年 朱松泽. All rights reserved.
//

#import "HPListCell.h"
#define ImgWidth (SCREEN_WIDTH/3)
#define ImgHeight (ImgWidth/16*9)

@interface HPListCell()
@property (nonatomic, strong) UIView *line;
@end

@implementation HPListCell

- (instancetype)init {
    if (self = [super init]) {
        [self setUpChildView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpChildView];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
         [self setUpChildView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.myImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(ImgHeight);
        make.width.mas_equalTo(ImgWidth);
        make.centerY.equalTo(self.contentView.mas_centerY).offset(0);
        make.left.equalTo(self.contentView.mas_left).offset(10);
    }];
    
    [self.topLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.myImageView.mas_top).offset(0);
        make.left.equalTo(self.myImageView.mas_right).offset(8);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.height.mas_equalTo(ImgHeight/3*2);
    }];
    
    [self.bottomLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topLab.mas_bottom).offset(0);
        make.left.equalTo(self.topLab.mas_left).offset(0);
        make.bottom.equalTo(self.myImageView.mas_bottom).offset(0);
        make.right.equalTo(self.topLab.mas_right).offset(0);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.equalTo(self.contentView.mas_left).offset(0);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
        make.right.equalTo(self.contentView.mas_right).offset(0);
    }];
    
}

#pragma mark --- lazy load
- (UIImageView *)myImageView {
    if (_myImageView == nil) {
        _myImageView = [[UIImageView alloc] init];
    }
    return _myImageView;
}

- (UILabel *)topLab {
    if (_topLab == nil) {
        _topLab = [[UILabel alloc] init];
        _topLab.textColor = WhiteColorSix;
        _topLab.font = FONT(16);
        _topLab.textAlignment = NSTextAlignmentLeft;
        _topLab.text = @"正在加载中";
        _topLab.numberOfLines = 0;
    }
    return _topLab;
}

- (UILabel *)bottomLab {
    if (_bottomLab == nil) {
        _bottomLab = [[UILabel alloc] init];
        
        _bottomLab.textColor = WhiteColorFour;
        _bottomLab.font = FONT(14);
        _bottomLab.textAlignment = NSTextAlignmentLeft;
        _bottomLab.numberOfLines = 0;
    }
    return _bottomLab;
}

- (UIView *)line {
    if (_line == nil) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = WhiteColorThree;
    }
    return _line;
}

#pragma mark --- action

#pragma mark --- other

- (void)setUpChildView {
    [self.contentView addSubview:self.myImageView];
    [self.contentView addSubview:self.topLab];
    [self.contentView addSubview:self.bottomLab];
    [self.contentView addSubview:self.line];
}

@end
