//
//  ZSZNavigationController.m
//  sdxt
//
//  Created by 朱松泽 on 2017/11/13.
//  Copyright © 2017年 com.gdtech. All rights reserved.
//

#import "ZSZNavigationController.h"

@interface ZSZNavigationController ()

@end

@implementation ZSZNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationBar setBackgroundImage:[UIColor imageWithColor:MainColor] forBarMetrics:UIBarMetricsDefault];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil];
    [self.navigationBar setTitleTextAttributes:dic];
    self.navigationBar.tintColor = [UIColor whiteColor];
    
    // 去掉导航栏底下小黑线
//    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[UIImage new]];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
