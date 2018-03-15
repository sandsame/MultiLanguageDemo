//
//  MainTabBarController.m
//  MultiLanguageDemo
//
//  Created by 朱松泽 on 2018/3/15.
//  Copyright © 2018年 朱松泽. All rights reserved.
//

#import "MainTabBarController.h"
#import "MineVC.h"
#import "HomePageVC.h"
#import "ZSZNavigationController.h"
@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpChildView];
}

- (void)setUpChildView  {
    HomePageVC *homePageVC = [[HomePageVC alloc] init];
    NSString *homePageTitle = NSLocalizedString(@"tabbar_homePage", nil);
    [self addChildController:homePageVC title:homePageTitle imageName:@"首页1" selectedImageName:@"首页" navVc:[ZSZNavigationController class]];

    NSString *mineTitle = NSLocalizedString(@"tabbar_mine", nil);
    MineVC *mineVC = [[MineVC alloc] init];
    [self addChildController:mineVC title:mineTitle imageName:@"我的1" selectedImageName:@"我的" navVc:[ZSZNavigationController class]];
}

- (void)addChildController:(UIViewController*)childController title:(NSString*)title imageName:(NSString*)imageName selectedImageName:(NSString*)selectedImageName navVc:(Class)navVc
{
    
    childController.title = title;
    childController.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childController.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12],NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    // 设置一下选中tabbar文字颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : MainColor }forState:UIControlStateSelected];
    
    UINavigationController* nav = [[navVc alloc] initWithRootViewController:childController];
    
    [self addChildViewController:nav];
}


@end
