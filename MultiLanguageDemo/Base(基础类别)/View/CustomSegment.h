//
//  CustomSegment.h
//  易打分
//
//  Created by 朱松泽 on 2017/5/18.
//  Copyright © 2017年 yuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomSegmentDelegate <NSObject>

- (void)customSegmentSelectedIndex:(NSInteger)index;

@end

@interface CustomSegment : UIView
@property (nonatomic, weak) id<CustomSegmentDelegate>delegate;

@property (nonatomic, strong) UIColor *itemBackGroundColor;

@property (nonatomic, strong) UIColor *itemTextDefaultColor;
@property (nonatomic, strong) UIColor *itemTextSelectedColor;

@property (nonatomic, strong) UIFont *itemFont;

@property (nonatomic, strong) UIColor *bottomLineColor;
@property (nonatomic, strong) UIColor *defauleLineColor;

@property (nonatomic, strong) UIColor *seperatorLineColor;


- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray;
- (void)setSelectedIndex:(NSInteger)selectedIndex;
@end
