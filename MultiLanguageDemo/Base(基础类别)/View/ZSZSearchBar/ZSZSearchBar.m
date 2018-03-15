//
//  ZSZSearchBar.m
//  sdxt
//
//  Created by 朱松泽 on 2017/11/14.
//  Copyright © 2017年 com.gdtech. All rights reserved.
//

#import "ZSZSearchBar.h"
#define ItemSpace 10
#define LeftViewHeight 17
#define TextFieldTopSpace 2
@interface ZSZSearchBar()<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *leftView;
@property (nonatomic, strong) UIButton *deleteBtn;
@end

@implementation ZSZSearchBar
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpChildView];
        self.clipsToBounds = YES;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = frame.size.height / 2;
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.leftView.frame = CGRectMake(ItemSpace, (self.frame.size.height - LeftViewHeight) / 2.0, LeftViewHeight, LeftViewHeight);
    self.textField.frame = CGRectMake(self.leftView.frame.size.width + self.leftView.frame.origin.x + ItemSpace, TextFieldTopSpace, self.frame.size.width - (_leftView.frame.size.width + _leftView.frame.origin.x + ItemSpace) - (self.frame.size.height - 2*TextFieldTopSpace), self.frame.size.height - 2*TextFieldTopSpace);
    self.deleteBtn.frame =  CGRectMake(self.frame.size.width - self.frame.size.height - 2*TextFieldTopSpace, TextFieldTopSpace, self.frame.size.height - 2*TextFieldTopSpace, self.frame.size.height - 2*TextFieldTopSpace);
    
    
    
}

#pragma mark --- lazy load
- (UIImageView *)leftView {
    if (_leftView == nil) {
        _leftView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _leftView.image = [UIImage imageNamed:@"found_search.png"];
    }
    return _leftView;
}

- (UITextField *)textField {
    if (_textField == nil) {
        _textField = [[UITextField alloc] initWithFrame:CGRectZero];
        _textField.backgroundColor = [UIColor yellowColor];
        _textField.returnKeyType = UIReturnKeySearch;
        _textField.delegate = self;
        [_textField addTarget:self action:@selector(textFieldValueChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}

- (UIButton *)deleteBtn {
    if (_deleteBtn == nil) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setImage:[UIImage imageNamed:@"found_search_off.png"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

// set method
- (void)setIsBecomeFirstResponder:(BOOL)isBecomeFirstResponder {
    _isBecomeFirstResponder = isBecomeFirstResponder;
    if (_isBecomeFirstResponder) {
        [self.textField becomeFirstResponder];
    }
}

- (void)setSearchBarColor:(UIColor *)searchBarColor {
    _searchBarColor = searchBarColor;
    self.backgroundColor = _searchBarColor;
    self.textField.backgroundColor = _searchBarColor;
    self.leftView.backgroundColor = _searchBarColor;
    self.deleteBtn.backgroundColor = _searchBarColor;
}

- (void)setSearchBarFont:(UIFont *)searchBarFont {
    _searchBarFont = searchBarFont;
    self.textField.font = _searchBarFont;
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    self.textField.textColor = _textColor;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    [self.textField setValue:_placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.textField.placeholder = _placeholder;
}

- (void)setPlaceholderFont:(UIFont *)placeholderFont {
    _placeholderFont = placeholderFont;
    [self.textField setValue:_placeholderFont forKeyPath:@"_placeholderLabel.font"];
}

- (void)setText:(NSString *)text {
    _text = text;
    self.textField.text = _text;
}

- (void)setDeleteImage:(UIImage *)deleteImage {
    _deleteImage = deleteImage;
    [self.deleteBtn setImage:_deleteImage forState:0];
}


#pragma mark --- action
// textFieldValueChange
- (void)textFieldValueChange:(UITextField *)textField
{
    _text = textField.text;
    if ([self.delegate respondsToSelector:@selector(searchBar:textDidChange:)]) {
        [self.delegate searchBar:self textDidChange:textField.text];
    }
}

- (void)deleteClick:(UIButton *)delete
{
    self.textField.text = @"";
    if ([self.delegate respondsToSelector:@selector(searchBarCancelButtonClicked:)]) {
        [self.delegate searchBarCancelButtonClicked:self];
    }
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(searchBarShouldBeginEditing:)]) {
        [self.delegate searchBarShouldBeginEditing:self];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(searchBarTextDidBeginEditing:)]) {
        [self.delegate searchBarTextDidBeginEditing:self];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(searchBarShouldEndEditing:)]) {
        [self.delegate searchBarShouldEndEditing:self];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(searchBarTextDidEndEditing:)]) {
        [self.delegate searchBarTextDidEndEditing:self];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(searchBarSearchButtonClicked:)]) {
        [self.delegate searchBarSearchButtonClicked:self];
    }
    return YES;
}

#pragma mark --- other
- (void)setUpChildView {
    [self addSubview:self.leftView];
    [self addSubview:self.textField];
    [self addSubview:self.deleteBtn];
}


@end
