//
//  UIZoomScrollViewCell.h
//  UICycleScrollViewDemo
//
//  Created by captain on 17/1/11.
//  Copyright © 2017年 yzh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIZoomScrollViewCell : UIScrollView

@property (nonatomic, strong) UIView *zoomImageView;

@property (nonatomic, assign, readonly) CGRect zoomImageViewBounds;

@property (nonatomic, assign, readonly) CGRect zoomImageViewFrame;
//默认0.1
@property (nonatomic, assign) CGFloat minZoomScale;
//默认2
@property (nonatomic, assign) CGFloat maxZoomScale;

//当前的zoomScale,如果UIScrollView代理为空的话，那么zoomScale ＝ 1.0
@property (nonatomic, assign, readonly) CGFloat currentZoomScale;

//默认为YES，YES表示图片按照最大比例缩放到全屏，NO表示按上面的minZoomScale,maxZoomScale进行缩放
@property (nonatomic, assign) BOOL autoFullScale;

//是否在双指捏合的状态
@property (nonatomic, assign) BOOL isInPinchInteraction;

//是否在拖拉状态
@property (nonatomic, assign) BOOL isInPanInteraction;

//是否在双击状态
@property (nonatomic, assign) BOOL isInDoubleInteraction;

//是否在单击状态
@property (nonatomic, assign) BOOL isInSingleInteraction;

//是否在长按状态
@property (nonatomic, assign) BOOL isInLongPressInteraction;

@property (nonatomic, assign) CGSize scrollContentSize;


-(instancetype)initWithFrame:(CGRect)frame zoomImageView:(UIView*)zoomImageView;

-(void)resetInitialState;
//把scrollView的contentSize设置为初始化时上面的默认值

-(void)resetCurrentZoomScale:(CGFloat)scale;
@end
