//
//  UIMenuController+UITableViewCell.m
//  yxx_ios
//
//  Created by victor siu on 17/4/5.
//  Copyright © 2017年 GDtech. All rights reserved.
//

#import "UIMenuController+UITableViewCell.h"
#import <objc/runtime.h>

static char UIMenuController_UITableViewCell_Key;

@implementation UIMenuController (UITableViewCell)

-(UITableViewCell*)tableViewCell
{
    return objc_getAssociatedObject(self, &UIMenuController_UITableViewCell_Key);
}

-(void)setTableViewCell:(UITableViewCell *)tableViewCell
{
    objc_setAssociatedObject(self, &UIMenuController_UITableViewCell_Key, tableViewCell, OBJC_ASSOCIATION_ASSIGN);
}

//-(void)setTableViewCellMenuVisible:(BOOL)menuVisible animated:(BOOL)animated
//{
//    if (!menuVisible) {
//        self.tableViewCell = nil;
//    }
//    [self setMenuVisible:menuVisible animated:animated];
//}

@end
