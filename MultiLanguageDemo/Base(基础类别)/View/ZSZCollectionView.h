//
//  ZSZCollectionView.h
//  FunSDKDemo
//
//  Created by 朱松泽 on 2018/1/10.
//  Copyright © 2018年 xiongmaitech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICollectionView+ZSZPlaceholder.h"
#import "ZSZPlaceHolderView.h"
@interface ZSZCollectionView : UICollectionView
@property (nonatomic, strong) ZSZPlaceHolderView *placeHolderView;
@end
