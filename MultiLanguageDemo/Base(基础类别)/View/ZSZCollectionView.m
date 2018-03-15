//
//  ZSZCollectionView.m
//  FunSDKDemo
//
//  Created by 朱松泽 on 2018/1/10.
//  Copyright © 2018年 xiongmaitech. All rights reserved.
//

#import "ZSZCollectionView.h"

@implementation ZSZCollectionView

- (ZSZPlaceHolderView *)placeHolderView {
    if (_placeHolderView == nil) {
        _placeHolderView = [[ZSZPlaceHolderView alloc] init];
        _placeHolderView.myImageView.image = [UIImage imageNamed:@"网络刷新失败"];
        _placeHolderView.myLabel.text = @"暂无数据";
        _placeHolderView.myLabel.textColor = MainColor;
    }
    return _placeHolderView;
}

@end
