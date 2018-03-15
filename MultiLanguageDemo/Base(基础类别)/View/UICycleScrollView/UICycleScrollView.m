//
//  UICycleScrollView.m
//  yzh
//
//  Created by captain on 16/4/18.
//  Copyright (c) 2016年 dlodlo. All rights reserved.
//

#import "UICycleScrollView.h"

static const NSInteger CYCLE_PAGE_VIEW_COUNT = 3;
static const NSInteger SCROLLVIEW_SUBVIEW_TAG = 1234;

static const CGFloat scrollTimeInterval_s = 5.0;

typedef NS_ENUM(NSInteger, UIScrollViewSubViewTag)
{
    UIScrollViewLeftViewTag     = 1,
    UIScrollViewCenterViewTag   = 2,
    UIScrollViewRightViewTag    = 3,
};


@interface UICycleScrollView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) NSInteger currentSelectedPageIndex;

//@property (nonatomic, strong) NSMutableDictionary *subViewDict;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) CGPoint lastContentOffset;

@end

@implementation UICycleScrollView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initDefaultData];
        
        [self setUpChildViewWithFrame:frame andSpecialScrollView:nil];
    }
    return self;
}

-(void)initDefaultData
{
    _pageSpace = 0;
    _autoScroll = NO;
    _cycleScroll = YES;
    _currentSelectedPageIndex = -1;
    _showPageControl = YES;
    
    self.clipsToBounds = YES;
}

-(void)setUpChildViewWithFrame:(CGRect)frame andSpecialScrollView:(UIScrollView*)scrollView;
{
    CGRect scrollViewFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);

    self.scrollView = scrollView;
    self.scrollView.frame = scrollViewFrame;
    if (scrollView == nil) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:scrollViewFrame];
    }
    _scrollView.bounces =  NO;
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(frame.size.width * CYCLE_PAGE_VIEW_COUNT, frame.size.height);
    _scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
    _lastContentOffset = _scrollView.contentOffset;
    [self addSubview:_scrollView];
    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.pageIndicatorTintColor = LIGHT_GRAY_COLOR;//RAND_COLOR;
    _pageControl.currentPageIndicatorTintColor = WHITE_COLOR;//RAND_COLOR;
    [self addSubview:_pageControl];
    
    for (int i = 0; i < CYCLE_PAGE_VIEW_COUNT; ++i) {
        UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(i * self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height)];
        subView.clipsToBounds = YES;
        subView.tag = i + 1;
        subView.backgroundColor = CLEAR_COLOR;
        [_scrollView addSubview:subView];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
}

-(instancetype)initWithFrame:(CGRect)frame andSpecialScrollView:(UIScrollView*)scrollView
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initDefaultData];
        
        [self setUpChildViewWithFrame:frame andSpecialScrollView:scrollView];
    }
    return self;
}

-(void)resetUpChildView
{
    if (self.pageSpace <= 0) {
        return;
    }
    
    CGSize size = self.bounds.size;
    
    CGRect oldFrame = self.scrollView.frame;
    
    self.scrollView.frame = CGRectMake(-self.pageSpace/2.0, oldFrame.origin.y, size.width + self.pageSpace, oldFrame.size.height);
    
    self.scrollView.contentSize = CGSizeMake((size.width + self.pageSpace) * CYCLE_PAGE_VIEW_COUNT, size.height);
    self.scrollView.contentOffset = CGPointMake(size.width + self.pageSpace, 0);
    self.lastContentOffset = self.scrollView.contentOffset;
    for (int i = 0; i < CYCLE_PAGE_VIEW_COUNT; ++i) {
        UIView *subView = [self.scrollView viewWithTag:i + 1];
        subView.frame = CGRectMake(i * (size.width + self.pageSpace) + self.pageSpace/2, 0, size.width, size.height);
    }
}

-(void)tapAction:(UITapGestureRecognizer*)tap
{
    if (self.currentSelectedPageIndex >= 0 && [self.delegate respondsToSelector:@selector(cycleScrollView:didSelectedForPageAtIndex:)]) {
        [self.delegate cycleScrollView:self didSelectedForPageAtIndex:self.currentSelectedPageIndex];
    }
}

-(void)initPageControl:(NSInteger)numberOfPages
{
    CGSize size = [self.pageControl sizeForNumberOfPages:numberOfPages];
    self.pageControl.bounds = CGRectMake(0, 0, size.width, size.height);
    self.pageControl.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height - size.height/2);
    self.pageControl.numberOfPages = numberOfPages;
}

-(void)setShowPageControl:(BOOL)showPageControl
{
    _showPageControl = showPageControl;
    self.pageControl.hidden = TYPE_NOT(showPageControl);
}

-(void)addToScrollSubView:(UIView*)scrollSubView subView:(UIView*)subView
{
    if (scrollSubView == nil || subView == nil) {
        return;
    }
    [scrollSubView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    subView.tag = SCROLLVIEW_SUBVIEW_TAG;
    [scrollSubView addSubview:subView];
}

-(void)addToScrollSubViewWithTag:(UIScrollViewSubViewTag)tag subView:(UIView*)subView
{
    if (subView == nil) {
        return;
    }
    UIView *collectionView = [self.scrollView viewWithTag:tag];
    if (collectionView == nil) {
        return;
    }
    [self addToScrollSubView:collectionView subView:subView];
}

-(void)clearViewInScrollSubViewWithTag:(UIScrollViewSubViewTag)tag
{
    UIView *collectionView = [self.scrollView viewWithTag:tag];
//    UIView *reuseSubView = [[collectionView subviews] firstObject];
    UIView *reuseSubView = [collectionView viewWithTag:SCROLLVIEW_SUBVIEW_TAG];
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:prepareForReusedView:)]) {
        [self.delegate cycleScrollView:self prepareForReusedView:reuseSubView];
    }
    [reuseSubView removeFromSuperview];
    [collectionView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

-(void)clearScrollViewSubViewWithTag:(UIScrollViewSubViewTag)tag
{
    [self clearViewInScrollSubViewWithTag:tag];
    UIView *collectionView = [self.scrollView viewWithTag:tag];
    [collectionView removeFromSuperview];
}

-(void)clearAllViewInScrollSubView
{
    [self clearViewInScrollSubViewWithTag:UIScrollViewLeftViewTag];
    [self clearViewInScrollSubViewWithTag:UIScrollViewCenterViewTag];
    [self clearViewInScrollSubViewWithTag:UIScrollViewRightViewTag];
}

-(void)postCurrentPageIndex:(NSInteger)pageIndex andLastPassedViewWithScrollSubView:(UIView*)scrollSubView
{
    UIView *view = [scrollSubView viewWithTag:SCROLLVIEW_SUBVIEW_TAG];
    if (scrollSubView == nil) {
        view = nil;
    }
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:currentSelectedPageAtIndex:andLastPassedView:)]) {
        [self.delegate cycleScrollView:self currentSelectedPageAtIndex:self.currentSelectedPageIndex andLastPassedView:view];
    }
}

-(void)loadSubView
{
    [self clearAllViewInScrollSubView];
    if (self.numberOfPages > 0 && [self.delegate respondsToSelector:@selector(cycleScrollView:viewForPageAtIndexPath:)]) {
        if (self.numberOfPages > 1) {
            self.scrollView.scrollEnabled = YES;
            if (self.showPageControl) {
                self.pageControl.hidden = NO;
            }
            
            if (self.cycleScroll == NO) {
                if (self.numberOfPages < CYCLE_PAGE_VIEW_COUNT) {
                    
                    CGSize size = self.bounds.size;
                    self.scrollView.contentSize = CGSizeMake((size.width + self.pageSpace) * self.numberOfPages, size.height);
                    [self clearScrollViewSubViewWithTag:UIScrollViewRightViewTag];
                }
                self.scrollView.contentOffset = CGPointMake(0, 0);
                self.lastContentOffset = self.scrollView.contentOffset;
            }

            NSInteger numberOfPages = CYCLE_PAGE_VIEW_COUNT;
            if (self.cycleScroll == NO) {
                numberOfPages = MIN(self.numberOfPages, CYCLE_PAGE_VIEW_COUNT);
            }
            if (self.currentSelectedPageIndex <= 0) {
                NSInteger index = 0;
                for (int i = 0; i < numberOfPages; ++i) {
                    if (self.cycleScroll == NO) {
                        index = i;
                    }
                    else
                    {
                        index = (self.numberOfPages - 1 + i) % self.numberOfPages;
                    }
                    UIView *view = [self.delegate cycleScrollView:self viewForPageAtIndexPath:index];
                    [self addToScrollSubViewWithTag:i+1 subView:view];
                }
                index = 0;
                
                self.currentSelectedPageIndex = index;
                self.pageControl.currentPage = index;
            }
            else
            {
                if (self.cycleScroll) {
                    NSInteger index = self.currentSelectedPageIndex;
                    for (NSInteger i = 0; i < numberOfPages; ++i) {
                        index = index % self.numberOfPages;
                        UIView *view = [self.delegate cycleScrollView:self viewForPageAtIndexPath:index];
                        [self addToScrollSubViewWithTag:i + 1 subView:view];
                        ++index;
                    }
                    ++self.currentSelectedPageIndex;
                    self.scrollView.contentOffset = CGPointZero;
                    [self reloadSubView];
                }
                else
                {
                    if (self.currentSelectedPageIndex == 0) {
                        for (int i = 0; i < numberOfPages; ++i) {
                            UIView *view = [self.delegate cycleScrollView:self viewForPageAtIndexPath:i];
                            [self addToScrollSubViewWithTag:i+1 subView:view];
                        }
                    }
                    else if (self.currentSelectedPageIndex == self.numberOfPages - 1)
                    {
                        NSInteger cnt = numberOfPages;
                        for (NSInteger i = self.currentSelectedPageIndex; cnt > 0; --i) {
                            UIView *view = [self.delegate cycleScrollView:self viewForPageAtIndexPath:i];
                            [self addToScrollSubViewWithTag:cnt subView:view];
                            --cnt;
                        }
                        self.scrollView.contentOffset = CGPointMake((self.bounds.size.width + self.pageSpace)*(numberOfPages-1), 0);
                        self.lastContentOffset = self.scrollView.contentOffset;
                    }
                    else
                    {
                        NSInteger tag = UIScrollViewLeftViewTag;
                        for (NSInteger i = self.currentSelectedPageIndex-2; i >= 0 && i < self.numberOfPages && tag <= UIScrollViewRightViewTag; ++i) {
                            UIView *view = [self.delegate cycleScrollView:self viewForPageAtIndexPath:i];
                            [self addToScrollSubViewWithTag:tag subView:view];
                            ++tag;
                        }
                        --self.currentSelectedPageIndex;
                        self.scrollView.contentOffset = CGPointMake(self.bounds.size.width + self.pageSpace, 0);
                        [self reloadSubView];
                    }
                }
            }
        }
        else
        {
            self.scrollView.scrollEnabled = NO;
            self.pageControl.hidden = YES;
            
            NSInteger index = 0;
            UIView *view = [self.delegate cycleScrollView:self viewForPageAtIndexPath:index];
            [self addToScrollSubViewWithTag:UIScrollViewCenterViewTag subView:view];
            self.currentSelectedPageIndex = index;
        }
        [self postCurrentPageIndex:self.currentSelectedPageIndex andLastPassedViewWithScrollSubView:nil];
    }
}

-(void)reloadSubView
{
    if (self.numberOfPages <= 0) {
        return;
    }
    if (self.numberOfPages == 1) {
        self.scrollView.scrollEnabled = NO;
        self.pageControl.hidden = YES;
        
        NSInteger index = 0;
        [self clearAllViewInScrollSubView];
        UIView *subView = nil;
        if (subView == nil && [self.delegate respondsToSelector:@selector(cycleScrollView:viewForPageAtIndexPath:)]) {
            subView = [self.delegate cycleScrollView:self viewForPageAtIndexPath:index];
        }
        [self addToScrollSubViewWithTag:UIScrollViewCenterViewTag subView:subView];
        self.currentSelectedPageIndex = index;
        
        [self postCurrentPageIndex:self.currentSelectedPageIndex andLastPassedViewWithScrollSubView:nil];
        return;
    }
    self.scrollView.scrollEnabled = YES;
    if (self.showPageControl) {
        self.pageControl.hidden = NO;
    }
    
    CGPoint offset = self.scrollView.contentOffset;
    //往右滚动
    NSInteger lastSelectedPageIndex = self.currentSelectedPageIndex;
    NSInteger nextSelectedPageIndex = self.currentSelectedPageIndex;
    NSInteger scrollDirection = 0;
    NSInteger shiftPages = 1;
    if (offset.x > self.lastContentOffset.x) {
        //如果这里移动的太快
        CGFloat shiftLength = offset.x - self.lastContentOffset.x;
        shiftPages = shiftLength/self.bounds.size.width;
        NSLog(@"shiftPages=%ld",shiftPages);
        scrollDirection = 1;
        nextSelectedPageIndex = (self.currentSelectedPageIndex + shiftPages) % self.numberOfPages;
        if (!self.cycleScroll) {
            if (nextSelectedPageIndex < lastSelectedPageIndex) {
                NSInteger numberOfPages = MIN(self.numberOfPages, CYCLE_PAGE_VIEW_COUNT) - 1;
                self.scrollView.contentOffset = CGPointMake(numberOfPages * (self.bounds.size.width + self.pageSpace), 0);
                self.lastContentOffset = self.scrollView.contentOffset;
                return;
            }
        }
        
        self.currentSelectedPageIndex = nextSelectedPageIndex;
        UIView *centerView = [self.scrollView viewWithTag:UIScrollViewCenterViewTag];
        if (self.cycleScroll == NO && nextSelectedPageIndex == 1) {
            centerView = [self.scrollView viewWithTag:UIScrollViewLeftViewTag];
        }
        [self postCurrentPageIndex:self.currentSelectedPageIndex andLastPassedViewWithScrollSubView:centerView];
    }
    //往左滚动
    else if (offset.x < self.lastContentOffset.x)
    {
        CGFloat shiftLength = self.lastContentOffset.x - offset.x;
        shiftPages = shiftLength/self.bounds.size.width;
        scrollDirection = -1;
        nextSelectedPageIndex = (self.currentSelectedPageIndex - shiftPages + self.numberOfPages) % self.numberOfPages;
        if (!self.cycleScroll) {
            if (nextSelectedPageIndex > lastSelectedPageIndex) {
                self.scrollView.contentOffset = CGPointMake(0, 0);
                self.lastContentOffset = self.scrollView.contentOffset;
                return;
            }
        }
        self.currentSelectedPageIndex = nextSelectedPageIndex;
        
        UIView *centerView = [self.scrollView viewWithTag:UIScrollViewCenterViewTag];
        if (self.cycleScroll == NO && nextSelectedPageIndex == self.numberOfPages-2) {
            NSInteger numOfPages = MIN(self.numberOfPages, CYCLE_PAGE_VIEW_COUNT);
            centerView = [self.scrollView viewWithTag:numOfPages];
        }
        [self postCurrentPageIndex:self.currentSelectedPageIndex andLastPassedViewWithScrollSubView:centerView];
    }
    else
    {
        scrollDirection = 0;
        return;
    }
    
    shiftPages = 1;
    NSInteger leftIndex = (self.currentSelectedPageIndex - shiftPages + self.numberOfPages) % self.numberOfPages;
    NSInteger centerIndex = self.currentSelectedPageIndex;
    NSInteger rightIndex = (self.currentSelectedPageIndex + shiftPages)%self.numberOfPages;
    UIView *leftView = [self.scrollView viewWithTag:UIScrollViewLeftViewTag];
    UIView *centerView = [self.scrollView viewWithTag:UIScrollViewCenterViewTag];
    UIView *rightView = [self.scrollView viewWithTag:UIScrollViewRightViewTag];
    
    if (scrollDirection == 1) {
        if (self.cycleScroll == NO && (centerIndex == 1 || centerIndex == self.numberOfPages - 1))
        {
            if (centerIndex == 1) {
                //CenterView
                [self clearViewInScrollSubViewWithTag:UIScrollViewCenterViewTag];
                //这里的centerViewSubView取最新的。
//                UIView *centerViewSubView = [rightView.subviews firstObject];
                UIView *centerViewSubView = nil;
                if (centerViewSubView == nil) {
                    if ([self.delegate respondsToSelector:@selector(cycleScrollView:viewForPageAtIndexPath:)]) {
                        centerViewSubView = [self.delegate cycleScrollView:self viewForPageAtIndexPath:centerIndex];
                    }
                }
                else
                {
                    [centerViewSubView removeFromSuperview];
                }
                [self addToScrollSubView:centerView subView:centerViewSubView];
                
                //rightView
                [self clearViewInScrollSubViewWithTag:UIScrollViewRightViewTag];
                //这里的rightViewSubView取最新的。
                UIView *rightViewSubView = nil;
                if ([self.delegate respondsToSelector:@selector(cycleScrollView:viewForPageAtIndexPath:)]) {
                    rightViewSubView = [self.delegate cycleScrollView:self viewForPageAtIndexPath:rightIndex];
                }
                [self addToScrollSubView:rightView subView:rightViewSubView];
            }
            else
            {
                //rightView
                [self clearViewInScrollSubViewWithTag:UIScrollViewRightViewTag];
                 //这里的rightViewSubView取最新的。
                UIView *rightViewSubView = nil;
                if ([self.delegate respondsToSelector:@selector(cycleScrollView:viewForPageAtIndexPath:)]) {
                    rightViewSubView = [self.delegate cycleScrollView:self viewForPageAtIndexPath:centerIndex];
                }
                [self addToScrollSubView:rightView subView:rightViewSubView];
                
                NSInteger numberOfPages = MIN(self.numberOfPages, CYCLE_PAGE_VIEW_COUNT) - 1;
                self.scrollView.contentOffset = CGPointMake(numberOfPages * (self.bounds.size.width + self.pageSpace), 0);
                self.lastContentOffset = self.scrollView.contentOffset;
                self.currentSelectedPageIndex = nextSelectedPageIndex;
                self.pageControl.currentPage = self.currentSelectedPageIndex;
                
                return;
            }
        }
        else
        {
            //leftView
            [self clearViewInScrollSubViewWithTag:UIScrollViewLeftViewTag];
            UIView *leftViewSubView  = [centerView.subviews firstObject];
            //这里的leftViewSubView应该不为空
            if (leftViewSubView == nil) {
                if ([self.delegate respondsToSelector:@selector(cycleScrollView:viewForPageAtIndexPath:)]) {
                    leftViewSubView = [self.delegate cycleScrollView:self viewForPageAtIndexPath:leftIndex];
                }
            }
            else
            {
                [leftViewSubView removeFromSuperview];
            }
            [self addToScrollSubView:leftView subView:leftViewSubView];
            
            //centerView
            [self clearViewInScrollSubViewWithTag:UIScrollViewCenterViewTag];
            [centerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            //这里的centerViewSubView取最新的。
//            UIView *centerViewSubView = [rightView.subviews firstObject];
            UIView *centerViewSubView = nil;
            if (centerViewSubView == nil) {
                if ([self.delegate respondsToSelector:@selector(cycleScrollView:viewForPageAtIndexPath:)]) {
                    centerViewSubView = [self.delegate cycleScrollView:self viewForPageAtIndexPath:centerIndex];
                }
            }
            else
            {
                [centerViewSubView removeFromSuperview];
            }
            [self addToScrollSubView:centerView subView:centerViewSubView];
            
            //RightView
            [self clearViewInScrollSubViewWithTag:UIScrollViewRightViewTag];
            [rightView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            //这里的rightViewSubView取最新的。
            UIView *rightViewSubView = nil;
            if ([self.delegate respondsToSelector:@selector(cycleScrollView:viewForPageAtIndexPath:)]) {
                rightViewSubView = [self.delegate cycleScrollView:self viewForPageAtIndexPath:rightIndex];
            }
            [self addToScrollSubView:rightView subView:rightViewSubView];
        }
    }
    else
    {
        if (self.cycleScroll == NO && (centerIndex == 0 || centerIndex == self.numberOfPages - 2)) {
            if (centerIndex == 0) {
                //leftView
                [self clearViewInScrollSubViewWithTag:UIScrollViewLeftViewTag];
                //这里leftViewSubView取最新的
                UIView *leftViewSubView = nil;
                if ([self.delegate respondsToSelector:@selector(cycleScrollView:viewForPageAtIndexPath:)]) {
                    leftViewSubView = [self.delegate cycleScrollView:self viewForPageAtIndexPath:centerIndex];
                }
                [self addToScrollSubView:leftView subView:leftViewSubView];
                
                self.scrollView.contentOffset = CGPointMake(0, 0);
                self.lastContentOffset = self.scrollView.contentOffset;
                self.currentSelectedPageIndex = centerIndex;
                self.pageControl.currentPage = self.currentSelectedPageIndex;
                return;
            }
            else
            {
                //centerView
                [self clearViewInScrollSubViewWithTag:UIScrollViewCenterViewTag];
                //这里centerViewSubView取最新的
//                UIView *centerViewSubView = [leftView.subviews firstObject];
                UIView *centerViewSubView = nil;
                if (centerViewSubView == nil) {
                    if ([self.delegate respondsToSelector:@selector(cycleScrollView:viewForPageAtIndexPath:)]) {
                        centerViewSubView = [self.delegate cycleScrollView:self viewForPageAtIndexPath:centerIndex];
                    }
                }
                else
                {
                    [centerViewSubView removeFromSuperview];
                }
                [self addToScrollSubView:centerView subView:centerViewSubView];
                
                //leftView
                [self clearViewInScrollSubViewWithTag:UIScrollViewLeftViewTag];
                //这里的leftViewSubView取最新的。
                UIView *leftViewSubView = nil;
                if ([self.delegate respondsToSelector:@selector(cycleScrollView:viewForPageAtIndexPath:)]) {
                    leftViewSubView = [self.delegate cycleScrollView:self viewForPageAtIndexPath:leftIndex];
                }
                [self addToScrollSubView:leftView subView:leftViewSubView];
            }
        }
        else
        {
            //RightView
            [self clearViewInScrollSubViewWithTag:UIScrollViewRightViewTag];
            [rightView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            //这里的rightViewSubView应该不为空
            UIView *rightViewSubView  = [centerView.subviews firstObject];
            if (rightViewSubView == nil) {
                if ([self.delegate respondsToSelector:@selector(cycleScrollView:viewForPageAtIndexPath:)]) {
                    rightViewSubView = [self.delegate cycleScrollView:self viewForPageAtIndexPath:rightIndex];
                }
            }
            else
            {
                [rightViewSubView removeFromSuperview];
            }
            [self addToScrollSubView:rightView subView:rightViewSubView];
            
            //centerView
            [self clearViewInScrollSubViewWithTag:UIScrollViewCenterViewTag];
            //这里的centerViewSubView取最新的。
//            UIView *centerViewSubView = [leftView.subviews firstObject];
            UIView *centerViewSubView = nil;
            if (centerViewSubView == nil) {
                if ([self.delegate respondsToSelector:@selector(cycleScrollView:viewForPageAtIndexPath:)]) {
                    centerViewSubView = [self.delegate cycleScrollView:self viewForPageAtIndexPath:centerIndex];
                }
            }
            else
            {
                [centerViewSubView removeFromSuperview];
            }
            [self addToScrollSubView:centerView subView:centerViewSubView];
            
            //leftView
            [self clearViewInScrollSubViewWithTag:UIScrollViewLeftViewTag];
            //这里的leftViewSubView取最新的。
            UIView *leftViewSubView = nil;
            if ([self.delegate respondsToSelector:@selector(cycleScrollView:viewForPageAtIndexPath:)]) {
                leftViewSubView = [self.delegate cycleScrollView:self viewForPageAtIndexPath:leftIndex];
            }
            [self addToScrollSubView:leftView subView:leftViewSubView];
        }
    }
    
    self.scrollView.contentOffset = CGPointMake(self.bounds.size.width + self.pageSpace, 0);
    self.lastContentOffset = self.scrollView.contentOffset;
    self.pageControl.currentPage = self.currentSelectedPageIndex;
}

-(void)layoutSubChildViews
{
    [self resetUpChildView];
    
    if ([self.delegate respondsToSelector:@selector(numberOfPagesInCycleScrollView:)]) {
        self.numberOfPages = [self.delegate numberOfPagesInCycleScrollView:self];
        [self initPageControl:_numberOfPages];
    }
    if (self.currentSelectedPageIndex >= self.numberOfPages) {
        self.currentSelectedPageIndex = -1;
    }
    [self loadSubView];
    [self startAutoCycleScroll:_autoScroll];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self layoutSubChildViews];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self reloadSubView];
    if (!self.cycleScroll) {
        if (self.currentSelectedPageIndex == self.numberOfPages-1) {
            [self startAutoCycleScroll:NO];
        }
        else
        {
            [self startAutoCycleScroll:_autoScroll];
        }
    }
}

//手动关定时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self startAutoCycleScroll:NO];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self startAutoCycleScroll:_autoScroll];
}

-(void)reloadData
{
    [self layoutSubChildViews];
}

-(void)setStartPageIndex:(NSInteger)startPageIndex
{
    self.currentSelectedPageIndex = startPageIndex;
}

-(void)startAutoCycleScroll:(BOOL)autoCycleScroll
{
    @synchronized(self)
    {
        if (autoCycleScroll) {
            if (self.numberOfPages > 1 && self.timer == nil) {
                CGFloat timeInterval = scrollTimeInterval_s;
                if (self.scrollTimeInterval > 0) {
                    timeInterval = self.scrollTimeInterval;
                }
                NSLog(@"启用定时器");
                NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
                self.timer = timer;
            }
        }
        else
        {
            if (self.timer) {
                NSLog(@"关闭定时器");
                [self.timer invalidate];
                self.timer = nil;
            }
        }
    }
}

-(void)timerAction:(id)sender
{
    if (self.numberOfPages <= 1) {
        return;
    }
    
    WEAK_SELF(weakSelf);
    
    NSInteger numberOfPages = CYCLE_PAGE_VIEW_COUNT-1;
    if (self.cycleScroll == NO) {
        numberOfPages = MIN(self.numberOfPages, CYCLE_PAGE_VIEW_COUNT)-1;
    }
    
    CGFloat offsetX = self.lastContentOffset.x + self.bounds.size.width + self.pageSpace;
    CGFloat offsetY = 0;
    CGPoint offset = CGPointMake(MIN(offsetX, numberOfPages * (self.bounds.size.width + self.pageSpace)) , offsetY);
    [UIView animateWithDuration:0.8 animations:^{
        weakSelf.scrollView.contentOffset = offset;
    } completion:^(BOOL finished) {
        [weakSelf scrollViewDidEndDecelerating:weakSelf.scrollView];
    }];
}

-(void)setAutoScroll:(BOOL)autoScroll
{
    _autoScroll = autoScroll;
    if (autoScroll == NO) {
        [self startAutoCycleScroll:NO];
    }
}

-(void)removeFromSuperview
{
    self.autoScroll = NO;
    [super removeFromSuperview];
}

-(void)dealloc
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

@end
