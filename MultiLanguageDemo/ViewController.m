//
//  ViewController.m
//  MultiLanguageDemo
//
//  Created by 朱松泽 on 2018/3/15.
//  Copyright © 2018年 朱松泽. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) UIButton *btn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.btn];

}

#pragma mark --- lazy load
- (UIButton *)btn {
    if (_btn == nil) {
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *title = NSLocalizedString(@"tabbar_homePage", nil);
        [_btn setTitle:title forState:0];
        _btn.frame = CGRectMake(0, 0, 100, 50);
        _btn.center = self.view.center;
        _btn.backgroundColor = [UIColor greenColor];
        [_btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn;
}

#pragma mark --- action
- (void)btnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
