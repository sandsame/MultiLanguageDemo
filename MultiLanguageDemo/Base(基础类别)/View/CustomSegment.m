//
//  CustomSegment.m
//  易打分
//
//  Created by 朱松泽 on 2017/5/18.
//  Copyright © 2017年 yuan. All rights reserved.
//

#import "CustomSegment.h"
#define BottomSelectedLineHeight 2
@interface CustomSegment ()

@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) NSMutableArray *lineArray;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIView *defaultLine;

@end


@implementation CustomSegment
- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray {

    if (self = [super initWithFrame:frame]) {
        
        CGFloat buttonWidth = frame.size.width/titleArray.count;
        CGFloat buttonHeight = frame.size.height;
        
        self.line = [[UIView alloc] initWithFrame:CGRectMake(buttonWidth/4, buttonHeight-BottomSelectedLineHeight, buttonWidth/2, BottomSelectedLineHeight)];
        self.line.backgroundColor = self.bottomLineColor;
        
        for (int i = 0; i < titleArray.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(i*(buttonWidth), 0, buttonWidth, buttonHeight);
            button.titleLabel.font = self.itemFont;
            [button setTitleColor:self.itemTextDefaultColor forState:UIControlStateNormal];
            [button setTitleColor:self.itemTextSelectedColor forState:UIControlStateSelected];
            [button setBackgroundColor:self.itemBackGroundColor];
            if (i==0) {
                button.selected = YES;
            }
            button.tag = 100+i;
            [button setTitle:titleArray[i] forState:0];
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.buttonArray addObject:button];
            [self addSubview:button];
            
            // 按钮间加条短分割线
            UIView *segLine = [[UIView alloc] initWithFrame:CGRectMake((i+1)*(buttonWidth)-1, buttonHeight/4, 1, buttonHeight/2)];
            segLine.backgroundColor = self.seperatorLineColor;
            [self.lineArray addObject:segLine];
            [self addSubview:segLine];
            
        }
        [self addSubview:self.defaultLine];
        [self addSubview:self.line];
        
    }

    return self;

}

- (void)layoutSubviews {

    [super layoutSubviews];

    // 修改用户自定义的属性
    self.line.backgroundColor = self.bottomLineColor;
    self.defaultLine.backgroundColor = self.defauleLineColor;
    for (UIButton *button in self.buttonArray) {
        
        button.titleLabel.font = self.itemFont;
        [button setTitleColor:self.itemTextDefaultColor forState:UIControlStateNormal];
        [button setTitleColor:self.itemTextSelectedColor forState:UIControlStateSelected];
        [button setBackgroundColor:self.itemBackGroundColor];
        
    }
    
    for (UIView *segLine in self.lineArray) {
        segLine.backgroundColor = self.seperatorLineColor;
    }
    
    [self.defaultLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.height.mas_equalTo(1);
    }];
    
}



#pragma mark --- action
- (void)buttonAction:(UIButton *)sender {

    for (UIButton *button in self.buttonArray) {
        button.selected = NO;
    }
    sender.selected = YES;
    
    
    [UIView animateWithDuration:0.3 animations:^{
        self.line.frame = CGRectMake(sender.frame.origin.x+(sender.frame.size.width)/4, sender.frame.size.height-BottomSelectedLineHeight, sender.frame.size.width/2, BottomSelectedLineHeight);
    } completion:^(BOOL finished) {
        
    }];
    
    if ([self.delegate respondsToSelector:@selector(customSegmentSelectedIndex:)]) {
        [self.delegate customSegmentSelectedIndex:sender.tag-100];
    }
    

}

- (void)setSelectedIndex:(NSInteger)selectedIndex {

    // 先进行index合法性判断，避免数组越界
    
    if (selectedIndex+1>self.buttonArray.count) {
        NSLog(@"传过来的index有导致数组越界的危险");
        return;
    }
    
    for (UIButton *button in self.buttonArray) {
        button.selected = NO;
    }
    
    UIButton *button = self.buttonArray[selectedIndex];
    button.selected = YES;
    
    
    [UIView animateWithDuration:0.3 animations:^{
        self.line.frame = CGRectMake(button.frame.origin.x+(button.frame.size.width)/4, button.frame.size.height-BottomSelectedLineHeight, button.frame.size.width/2, BottomSelectedLineHeight);
    } completion:^(BOOL finished) {
        
    }];

}

#pragma mark --- lazy load

- (NSMutableArray *)buttonArray {
    
    if (_buttonArray == nil) {
        _buttonArray = [NSMutableArray arrayWithCapacity:3];
    }
    
    return _buttonArray;
}

- (NSMutableArray *)lineArray {
    if (_lineArray == nil) {
        _lineArray = [NSMutableArray arrayWithCapacity:3];
    }
    return _lineArray;
}

- (UIColor *)bottomLineColor {

    if (_bottomLineColor == nil) {
        _bottomLineColor = [UIColor whiteColor];
    }

    return _bottomLineColor;
}

- (UIFont *)itemFont {

    if (_itemFont == nil) {
        _itemFont = [UIFont systemFontOfSize:16];
    }
    
    return _itemFont;
}

- (UIColor *)itemTextDefaultColor {

    if (_itemTextDefaultColor == nil) {
        _itemTextDefaultColor = [UIColor grayColor];
    }
    
    return _itemTextDefaultColor;
}

- (UIColor *)itemTextSelectedColor {

    if (_itemTextSelectedColor == nil) {
        _itemTextSelectedColor = [UIColor blueColor];
    }
    
    return _itemTextSelectedColor;
}

-(UIColor *)itemBackGroundColor {
    
    if (_itemBackGroundColor == nil) {
        _itemBackGroundColor = MainColor;
    }
    
    return _itemBackGroundColor;
}

- (UIView *)defaultLine {
    if (_defaultLine == nil) {
        _defaultLine = [[UIView alloc] init];
        _defaultLine.backgroundColor = self.defauleLineColor;
    }
    return _defaultLine;
}

- (UIColor *)defauleLineColor {
    if (_defauleLineColor == nil) {
        _defauleLineColor = WhiteColorOne;
    }
    return _defauleLineColor;
}

- (UIColor *)seperatorLineColor {
    if (_seperatorLineColor == nil) {
        _seperatorLineColor = WhiteColorThree;
    }
    return _seperatorLineColor;
}

@end
