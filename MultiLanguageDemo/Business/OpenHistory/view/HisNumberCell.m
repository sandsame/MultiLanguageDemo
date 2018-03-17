//
//  HisNumberCell.m
//  MultiLanguageDemo
//
//  Created by 朱松泽 on 2018/3/17.
//  Copyright © 2018年 朱松泽. All rights reserved.
//

#import "HisNumberCell.h"
#define Space 6
#define CollectionCellWidth ((SCREEN_WIDTH - (9* Space)-70)/8)
@implementation HisNumberCell
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

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.contentView);
    }];
}

#pragma mark --- lazy load
- (UILabel *)numberLab {
    if (_numberLab == nil) {
        _numberLab = [[UILabel alloc] init];
        _numberLab.textColor = WhiteColorOne;
        _numberLab.textAlignment = NSTextAlignmentCenter;
        _numberLab.backgroundColor = RedSpecialColor;
        _numberLab.font = FONT(16);
        _numberLab.clipsToBounds = YES;
        _numberLab.layer.cornerRadius = CollectionCellWidth/2;
    }
    return _numberLab;
}

#pragma mark --- action

#pragma mark --- other
- (void)setUpChildView {
    [self.contentView addSubview:self.numberLab];
}

@end
