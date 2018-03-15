//
//  UITableView+ZSZPlaceholder.m
//  FunSDKDemo
//
//  Created by 朱松泽 on 2018/1/10.
//  Copyright © 2018年 xiongmaitech. All rights reserved.
//

#import "UITableView+ZSZPlaceholder.h"

@implementation UITableView (ZSZPlaceholder)
- (void)tableViewDisplayView:(UIView *)displayView ifShowForRowCount:(NSInteger)count {
    
    if (count == 0) {
        self.backgroundView = displayView;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }else{
        self.backgroundView = nil;
    }
    
}
@end
