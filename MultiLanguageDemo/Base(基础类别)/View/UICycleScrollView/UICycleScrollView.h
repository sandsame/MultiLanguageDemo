//
//  UICycleScrollView.h
//  DlodloVR
//
//  Created by captain on 16/4/18.
//  Copyright (c) 2016年 dlodlo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UICycleScrollView;

@protocol UICycleScrollViewDelegate <NSObject>

@optional
-(NSInteger)numberOfPagesInCycleScrollView:(UICycleScrollView*)cycleScrollView;
-(UIView*)cycleScrollView:(UICycleScrollView*)cycleScrollView viewForPageAtIndexPath:(NSInteger)index;
-(void)cycleScrollView:(UICycleScrollView*)cycleScrollView didSelectedForPageAtIndex:(NSInteger)index;
-(void)cycleScrollView:(UICycleScrollView*)cycleScrollView currentSelectedPageAtIndex:(NSInteger)index andLastPassedView:(nullable UIView*)lastPassedView;
-(void)cycleScrollView:(UICycleScrollView*)cycleScrollView prepareForReusedView:(nullable UIView*)reusedView;
@end

@interface UICycleScrollView : UIView

@property (nonatomic, weak) id <UICycleScrollViewDelegate> delegate;

@property (nonatomic, assign) NSInteger numberOfPages;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, assign) CGFloat pageSpace;

//如果开启了自动滚动的效果，在关闭时需要调用autoScroll ＝ NO,默认为NO
@property (nonatomic, assign) BOOL autoScroll;
@property (nonatomic, assign) CGFloat scrollTimeInterval;

//默认是YES
@property (nonatomic, assign) BOOL cycleScroll;

//默认是YES
@property (nonatomic, assign) BOOL showPageControl;

-(instancetype)initWithFrame:(CGRect)frame andSpecialScrollView:(UIScrollView*)scrollView;

//立即开启或者关闭定时器
-(void)startAutoCycleScroll:(BOOL)autoCycleScroll;

-(void)reloadData;

-(void)setStartPageIndex:(NSInteger)startPageIndex;
@end
