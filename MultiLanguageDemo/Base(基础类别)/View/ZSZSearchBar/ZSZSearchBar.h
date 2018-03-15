//
//  ZSZSearchBar.h
//  sdxt
//
//  Created by 朱松泽 on 2017/11/14.
//  Copyright © 2017年 com.gdtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZSZSearchBar;
@protocol ZSZSearchBarDelegate<NSObject>

@optional
- (BOOL)searchBarShouldBeginEditing:(ZSZSearchBar *)searchBar;
- (void)searchBarTextDidBeginEditing:(ZSZSearchBar *)searchBar;
- (BOOL)searchBarShouldEndEditing:(ZSZSearchBar *)searchBar;
- (void)searchBarTextDidEndEditing:(ZSZSearchBar *)searchBar;
- (void)searchBar:(ZSZSearchBar *)searchBar textDidChange:(NSString *)searchText;
- (void)searchBarSearchButtonClicked:(ZSZSearchBar *)searchBar;//确定按钮
- (void)searchBarCancelButtonClicked:(ZSZSearchBar *)searchBar;

@end

@interface ZSZSearchBar : UIView
// 文本的颜色
@property (nonatomic, strong) UIColor *textColor;
// 字体
@property (nonatomic, strong) UIFont *searchBarFont;
// 内容
@property (nonatomic, strong) NSString *text;
// 背景颜色
@property (nonatomic, strong) UIColor *searchBarColor;
// 默认文本
@property (nonatomic, strong) NSString *placeholder;
// 默认文本的颜色
@property (nonatomic, strong) UIColor *placeholderColor;
// 默认文本字体大小
@property (nonatomic, strong) UIFont *placeholderFont;
// 是否弹出键盘
@property (nonatomic, assign) BOOL isBecomeFirstResponder;
// 设置右边按钮的样式
@property (nonatomic, strong) UIImage *deleteImage;
// 设置代理
@property (nonatomic, weak) id<ZSZSearchBarDelegate>delegate;
// 
@property (nonatomic, strong) UITextField *textField;
@end
