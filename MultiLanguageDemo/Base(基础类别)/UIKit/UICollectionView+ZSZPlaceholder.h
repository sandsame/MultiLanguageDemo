//
//  UICollectionView+ZSZPlaceholder.h
//  FunSDKDemo
//
//  Created by 朱松泽 on 2018/1/10.
//  Copyright © 2018年 xiongmaitech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView (ZSZPlaceholder)
- (void)collectionViewDisplayView:(UIView *)displayView ifShowForRowCount:(NSInteger)count;
@end
