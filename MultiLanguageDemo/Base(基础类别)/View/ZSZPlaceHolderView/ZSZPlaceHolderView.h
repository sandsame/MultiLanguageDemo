//
//  ZSZPlaceHolderView.h
//  FunSDKDemo
//
//  Created by 朱松泽 on 2018/1/10.
//  Copyright © 2018年 xiongmaitech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ZSZPlaceHolderViewType) {
    ZSZPlaceHolderViewTypeTopImageBottomLabel = 0,
};

@interface ZSZPlaceHolderView : UIView
@property (nonatomic, strong) UIImageView *myImageView;
@property (nonatomic, strong) UILabel *myLabel;
@property (nonatomic, assign) ZSZPlaceHolderViewType placeHolderType;
@property (nonatomic, assign) NSInteger ImageViewWidth;
@end
