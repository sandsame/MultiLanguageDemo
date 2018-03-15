//
//  ZSZTableView.h
//  FunSDKDemo
//
//  Created by 朱松泽 on 2018/1/10.
//  Copyright © 2018年 xiongmaitech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableView+ZSZPlaceholder.h"
#import "ZSZPlaceHolderView.h"
@interface ZSZTableView : UITableView
@property (nonatomic, strong) ZSZPlaceHolderView *placeHolderView;
@end
