//
//  ZSZTabbar.m
//  sdxt
//
//  Created by 朱松泽 on 2017/11/13.
//  Copyright © 2017年 com.gdtech. All rights reserved.
//

#import "ZSZTabbar.h"
#define AddButtonMargin 20
#define AddButtonWidth 40
@interface ZSZTabbar()
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UILabel *addLabel;
@end
@implementation ZSZTabbar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpChildView];
    }
    
    return self;
}

- (instancetype)init {
    
    if (self = [super init]) {
        [self setUpChildView];
    }
    
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    // 去掉tabBar上的横线
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIImageView class]] && view.bounds.size.height <= 1) {
            UIImageView *line = (UIImageView *)view;
            line.hidden = YES;
        }
    }
    
    // 设置按钮的位置
//    self.addButton.centerX = self.centerX;
//    self.addButton.centerY = 50 * 0.5 - 1.5 * AddButtonMargin;
//
//    //设置“+”按钮的大小为图片的大小
////    self.addButton.size = CGSizeMake(self.addButton.currentBackgroundImage.size.width, self.addButton.currentBackgroundImage.size.height);
//    self.addButton.size = CGSizeMake(AddButtonWidth, AddButtonWidth);
    
    self.addButton.frame = CGRectMake((SCREEN_WIDTH-AddButtonWidth)/2, -14, AddButtonWidth+5, AddButtonWidth);
    
//    // 设置“添加”label的位置
//    self.addLabel.centerX = self.addButton.centerX;
//    self.addLabel.centerY = CGRectGetMaxY(self.addButton.frame) + 0.5 * AddButtonMargin + 0.5;
//    
//    self.addLabel.frame = CGRectMake((SCREEN_WIDTH-AddButtonWidth)/2, 50-21, AddButtonWidth, 21);
//    [self addSubview:self.addLabel];
//    
//    int btnIndex = 0;
//    // 系统自带的按钮类型是UITabBarButton，找出这些类型的按钮
//    // 然后重新排布位置，空出中间的位置
//    Class class = NSClassFromString(@"UITabBarButton");
//    for (UIView *btn in self.subviews) {
//        if ([btn isKindOfClass:class]) {
//            // 每一个按钮的宽度等于TabBar的三分之一
//            
//            btn.frame.size.width = self.frame.size.width/3;
//            [btn setFrame:CGRectMake(btn.frame.size.width * btnIndex, btn.frame.origin.y, btn.frame.size.width, btn.frame.size.width)];
//            btnIndex++;
//            // 如果索引是1（即“+”按钮），直接让索引+1
//            if (btnIndex == 1) {
//                btnIndex++;
//            }
//        }
//    }
//    //将“+”按钮放到视图层次最前面
//    [self bringSubviewToFront:self.addButton];
//    
//    self.topLine.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1);
}

- (void)setUpChildView {
    [self addSubview:self.addButton];
    [self addSubview:self.topLine];
}

#pragma mark --- lazy load
- (UIButton *)addButton {
    if (_addButton == nil) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton setImage:[UIImage imageNamed:@"发布"] forState:0];
        
        //添加响应事件
        [_addButton addTarget:self action:@selector(addBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

- (UILabel *)addLabel {
    if (_addLabel == nil) {
        _addLabel = [[UILabel alloc] init];
        _addLabel.text = @"发布";
        _addLabel.font = FONT(14);
        _addLabel.textColor = GRAY_COLOR;
        _addLabel.textAlignment = NSTextAlignmentCenter;
        [_addLabel sizeToFit];
    }
    return _addLabel;
}

- (UIView *)topLine {
    if (_topLine == nil) {
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = WhiteColorThree;
    }
    return _topLine;
}

#pragma mark --- action
- (void)addBtnDidClick:(UIButton *)sender {
    if ([self.zszDelegate respondsToSelector:@selector(addButtonClick:)]) {
        [self.zszDelegate addButtonClick:self];
    }
}

#pragma mark --- other
//重写hitTest方法，去监听"+"按钮和“添加”标签的点击，目的是为了让凸出的部分点击也有反应
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    //这一个判断是关键，不判断的话push到其他页面，点击“+”按钮的位置也是会有反应的，这样就不好了
    //self.isHidden == NO 说明当前页面是有TabBar的，那么肯定是在根控制器页面
    //在根控制器页面，那么我们就需要判断手指点击的位置是否在“+”按钮或“添加”标签上
    //是的话让“+”按钮自己处理点击事件，不是的话让系统去处理点击事件就可以了
    if (self.isHidden == NO) {
        //将当前TabBar的触摸点转换坐标系，转换到“+”按钮的身上，生成一个新的点
        CGPoint newA = [self convertPoint:point toView:self.addButton];
        //将当前TabBar的触摸点转换坐标系，转换到“添加”标签的身上，生成一个新的点
        CGPoint newL = [self convertPoint:point toView:self.addLabel];
        //判断如果这个新的点是在“+”按钮身上，那么处理点击事件最合适的view就是“+”按钮
        if ([self.addButton pointInside:newA withEvent:event]) {
            return self.addButton;
        }else if ([self.addLabel pointInside:newL withEvent:event]){
            //判断如果这个新的点是在“添加”标签身上，那么也让“+”按钮处理事件
            return self.addButton;
        }else{
            //如果点不在“+”按钮身上，直接让系统处理就可以了
            return [super hitTest:point withEvent:event];
        }
        
    }else{
        //TabBar隐藏了，那么说明已经push到其他的页面了，这个时候还是让系统去判断最合适的view处理就好了
        return [super hitTest:point withEvent:event];
    }
}

@end
