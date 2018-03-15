//
//  UIImageBrowserView.m
//  UICycleScrollViewDemo
//
//  Created by captain on 17/1/8.
//  Copyright © 2017年 yzh. All rights reserved.
//

#import "UIImageBrowserView.h"
#import "UICycleScrollView.h"
#import "UIZoomScrollViewCell.h"
#import "UIView+UIGestureRecognizer.h"

//static const CGFloat SCROLLVIEW_PANGESTURE_MIN_SHIFT_OFFSET_Y = 100;
static const CGFloat SCROLLVIEW_PANGESTURE_SHIFT_OFFSET_CHANGE_RATIO = 500;
static const CGFloat SCROLLVIEW_PANGESTURE_MIN_SCALE_RATIO_REMORE_FROM_SUPER_VIEW = 0.55;

/*
 UIImageInfo
 */
@implementation UIImageInfo

-(instancetype)initWithImage:(UIImage *)image imageSize:(CGSize)imageSize
{
    self = [super init];
    if (self) {
        _image = image;
        if (IS_AVAILABLE_CGSIZE(imageSize)) {
            _imageSize = imageSize;
        }
        else
        {
            _imageSize = image.size;
            if (_imageSize.height == 0 || _imageSize.width == 0) {
                _imageSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT * 0.4);
            }
        }
    }
    return self;
}

@end

/*
 UIImageBrowserView
 */
@interface UIImageBrowserView () <UIScrollViewDelegate,UICycleScrollViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UICycleScrollView *cycleScrollView;

@property (nonatomic, strong) NSMutableSet *reuseScrollViews;

@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation UIImageBrowserView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initDefaultData];
        [self initCycleScrollViewWithUIScrollView:nil];
    }
    return self;
}

-(void)initDefaultData
{
    _pageSpace = 20.0;
    _autoScroll = NO;
    _cycleScroll = NO;
    _minScale = 0.1;
    _maxScale = 2.0;
    _currentIndex = 0;
    _autoFullScale = YES;
    _showPageControl = YES;
    _panScaleChangeRatioRemove = SCROLLVIEW_PANGESTURE_MIN_SCALE_RATIO_REMORE_FROM_SUPER_VIEW;
}

-(void)initCycleScrollViewWithUIScrollView:(UIScrollView*)scrollView
{
    if (scrollView == nil) {
        scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _cycleScrollView = [[UICycleScrollView alloc] initWithFrame:self.bounds andSpecialScrollView:scrollView];
    }
    else
    {
        _cycleScrollView = [[UICycleScrollView alloc] initWithFrame:self.bounds andSpecialScrollView:scrollView];

    }
    _cycleScrollView.delegate = self;
    _cycleScrollView.pageSpace = _pageSpace;
    _cycleScrollView.autoScroll = _autoScroll;
    _cycleScrollView.scrollTimeInterval = 5.0;
    _cycleScrollView.cycleScroll = _cycleScroll;
    _cycleScrollView.showPageControl = _showPageControl;
    
    scrollView.bounces =YES;
    [self addSubview:_cycleScrollView];
}

-(instancetype)initWithFrame:(CGRect)frame andSpecialScrollView:(UIScrollView *)scrollView
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initDefaultData];
        [self initCycleScrollViewWithUIScrollView:scrollView];
    }
    return self;
}

-(NSMutableSet*)reuseScrollViews
{
    if (_reuseScrollViews == nil) {
        _reuseScrollViews = [[NSMutableSet alloc] init];
    }
    return _reuseScrollViews;
}

-(void)setPageSpace:(CGFloat)pageSpace
{
    _pageSpace = pageSpace;
    self.cycleScrollView.pageSpace = pageSpace;
}

-(void)setAutoScroll:(BOOL)autoScroll
{
    _autoScroll = autoScroll;
    self.cycleScrollView.autoScroll =  autoScroll;
}

-(void)setCycleScroll:(BOOL)cycleScroll
{
    _cycleScroll = cycleScroll;
    self.cycleScrollView.cycleScroll = cycleScroll;
}

-(UIScrollView*)dequeueReusedScrollView
{
    UIZoomScrollViewCell *scrollView = [self.reuseScrollViews anyObject];
    if (scrollView) {
        [self.reuseScrollViews removeObject:scrollView];
    }
    else
    {
        scrollView = [[UIZoomScrollViewCell alloc] initWithFrame:self.cycleScrollView.bounds];
        //增加滑动操作
//        [scrollView.panGestureRecognizer addTarget:self action:@selector(panAction:)];
        //自定义panGestureRecognizer
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        panGesture.delegate = self;
        panGesture.minimumNumberOfTouches = 1;
        panGesture.maximumNumberOfTouches = 1;
        [scrollView addGestureRecognizer:panGesture];
        
        //增加单击操作
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleAction:)];
        //增加双击操作
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleAction:)];
        doubleTap.delegate = self;
        doubleTap.numberOfTapsRequired = 2;
        [singleTap requireGestureRecognizerToFail:doubleTap];
        [scrollView addGestureRecognizer:doubleTap];
        [scrollView addGestureRecognizer:singleTap];
        
        //增加长按操作
//        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longAction:)];
//        [scrollView addGestureRecognizer:longGesture];
        
        //改用封装过的长按方法
        YZHIntervalGestureRecognizerActionOptionsInfo *actionOptions = [[YZHIntervalGestureRecognizerActionOptionsInfo alloc] init];
        actionOptions.actionOptions = YZHIntervalGestureRecognizerActionOptionsBeginEnd;
        
        //要用weakSelf，因为scrollview对self有保留，self对scrollview有在reuseScrollViews中有间接保留，所以这里必须要用weakSelf
        WEAK_SELF(weakSelf);
        [scrollView addLongPressGestureRecognizerBlock:^(UIGestureRecognizer *gesture) {
            UIZoomScrollViewCell *cell = (UIZoomScrollViewCell*)gesture.view;
            if (gesture.YZHState == YZHUIGestureRecognizerStateBegan) {
                cell.isInLongPressInteraction = YES;
            }
            [weakSelf.cycleScrollView startAutoCycleScroll:NO];
            if (gesture.YZHState == YZHUIGestureRecognizerStateBegan && [weakSelf.delegate respondsToSelector:@selector(imageBrowserView:longPressPageAtIndex:)]) {
                [weakSelf.delegate imageBrowserView:weakSelf longPressPageAtIndex:weakSelf.currentIndex];
            }
            if (gesture.YZHState == YZHUIGestureRecognizerStateEnded) {
                cell.isInLongPressInteraction = NO;
            }
            [weakSelf.cycleScrollView startAutoCycleScroll:weakSelf.autoScroll];
        } actionOptionsInfo:actionOptions];
    }
//    scrollView.delegate = nil;
    [scrollView resetInitialState];
    scrollView.autoFullScale = self.autoFullScale;
    scrollView.minZoomScale = self.minScale;
    scrollView.maxZoomScale = self.maxScale;
    
    [scrollView.pinchGestureRecognizer removeTarget:self action:@selector(pinchAction:)];
    [scrollView.pinchGestureRecognizer addTarget:self action:@selector(pinchAction:)];
    
    return scrollView;
}

#pragma mark UICycleScrollViewDelegate
-(NSInteger)numberOfPagesInCycleScrollView:(UICycleScrollView *)cycleScrollView
{
    if ([self.delegate respondsToSelector:@selector(numberOfPagesInImageBrowserView:)]) {
        return [self.delegate numberOfPagesInImageBrowserView:self];
    }
    return 0;
}

-(UIView*)cycleScrollView:(UICycleScrollView *)cycleScrollView viewForPageAtIndexPath:(NSInteger)index
{
//    NSLog(@"index===========%ld",index);
    UIZoomScrollViewCell *scrollView = (UIZoomScrollViewCell*)[self dequeueReusedScrollView];

    if ([self.delegate respondsToSelector:@selector(imageBrowserView:viewForPageAtIndexPath:)]) {
        UIView *subView = nil;
        subView = [self.delegate imageBrowserView:self viewForPageAtIndexPath:index];
        
        if ([subView isKindOfClass:[UIImageView class]]) {
            UIImageView *imageView = (UIImageView*)subView;
            if (imageView.contentMode != UIViewContentModeScaleAspectFit) {
                imageView.contentMode = UIViewContentModeScaleAspectFit;
            }
        }
        scrollView.zoomImageView = subView;
        scrollView.delegate = self;
        return scrollView;
    }
    else if ([self.delegate respondsToSelector:@selector(imageBrowserView:zoomViewCell:atIndexPath:showZoomImageView:)])
    {
        [self.delegate imageBrowserView:self zoomViewCell:scrollView atIndexPath:index showZoomImageView:^UIZoomScrollViewCell *(UIImageInfo *imageInfo, UIImageViewContentType normalType, UIImageViewContentType selectedType) {
            if (imageInfo == nil) {
                return scrollView;
            }
            
            if (normalType == UIImageViewContentTypeNull) {
                normalType = UIImageViewContentTypeScaleAspectFit;
            }
            
            if (selectedType == UIImageViewContentTypeNull) {
                selectedType = UIImageViewContentTypeScaleAspectFill;
            }
            
            CGSize imageSize = imageInfo.imageSize;
            CGFloat imageWHRatio = imageSize.width/imageSize.height;
            CGFloat x = 0;
            CGFloat y = 0;
            CGFloat width = scrollView.bounds.size.width;
            CGFloat height = scrollView.bounds.size.height;
            if (normalType == UIImageViewContentTypeScaleAspectFit) {
                height = width / imageWHRatio;
                if (height > scrollView.bounds.size.height) {
                    height = scrollView.bounds.size.height;
                    width = height * imageWHRatio;
                }
                
                x = (scrollView.bounds.size.width - width)/2;
                y = (scrollView.bounds.size.height - height)/2;
                x = MAX(0, x);
                y = MAX(0, y);
            }
            else if (normalType == UIImageViewContentTypeScaleAspectFill)
            {
                x = 0;
                y = 0;
                height = width / imageWHRatio;
                if (height < scrollView.bounds.size.height) {
                    height = scrollView.bounds.size.height;
                    width = height * imageWHRatio;
                }
            }
            else if (normalType == UIImageViewContentTypeActualFill)
            {
                width = imageSize.width;//scrollView.bounds.size.width;
                height = imageSize.height;//scrollView.bounds.size.height;
                
                x = (scrollView.bounds.size.width - width)/2;
                y = (scrollView.bounds.size.height - height)/2;
                x = MAX(0, x);
                y = MAX(0, y);
            }
            CGRect frame = CGRectMake(x, y, width, height);
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.image = imageInfo.image;
            
            CGFloat maxZoomScale = scrollView.maxZoomScale;
            CGFloat minZoomScale = scrollView.minZoomScale;
            
            CGFloat selectWidth = scrollView.bounds.size.width;
            CGFloat selectHeight = scrollView.bounds.size.height;
            //双击时处于最小适合屏幕
            if (selectedType == UIImageViewContentTypeScaleAspectFit) {
                selectWidth = scrollView.bounds.size.width;
                selectHeight = selectWidth / imageWHRatio;
                if (selectHeight > scrollView.bounds.size.height) {
                    selectHeight = scrollView.bounds.size.height;
                    selectWidth = selectHeight * imageWHRatio;
                }
            }
            //双击时处于最大适合屏幕
            else if (selectedType == UIImageViewContentTypeScaleAspectFill)
            {
                selectWidth = scrollView.bounds.size.width;
                selectHeight = selectWidth/imageWHRatio;
                if (selectHeight < scrollView.bounds.size.height) {
                    selectHeight = scrollView.bounds.size.height;
                    selectWidth = selectHeight * imageWHRatio;
                }
            }
            //双击时处于原图显示
            else if (selectedType == UIImageViewContentTypeActualFill)
            {
                selectWidth = imageInfo.image.size.width;
                selectHeight = imageInfo.image.size.height;
            }
            CGFloat scale = selectWidth/width;//width/selectWidth;
            if (scale > 1.0) {
                //图片放大
                maxZoomScale = scale;
                minZoomScale = 1.0;
            }
            else
            {
                //图片缩小
                maxZoomScale = 1.0;
                minZoomScale = scale;
            }
            scrollView.autoFullScale = NO;
            scrollView.maxZoomScale = maxZoomScale;
            scrollView.minZoomScale = minZoomScale;
            scrollView.zoomImageView = imageView;
            //这里没有对block进行保留，虽然block对self有保留，但是反之没有
            scrollView.delegate = self;
            return scrollView;
        }];
        return scrollView;
    }
    return nil;
}

-(void)cycleScrollView:(UICycleScrollView*)cycleScrollView didSelectedForPageAtIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(imageBrowserView:didSelectedForPageAtIndex:)]) {
        [self.delegate imageBrowserView:self didSelectedForPageAtIndex:index];
    }
}

-(void)cycleScrollView:(UICycleScrollView *)cycleScrollView currentSelectedPageAtIndex:(NSInteger)index andLastPassedView:(nullable UIView *)lastPassedView
{
    _currentIndex = index;
//    NSLog(@"currentSelectedPageAtIndex=%ld",index);
    
    if (lastPassedView != nil) {
        UIZoomScrollViewCell *scrollView = (UIZoomScrollViewCell*)lastPassedView;
        [self resetScrollViewToInitialState:scrollView animated:NO];
    }
    
    if ([self.delegate respondsToSelector:@selector(imageBrowserView:currentSelectedPageAtIndex:)]) {
        [self.delegate imageBrowserView:self currentSelectedPageAtIndex:index];
    }
}

-(void)cycleScrollView:(UICycleScrollView *)cycleScrollView prepareForReusedView:(UIView *)reusedView
{
    [self scrollViewPrepareReuseForView:reusedView];
}
#pragma mark UICycleScrollViewDelegate end


-(void)resetScrollView:(UIZoomScrollViewCell*)scrollViewCell withScale:(CGFloat)scale zoomScale:(BOOL)zoomScale zoomScaleCompletionBlock:(void(^)())completionBlock
{
    if (scrollViewCell == nil) {
        return;
    }
    
    UIView *zoomView = scrollViewCell.zoomImageView;
    
//    zoomView.backgroundColor = PURPLE_COLOR;
    
    CGRect cycleScrollViewRect = scrollViewCell.bounds;
    
    //新修改点，20170214
    if (zoomScale) {
        scale = MAX(scrollViewCell.minZoomScale, scale);
        scale = MIN(scrollViewCell.maxZoomScale, scale);
    }
    
    CGPoint anchorPt = scrollViewCell.zoomImageView.layer.anchorPoint;

    CGFloat contentW = scrollViewCell.zoomImageViewBounds.size.width * scale;
    CGFloat contentH = scrollViewCell.zoomImageViewBounds.size.height * scale;
    CGPoint centerPoint = CGPointMake(contentW * anchorPt.x, contentH * anchorPt.y);
    if (contentW < cycleScrollViewRect.size.width) {
        contentW = cycleScrollViewRect.size.width;
        centerPoint.x = contentW * 0.5 + scrollViewCell.zoomImageViewBounds.size.width * (anchorPt.x - 0.5);
    }
    if (contentH < cycleScrollViewRect.size.height) {
        contentH = cycleScrollViewRect.size.height;
        centerPoint.y = contentH * 0.5 + scrollViewCell.zoomImageViewBounds.size.height * (anchorPt.y - 0.5);
    }
    
    CGFloat offsetX = (contentW - cycleScrollViewRect.size.width) * anchorPt.x;
    CGFloat offsetY = (contentH - cycleScrollViewRect.size.height) * anchorPt.y;
    
//    NSLog(@"(%f,%f),scale=%f,contentW=%f,contentH=%f",scrollViewCell.zoomImageViewBounds.size.width,scrollViewCell.zoomImageViewBounds.size.height,scale,contentW,contentH);
    if (zoomScale) {
        [UIView animateWithDuration:0.5 animations:^{
            scrollViewCell.zoomScale = scale;
            zoomView.center = centerPoint;//CGPointMake(contentW * anchorPt.x, contentH * anchorPt.y);
            scrollViewCell.scrollContentSize = CGSizeMake(contentW, contentH);
            scrollViewCell.contentOffset = CGPointMake(offsetX, offsetY);
        } completion:^(BOOL finished) {
            if (completionBlock) {
                completionBlock();
            }
        }];
    }
    else
    {
        zoomView.center = centerPoint;//CGPointMake(contentW * anchorPt.x, contentH * anchorPt.y);
        scrollViewCell.scrollContentSize = CGSizeMake(contentW, contentH);
        //在这里保存zoomScale，当pinch事件结束后达到最大值时，如果进行双击时，此时应该进行缩小操作，如果不保存，此时的currentScale为1.0，会进行放大操作（以前就是最大的放大效果，再放大时没法表现），在第二次双击时才有表现。所以这里进行保存
        [scrollViewCell resetCurrentZoomScale:scale];
    }
}

-(void)resetScrollViewToInitialState:(UIZoomScrollViewCell*)scrollViewCell animated:(BOOL)animated
{
    if (scrollViewCell == nil) {
        return;
    }
    scrollViewCell.zoomImageView.layer.anchorPoint = CGPointMake(0.5,0.5);
    [self resetScrollView:scrollViewCell withScale:1.0 zoomScale:NO zoomScaleCompletionBlock:nil];
    scrollViewCell.zoomImageView.frame = scrollViewCell.zoomImageViewFrame;
    scrollViewCell.contentOffset = CGPointZero;
}

-(void)resetScrollViewWithGestureRecognizer:(UIGestureRecognizer*)gestureRecognizer andScale:(CGFloat)scale zoomScale:(BOOL)zoomScale zoomScaleCompletionBlock:(void(^)())completionBlock
{
    BOOL isPinchGesture = NO;
    BOOL isAdjustFrame = NO;

    UIZoomScrollViewCell *scrollView = (UIZoomScrollViewCell*)gestureRecognizer.view;
    UIView *zoomView = scrollView.zoomImageView;
    
    if ([gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]]) {
        UIPinchGestureRecognizer *pinch = (UIPinchGestureRecognizer*)gestureRecognizer;
        scale = pinch.scale;
        CGFloat adjustScale = scale;
        if (scrollView.zoomImageViewBounds.size.width != 0) {
            adjustScale = zoomView.frame.size.width/scrollView.zoomImageViewBounds.size.width;
        }
        else if (scrollView.zoomImageViewBounds.size.height != 0)
        {
            adjustScale = zoomView.frame.size.height/scrollView.zoomImageViewBounds.size.height;
        }
        if (fabs(adjustScale - scale) > 0.001) {
            NSLog(@"scale=%f,adjustScale=%f",scale,adjustScale);
            scale = adjustScale;
            isAdjustFrame = YES;
        }
        zoomScale = NO;
        isPinchGesture = YES;
    }
    [self resetScrollView:scrollView withScale:scale zoomScale:zoomScale zoomScaleCompletionBlock:completionBlock];
    if (isPinchGesture && isAdjustFrame && scale <= 1.0 && (gestureRecognizer.state == UIGestureRecognizerStateCancelled || gestureRecognizer.state == UIGestureRecognizerStateEnded)) {
        NSLog(@"adjustFrame------------------scale=%f",scale);
        scrollView.zoomImageView.frame = scrollView.zoomImageViewFrame;
    }
}

-(void)scrollViewPrepareReuseForView:(UIView*)scrollView
{
    if (scrollView == nil) {
        return;
    }
    [scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.reuseScrollViews addObject:scrollView];
    [scrollView removeFromSuperview];
}

-(CGFloat)getWillBecomeScaleForScrollView:(UIZoomScrollViewCell*)scrollViewCell
{
    NSLog(@"maxZoomScale=%f,currentScale=%f",scrollViewCell.maxZoomScale,scrollViewCell.currentZoomScale);
    if (scrollViewCell.maxZoomScale - scrollViewCell.currentZoomScale < 0.001) {
        return scrollViewCell.minZoomScale;
    } else {
        return scrollViewCell.maxZoomScale;
    }
}

-(void)singleAction:(UITapGestureRecognizer*)sender
{
    UIZoomScrollViewCell *cell = (UIZoomScrollViewCell*)sender.view;
    
    cell.isInSingleInteraction = YES;
    
    [self.cycleScrollView startAutoCycleScroll:NO];
    if ([self.delegate respondsToSelector:@selector(imageBrowserView:didSelectedForPageAtIndex:)]) {
        [self.delegate imageBrowserView:self didSelectedForPageAtIndex:self.currentIndex];
    }
    [self.cycleScrollView startAutoCycleScroll:_autoScroll];
    
    cell.isInSingleInteraction = NO;
}

-(void)doubleAction:(UITapGestureRecognizer*)sender
{
    UIZoomScrollViewCell *scrollViewCell = (UIZoomScrollViewCell*)sender.view;
    
    [self.cycleScrollView startAutoCycleScroll:NO];
    
    scrollViewCell.isInDoubleInteraction = YES;
    
    CGFloat scale = [self getWillBecomeScaleForScrollView:scrollViewCell];
    
    CGPoint anchorPt = CGPointMake(0.5, 0.5);

    if (scale == scrollViewCell.maxZoomScale && CGSizeEqualToSize(scrollViewCell.zoomImageViewBounds.size, CGSizeZero) == NO) {
        CGPoint point = [sender locationInView:scrollViewCell.zoomImageView];
    
        CGFloat ptX = MAX(0, point.x);
        ptX = MIN(ptX, scrollViewCell.zoomImageViewBounds.size.width);
        
        CGFloat ptY = MAX(0, point.y);
        ptY = MIN(ptY, scrollViewCell.zoomImageViewBounds.size.height);
        
        anchorPt = CGPointMake(ptX/scrollViewCell.zoomImageViewBounds.size.width, ptY/scrollViewCell.zoomImageViewBounds.size.height);
        const CGFloat xPrecision = 0.15;
        const CGFloat yPrecisioin = 0.15;
        if (anchorPt.x <= xPrecision) {
            anchorPt.x = 0;
        }
        else if (anchorPt.x >= 1 - xPrecision)
        {
            anchorPt.x = 1.0;
        }
        if (anchorPt.y <= yPrecisioin) {
            anchorPt.y = 0;
        }
        else if (anchorPt.y >= 1 - yPrecisioin)
        {
            anchorPt.y = 1.0;
        }
        
        if (scrollViewCell.zoomImageViewBounds.size.width * scale <= scrollViewCell.bounds.size.width) {
            anchorPt.x = 0.5;
        }
        if (scrollViewCell.zoomImageViewBounds.size.height * scale <= scrollViewCell.bounds.size.height) {
            anchorPt.y = 0.5;
        }
    }
//    NSLog(@"double-----------scale=%f,archnorPoint=(%f,%f)",scale,anchorPt.x,anchorPt.y);
    CGRect frame = scrollViewCell.zoomImageView.frame;
    scrollViewCell.zoomImageView.layer.anchorPoint = anchorPt;
    scrollViewCell.zoomImageView.frame = frame;
    WEAK_NSOBJ(scrollViewCell, weakCell);
    [self resetScrollViewWithGestureRecognizer:sender andScale:scale zoomScale:YES zoomScaleCompletionBlock:^{
        if (weakCell) {
            CGRect frame = weakCell.zoomImageView.frame;
            weakCell.zoomImageView.layer.anchorPoint = CGPointMake(0.5, 0.5);
            weakCell.zoomImageView.frame = frame;
            weakCell.isInDoubleInteraction = NO;
        }
    }];
    
    [self.cycleScrollView startAutoCycleScroll:_autoScroll];
}

-(void)resetScrollViewForPanGestureRecognizer:(UIPanGestureRecognizer*)sender animated:(BOOL)animated
{
    UIZoomScrollViewCell *scrollViewCell = (UIZoomScrollViewCell*)sender.view;
    UIView *zoomView = scrollViewCell.zoomImageView;
    
//    CGFloat contentWidth = MAX(scrollViewCell.zoomImageViewBounds.size.width, scrollViewCell.bounds.size.width);
//    CGFloat contentHeight = MAX(scrollViewCell.zoomImageViewBounds.size.height, scrollViewCell.bounds.size.height);
//    CGSize scrollContentSize = CGSizeMake(contentWidth, contentHeight);
    CGSize scrollContentSize = scrollViewCell.zoomImageViewBounds.size;
    
    if (animated) {
        [UIView animateWithDuration:0.5 animations:^{
//            zoomView.layer.anchorPoint = CGPointMake(0.5, 0.5);
            
            zoomView.bounds = scrollViewCell.zoomImageViewBounds;
            zoomView.frame = scrollViewCell.zoomImageViewFrame;
//            scrollViewCell.scrollContentSize = scrollViewCell.bounds.size;
            scrollViewCell.scrollContentSize = scrollContentSize;
            self.alpha = 1.0;
        } completion:^(BOOL finished) {
            zoomView.layer.anchorPoint = CGPointMake(0.5, 0.5);
            
            [self enablePinchGestureZoomScaleForScrollView:scrollViewCell zoomScale:YES];
            scrollViewCell.zoomScale = 1.0;
            zoomView.frame = scrollViewCell.zoomImageViewFrame;
//            scrollViewCell.scrollContentSize = scrollViewCell.bounds.size;
            scrollViewCell.scrollContentSize = scrollContentSize;
            scrollViewCell.contentOffset = CGPointZero;
            scrollViewCell.isInPanInteraction = NO;
        }];

    }
    else
    {
        zoomView.layer.anchorPoint = CGPointMake(0.5, 0.5);
        
        zoomView.bounds = scrollViewCell.zoomImageViewBounds;
        zoomView.frame = scrollViewCell.zoomImageViewFrame;
//        scrollViewCell.scrollContentSize = scrollViewCell.bounds.size;
        scrollViewCell.scrollContentSize = scrollContentSize;
        self.alpha = 1.0;
        
        [self enablePinchGestureZoomScaleForScrollView:scrollViewCell zoomScale:YES];
        scrollViewCell.zoomScale = 1.0;
        zoomView.frame = scrollViewCell.zoomImageViewFrame;
//        scrollViewCell.scrollContentSize = scrollViewCell.bounds.size;
        scrollViewCell.scrollContentSize = scrollContentSize;
        scrollViewCell.contentOffset = CGPointZero;
        scrollViewCell.isInPanInteraction = NO;
    }
}


-(BOOL)panGestureRecognizer:(UIPanGestureRecognizer*)panGestureRecognizer
{
    const CGFloat minShiftY = 20;
    const CGFloat maxShiftX = 16;
    const CGFloat maxShiftXYRatio = 0.8;
    
    UIZoomScrollViewCell *cell = (UIZoomScrollViewCell*)panGestureRecognizer.view;
    CGPoint shiftOffset = [panGestureRecognizer translationInView:cell];
    
    if (fabs(shiftOffset.y) < minShiftY) {
        return NO;
    }
    if (fabs(shiftOffset.x) > maxShiftX) {
        return NO;
    }
    
    CGFloat shiftXYRatio = fabs(shiftOffset.x/shiftOffset.y);
    if (shiftXYRatio > maxShiftXYRatio) {
        return NO;
    }
    
    if (cell.isInPinchInteraction) {
        return NO;
    }
    
    if (cell.isInPanInteraction) {
        return NO;
    }
    
    if (cell.zoomImageViewBounds.size.height > cell.bounds.size.height) {
//        CGFloat maxOffset = cell.zoomImageViewBounds.size.height - cell.bounds.size.height;
        if (cell.contentOffset.y <= 0 && shiftOffset.y > 0) {
            return YES;
        }
//        if (cell.contentOffset.y >= maxOffset && shiftOffset.y < 0) {
//            return YES;
//        }
        return NO;
    }
    
    if (cell.zoomScale > 1.0) {
        if (cell.contentOffset.y > 0) {
            return NO;
        }
//        return NO;
    }
    return YES;
}

-(void)enablePinchGestureZoomScaleForScrollView:(UIZoomScrollViewCell*)scrollViewCell zoomScale:(BOOL)zoomScale
{
    if (zoomScale) {
        scrollViewCell.delegate = self;
        scrollViewCell.pinchGestureRecognizer.enabled = YES;
    }
    else
    {
        scrollViewCell.delegate = nil;
        scrollViewCell.pinchGestureRecognizer.enabled = NO;
    }
}

-(void)panAction:(UIPanGestureRecognizer*)sender
{
    UIZoomScrollViewCell *scrollView = (UIZoomScrollViewCell*)sender.view;
    UIView *zoomView = scrollView.zoomImageView;
    CGPoint shiftOffset = [sender translationInView:scrollView];
    //这里是以contentsize为准的
    CGPoint locationPt = [sender locationInView:scrollView];
    if (sender.numberOfTouches > 0) {
        locationPt = [sender locationOfTouch:0 inView:scrollView];
    }
    
//    NSLog(@"shiftOffset=(%f,%f)",shiftOffset.x,shiftOffset.y);
//    NSLog(@"localPt=(%f,%f),currentZoomScale=%f",locationPt.x,locationPt.y,scrollView.currentZoomScale);
//    NSLog(@"scrollViewFrame=(%f,%f,%f,%f)",scrollView.frame.origin.x,scrollView.frame.origin.y,scrollView.frame.size.width,scrollView.frame.size.height);
//    NSLog(@"scrollContentSize=(%f,%f)",scrollView.scrollContentSize.width,scrollView.scrollContentSize.height);
    
    if (scrollView.isInPanInteraction == NO && [self panGestureRecognizer:sender] == NO) {
        return;
    }
    [self enablePinchGestureZoomScaleForScrollView:scrollView zoomScale:NO];
    if (scrollView.isInPanInteraction == NO) {
        NSLog(@"pan-------------------start---------------state=%ld",sender.state);
        [self.cycleScrollView startAutoCycleScroll:NO];
        CGPoint anchorPt = CGPointMake(locationPt.x/scrollView.scrollContentSize.width, locationPt.y/scrollView.scrollContentSize.height);
//        NSLog(@"anchorPt=(%f,%f)",anchorPt.x,anchorPt.y);
        zoomView.layer.anchorPoint = anchorPt;
    }
    scrollView.isInPanInteraction = YES;
    
    CGFloat scale = 1 - shiftOffset.y/SCROLLVIEW_PANGESTURE_SHIFT_OFFSET_CHANGE_RATIO;
    scale = MIN(scale, scrollView.maxZoomScale);
    scale = MAX(scale, self.minScale);
    
    zoomView.bounds = CGRectMake(0, 0, scrollView.zoomImageViewBounds.size.width * scale, scrollView.zoomImageViewBounds.size.height * scale);
    zoomView.center = locationPt;
    
    CGFloat alpha = 1 - shiftOffset.y / SCROLLVIEW_PANGESTURE_SHIFT_OFFSET_CHANGE_RATIO;
    alpha = MAX(0, alpha);
    alpha = MIN(1, alpha);
    self.alpha = alpha;
    
    if (sender.state == UIGestureRecognizerStateCancelled || sender.state == UIGestureRecognizerStateEnded) {
        CGFloat scaleRatio = fabs(1 - scale);
        if (scaleRatio >= self.panScaleChangeRatioRemove) {
            if ([self.delegate respondsToSelector:@selector(imageBrowserViewRemoveFromSuperView:)]) {
                [self.delegate imageBrowserViewRemoveFromSuperView:self];
            }
            else
            {
                [self removeFromSuperview];
            }
//            scrollView.isInPanInteraction = NO;
//            [self enablePinchGestureZoomScaleForScrollView:scrollView zoomScale:YES];
        }
        else
        {
            [self resetScrollViewForPanGestureRecognizer:sender animated:YES];
        }
        [self.cycleScrollView startAutoCycleScroll:_autoScroll];
    }
}

//pin最后有可能会导致zoomview的fame位置不对，不过不要紧的，可以通过pan来修复的。
-(void)pinchAction:(UIPinchGestureRecognizer*)sender
{
    UIZoomScrollViewCell *cell = (UIZoomScrollViewCell*)sender.view;
    
//    cell.backgroundColor = RED_COLOR;
    
//    NSLog(@"pinch-------------start------------state=%ld------scale=%f",sender.state,sender.scale);
    cell.zoomImageView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    if (sender.state == UIGestureRecognizerStateBegan || sender.state == UIGestureRecognizerStateChanged) {
        cell.isInPinchInteraction = YES;
        if (sender.state == UIGestureRecognizerStateBegan) {
            [self.cycleScrollView startAutoCycleScroll:NO];
        }
        
        [self resetScrollViewWithGestureRecognizer:sender andScale:0 zoomScale:NO zoomScaleCompletionBlock:nil];
    }
    else
    {
        [self resetScrollViewWithGestureRecognizer:sender andScale:0 zoomScale:NO zoomScaleCompletionBlock:nil];
        
        cell.isInPinchInteraction = NO;
        [self.cycleScrollView startAutoCycleScroll:_autoScroll];
    }
}

-(void)longAction:(UILongPressGestureRecognizer*)sender
{
    UIZoomScrollViewCell *cell = (UIZoomScrollViewCell*)sender.view;
    if (sender.state == UIGestureRecognizerStateBegan || sender.state == UIGestureRecognizerStateChanged) {
        cell.isInLongPressInteraction = YES;
    }
    [self.cycleScrollView startAutoCycleScroll:NO];
    if ([self.delegate respondsToSelector:@selector(imageBrowserView:longPressPageAtIndex:)]) {
        [self.delegate imageBrowserView:self longPressPageAtIndex:self.currentIndex];
    }
    if (sender.state == UIGestureRecognizerStateEnded) {
        cell.isInLongPressInteraction = NO;
    }
    [self.cycleScrollView startAutoCycleScroll:_autoScroll];
}

-(void)setShowPageControl:(BOOL)showPageControl
{
    _showPageControl = showPageControl;
    self.cycleScrollView.showPageControl = showPageControl;
}

-(void)reloadData
{
    [self.cycleScrollView reloadData];
}

-(void)setStartPageIndex:(NSInteger)startPageIndex
{
    [self.cycleScrollView setStartPageIndex:startPageIndex];
}

# pragma mark UIScrollViewDelegate
-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
#if 0
    UIZoomScrollViewCell *cell = (UIZoomScrollViewCell*)scrollView;
    return cell.zoomImageView;
#else
    for (UIView *v in scrollView.subviews){
        return v;
    }
    return nil;
#endif
}

#pragma mark UIGestureRecognizer
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    UIZoomScrollViewCell *cell = (UIZoomScrollViewCell*)gestureRecognizer.view;
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        UITapGestureRecognizer *tap = (UITapGestureRecognizer*)gestureRecognizer;
        NSInteger numOfTaps = tap.numberOfTapsRequired;
        if (numOfTaps == 1) {
            //这个是没用的
            return (cell.isInSingleInteraction == NO && cell.isInDoubleInteraction == NO && cell.isInPanInteraction == NO && cell.isInPinchInteraction == NO && cell.isInLongPressInteraction == NO);
        }
        else if (numOfTaps == 2)
        {
            return (cell.isInDoubleInteraction == NO && cell.isInSingleInteraction == NO && cell.isInPanInteraction == NO && cell.isInPinchInteraction == NO && cell.isInLongPressInteraction == NO);
        }
    }
    else if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]])
    {
        return (cell.isInSingleInteraction == NO && cell.isInDoubleInteraction == NO && cell.isInPinchInteraction == NO && cell.isInPanInteraction == NO && cell.isInLongPressInteraction == NO);
    }
    else if ([gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]])
    {
        //这个是没用的
        return (cell.isInPinchInteraction == NO && cell.isInSingleInteraction == NO && cell.isInDoubleInteraction == NO && cell.isInPanInteraction == NO && cell.isInLongPressInteraction == NO);
    }
    else if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]])
    {
        //这个是没用的
        return (cell.isInLongPressInteraction == NO && cell.isInSingleInteraction == NO && cell.isInDoubleInteraction == NO && cell.isInPanInteraction == NO && cell.isInPinchInteraction == NO);
    }
    return NO;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void)dealloc
{
    self.cycleScrollView.autoScroll = NO;
    [self.cycleScrollView removeFromSuperview];
    self.cycleScrollView = nil;
    [self.reuseScrollViews removeAllObjects];
    self.reuseScrollViews = nil;
//    NSLog(@"%s-----------",__FUNCTION__);
}

@end
