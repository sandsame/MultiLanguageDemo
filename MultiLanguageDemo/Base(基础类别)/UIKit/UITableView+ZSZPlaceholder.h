//
//  UITableView+ZSZPlaceholder.h
//  FunSDKDemo
//
//  Created by 朱松泽 on 2018/1/10.
//  Copyright © 2018年 xiongmaitech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (ZSZPlaceholder)
- (void)tableViewDisplayView:(UIView *)displayView ifShowForRowCount:(NSInteger)count;
@end
