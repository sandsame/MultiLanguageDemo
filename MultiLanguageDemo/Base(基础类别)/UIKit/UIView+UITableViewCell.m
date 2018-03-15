//
//  UIView+UITableViewCell.m
//  yxx_ios
//
//  Created by victor siu on 17/3/23.
//  Copyright © 2017年 GDtech. All rights reserved.
//

#import "UIView+UITableViewCell.h"
#import "UITableViewCell+WeakReferenceTask.h"
#import <objc/runtime.h>

static char UIView_UITableViewCell_Key;

@implementation UIView (UITableViewCell)

-(UITableViewCell*)tableViewCell
{
    return objc_getAssociatedObject(self, &UIView_UITableViewCell_Key);
}

-(void)setTableViewCell:(UITableViewCell *)tableViewCell
{
    objc_setAssociatedObject(self, &UIView_UITableViewCell_Key, tableViewCell, OBJC_ASSOCIATION_ASSIGN);
    
    WEAK_SELF(weakSelf);
    [tableViewCell setWeakReferenceTask:^{
        objc_setAssociatedObject(weakSelf, &UIView_UITableViewCell_Key, nil, OBJC_ASSOCIATION_ASSIGN);
    }];
}

@end
