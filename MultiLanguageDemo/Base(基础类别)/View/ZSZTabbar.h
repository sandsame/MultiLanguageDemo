//
//  ZSZTabbar.h
//  sdxt
//
//  Created by 朱松泽 on 2017/11/13.
//  Copyright © 2017年 com.gdtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZSZTabbar;
@protocol ZSZTabBarDelegate<NSObject>
- (void)addButtonClick:(ZSZTabbar *)tabBar;
@end

@interface ZSZTabbar : UITabBar
@property (nonatomic, weak) id<ZSZTabBarDelegate>zszDelegate;
@property (nonatomic, strong) UIView *topLine;
@end
