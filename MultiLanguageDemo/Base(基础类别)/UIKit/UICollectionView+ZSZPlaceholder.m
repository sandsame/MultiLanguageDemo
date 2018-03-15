//
//  UICollectionView+ZSZPlaceholder.m
//  FunSDKDemo
//
//  Created by 朱松泽 on 2018/1/10.
//  Copyright © 2018年 xiongmaitech. All rights reserved.
//

#import "UICollectionView+ZSZPlaceholder.h"

@implementation UICollectionView (ZSZPlaceholder)
- (void)collectionViewDisplayView:(UIView *)displayView ifShowForRowCount:(NSInteger)count {
    if (count == 0) {
        self.backgroundView = displayView;
    }else{
        self.backgroundView = nil;
    }
}
@end
