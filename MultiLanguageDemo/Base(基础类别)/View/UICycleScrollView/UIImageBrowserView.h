//
//  UIImageBrowserView.h
//  UICycleScrollViewDemo
//
//  Created by captain on 17/1/8.
//  Copyright © 2017年 yzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIZoomScrollViewCell.h"

typedef NS_ENUM(NSInteger, UIImageViewContentType)
{
    UIImageViewContentTypeNull             = 0,
    //默认的普通模式,显示整个图片，以最大边为比例显示
    UIImageViewContentTypeScaleAspectFit    = 1,
    //默认的放大模式，显示部分图片，以最小边为比例过大显示。
    UIImageViewContentTypeScaleAspectFill   = 2,
    //原图显示
    UIImageViewContentTypeActualFill        = 3,
};

@class UIImageInfo;

typedef UIZoomScrollViewCell*(^showZoomImageViewBlock)(UIImageInfo *imageInfo, UIImageViewContentType normalType, UIImageViewContentType selectedType);

/*
 UIImageBrowserViewDelegate
 */

@class UIImageBrowserView;

@protocol UIImageBrowserViewDelegate <NSObject>

@optional

-(NSInteger)numberOfPagesInImageBrowserView:(UIImageBrowserView*)imageBrowserView;
-(UIView*)imageBrowserView:(UIImageBrowserView*)imageBrowserView viewForPageAtIndexPath:(NSInteger)index;
-(void)imageBrowserView:(UIImageBrowserView*)imageBrowserView didSelectedForPageAtIndex:(NSInteger)index;
-(void)imageBrowserView:(UIImageBrowserView*)imageBrowserView currentSelectedPageAtIndex:(NSInteger)index;

-(void)imageBrowserView:(UIImageBrowserView*)imageBrowserView longPressPageAtIndex:(NSInteger)index;

//这个是异步加载图片的方式,和上面的viewForPageAtIndexPath的代理方法一样，只是这个是异步传入UIImage
-(void)imageBrowserView:(UIImageBrowserView*)imageBrowserView zoomViewCell:(UIZoomScrollViewCell*)zoomViewCell atIndexPath:(NSInteger)index showZoomImageView:(showZoomImageViewBlock)showZoomImageView;

-(void)imageBrowserViewRemoveFromSuperView:(UIImageBrowserView*)imageBrowserView;

@end


/*
 UIImageBrowserViewImageInfo
 */
@interface UIImageInfo : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) CGSize imageSize;

-(instancetype)initWithImage:(UIImage *)image imageSize:(CGSize)imageSize;

@end

/*
 UIImageBrowserView
 */
@interface UIImageBrowserView : UIView

@property (nonatomic, weak) id<UIImageBrowserViewDelegate> delegate;

//默认是20.0
@property (nonatomic, assign) CGFloat pageSpace;

//默认为NO
@property (nonatomic, assign) BOOL autoScroll;

//默认为NO
@property (nonatomic, assign) BOOL cycleScroll;

//默认是0.1，也是pan时的minScale
@property (nonatomic, assign) CGFloat minScale;

//默认是2
@property (nonatomic, assign) CGFloat maxScale;

//默认为YES，YES表示图片按照最大比例缩放到全屏，NO表示按上面的minZoomScale,maxZoomScale进行缩放
@property (nonatomic, assign) BOOL autoFullScale;

//default is YES
@property (nonatomic, assign) BOOL showPageControl;

//默认是0.55
@property (nonatomic, assign) CGFloat panScaleChangeRatioRemove;

-(instancetype)initWithFrame:(CGRect)frame andSpecialScrollView:(UIScrollView*)scrollView;

-(void)reloadData;

-(void)setStartPageIndex:(NSInteger)startPageIndex;
@end
