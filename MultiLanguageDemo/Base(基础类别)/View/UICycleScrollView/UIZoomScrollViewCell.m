//
//  UIZoomScrollViewCell.m
//  UICycleScrollViewDemo
//
//  Created by captain on 17/1/11.
//  Copyright © 2017年 yzh. All rights reserved.
//

#import "UIZoomScrollViewCell.h"

@interface UIZoomScrollViewCell ()
////当前的zoomScale,如果UIScrollView代理为空的话，那么zoomScale ＝ 1.0
//@property (nonatomic, assign, readonly) CGFloat currentZoomScale;
@end

@implementation UIZoomScrollViewCell

@synthesize minZoomScale = _minZoomScale;
@synthesize maxZoomScale = _maxZoomScale;
@synthesize scrollContentSize = _scrollContentSize;

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initDefaultData];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame zoomImageView:(UIView*)zoomImageView;
{
    self = [self initWithFrame:frame];
    if (self) {
        [self initDefaultData];
        self.zoomImageView = zoomImageView;
    }
    return self;
}

-(void)initDefaultData
{
    _minZoomScale = 0.1;
    _maxZoomScale = 2.0;
    _autoFullScale = YES;
    
    self.bounces = NO;
    
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.indicatorStyle = UIScrollViewIndicatorStyleBlack;
    
    [self resetScrollZoomScale];
    self.scrollContentSize = self.bounds.size;
}

-(void)resetScrollZoomScale
{
    self.zoomScale = 1.0;
    self.minimumZoomScale = self.minZoomScale;
    self.maximumZoomScale = self.maxZoomScale;
    _currentZoomScale = self.zoomScale;
}

-(void)resetInitialState
{
    [self initDefaultData];
}

//-(void)setContentSize:(CGSize)contentSize
//{
//    NSLog(@"contentSize=(%f,%f)",contentSize.width,contentSize.height);
//
//    super.contentSize = CGSizeMake(contentSize.width, contentSize.height+0.01);
////    CGFloat contentWidth = MAX(self.bounds.size.width, contentSize.width);
////    CGFloat contentHegith = MAX(self.bounds.size.height, contentSize.height)+0.01;
////    super.contentSize = CGSizeMake(contentWidth, contentHegith);
//}

-(void)setScrollContentSize:(CGSize)scrollContentSize
{
    CGFloat contentWidth = MAX(self.bounds.size.width, scrollContentSize.width);
    CGFloat contentHegith = MAX(self.bounds.size.height, scrollContentSize.height) + 0.01;
    _scrollContentSize = CGSizeMake(contentWidth, contentHegith);
    self.contentSize = _scrollContentSize;
}

-(CGSize)scrollContentSize
{
    return CGSizeMake(_scrollContentSize.width, _scrollContentSize.height-0.01);
}

-(void)setZoomImageView:(UIView *)zoomImageView
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _zoomImageView = zoomImageView;
    _zoomImageViewFrame = zoomImageView.frame;
    self.zoomImageViewBounds = zoomImageView.bounds;
    [self resetScrollZoomScale];
    [self addSubview:zoomImageView];
}

-(void)setZoomImageViewBounds:(CGRect)zoomImageViewBounds
{
    _zoomImageViewBounds = zoomImageViewBounds;
    CGFloat width = MAX(zoomImageViewBounds.size.width, self.bounds.size.width);
    CGFloat height = MAX(zoomImageViewBounds.size.height, self.bounds.size.height);
    self.scrollContentSize = CGSizeMake(width, height);
}

-(CGFloat)getAutoFullMaxZoomScale
{
    if (_zoomImageView == nil) {
        return _maxZoomScale;
    }
    if (_zoomImageViewBounds.size.width == 0 || _zoomImageViewBounds.size.height == 0) {
        return _maxZoomScale;
    }
    
    CGFloat wScale = self.bounds.size.width/_zoomImageViewBounds.size.width;
    CGFloat hScale = self.bounds.size.height/_zoomImageViewBounds.size.height;
    CGFloat scale = MAX(wScale, hScale);
    scale = MAX(scale, self.zoomScale);
    return scale;
}

-(CGFloat)getAutoFullMinZoomScale
{
    if (_zoomImageView == nil) {
        return _minZoomScale;
    }
    if (_zoomImageViewBounds.size.width == 0 || _zoomImageViewBounds.size.height == 0) {
        return _minZoomScale;
    }
    
    CGFloat wScale = self.bounds.size.width/_zoomImageViewBounds.size.width;
    CGFloat hScale = self.bounds.size.height/_zoomImageViewBounds.size.height;
    CGFloat scale = MIN(wScale, hScale);
    scale = MIN(scale, self.zoomScale);
    return scale;
}

-(CGFloat)maxZoomScale
{
    if (_autoFullScale) {
        return [self getAutoFullMaxZoomScale];
    }
    else
    {
        return _maxZoomScale;
    }
}

-(void)setMaxZoomScale:(CGFloat)maxZoomScale
{
    _maxZoomScale = maxZoomScale;
    self.maximumZoomScale = self.maxZoomScale;
}

-(CGFloat)minZoomScale
{
    if (_autoFullScale) {
        return [self getAutoFullMinZoomScale];
    }
    else
    {
        return _minZoomScale;
    }
}

-(void)setMinZoomScale:(CGFloat)minZoomScale
{
    _minZoomScale = minZoomScale;
    self.minimumZoomScale = self.minZoomScale;
}

-(void)resetCurrentZoomScale:(CGFloat)scale
{
    _currentZoomScale = scale;
}

#pragma mark overide

-(void)setZoomScale:(CGFloat)zoomScale
{
    _currentZoomScale = zoomScale;
    super.zoomScale = zoomScale;
}

@end
